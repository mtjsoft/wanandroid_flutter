import 'dart:convert';

import 'package:firstflutterapp/UnknownPage.dart';
import 'package:firstflutterapp/browser.dart';
import 'package:firstflutterapp/chapters/chapters_list.dart';
import 'package:firstflutterapp/chapters/wxarticle_chapters.dart';
import 'package:firstflutterapp/config/GlobalConfig.dart';
import 'package:firstflutterapp/config/routes_name_config.dart';
import 'package:firstflutterapp/entity/chapters_entity.dart';
import 'package:firstflutterapp/entity/tree_type_entity.dart';
import 'package:firstflutterapp/generated/json/base/json_convert_content.dart';
import 'package:firstflutterapp/home/HomePage.dart';
import 'package:firstflutterapp/login/Login.dart';
import 'package:firstflutterapp/mine/MinePage.dart';
import 'package:firstflutterapp/mine/mine_collect.dart';
import 'package:firstflutterapp/preject/preject_list.dart';
import 'package:firstflutterapp/search/HotSearchPage.dart';
import 'package:firstflutterapp/search/search_result.dart';
import 'package:firstflutterapp/tree/tree_list.dart';
import 'package:firstflutterapp/tree/tree_type.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // 注册路由表
  final Map<String, WidgetBuilder> _routes = {
    "/": (context) => MyHomePage(),
    RoutersNameConfig.browser: (context) => Browser(),
    RoutersNameConfig.search_result: (context) =>
        SearchResultPage(ModalRoute.of(context).settings.arguments.toString()),
    RoutersNameConfig.chapter: (context) => ChaptersPage(list: JsonConvert.fromJsonAsT<List<ChaptersEntity>>(
        jsonDecode(ModalRoute.of(context).settings.arguments)["list"])),
    RoutersNameConfig.unknown_page: (context) => UnknownPage(),
    RoutersNameConfig.login_page: (context) => Login(),
    RoutersNameConfig.treeListPage: (context) => TreeListPage(
          list: JsonConvert.fromJsonAsT<List<TreeTypechild>>(
              jsonDecode(ModalRoute.of(context).settings.arguments)["list"]),
          index: jsonDecode(ModalRoute.of(context).settings.arguments)["index"],
          title: jsonDecode(ModalRoute.of(context).settings.arguments)["title"],
        ),
    RoutersNameConfig.collectListPage: (context) => MineCollectPage(),
    RoutersNameConfig.projectListPage: (context) => PrejectListPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '玩安卓',
        theme: ThemeData(
          primarySwatch: GlobalConfig.themeColor,
        ),
        //注册路由表
        routes: _routes,
        initialRoute: "/",
        //错误路由处理，返回UnknownPage
//        onUnknownRoute: (RouteSettings setting) => MaterialPageRoute(
//            builder: this._routes[RoutersNameConfig.unknown_page]),
//        onGenerateRoute: (RouteSettings settings) {
//          String routeName = settings.name;
//        }
        );
  }
}

// 首页嵌套路由
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0; //底部导航栏索引

  List<Widget> pages = [
    HomePage(),
    HotSearchPage(),
    TreeTypePage(),
    MinePage()
  ];

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
          BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('热搜')),
          BottomNavigationBarItem(icon: Icon(Icons.extension), title: Text('体系')),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('我的')),
        ],
      ),
    );
  }
}
