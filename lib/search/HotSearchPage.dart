import 'dart:convert';

import 'package:firstflutterapp/config/ApiUrl.dart';
import 'package:firstflutterapp/config/GlobalConfig.dart';
import 'package:firstflutterapp/config/routes_name_config.dart';
import 'package:firstflutterapp/diohttp/DioManager.dart';
import 'package:firstflutterapp/diohttp/NWMethod.dart';
import 'package:firstflutterapp/entity/friend_link_entity.dart';
import 'package:firstflutterapp/entity/hot_key_entity.dart';
import 'package:firstflutterapp/utils/FluttertoastUtils.dart';
import 'package:flutter/material.dart';

class HotSearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _HotSearchPageState();
  }
}

class _HotSearchPageState extends State<HotSearchPage> {
  String inputKey = "";

  List<HotKeyEntity> hotKeyList;
  List<FriendLinkEntity> friendLinkList;

  // 颜色
  List<Color> colors = GlobalConfig.colors;

  // 创建 focusNode
  FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHotKey();
    getFriendLink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('热搜'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: TextField(
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5.0),
                    hintText: "请输入搜索词",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Color(0xfff1f1f1),
                  ),
                  autofocus: false,
                  textInputAction: TextInputAction.search,
                  onChanged: (String input) {
                    // 输入文字改变监听
                    setState(() {
                      inputKey = input;
                    });
                  },
                  onEditingComplete: jumpSearchPage,
                ),
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.arrow_right,
                    color: Colors.blue,
                  ),
                  Text(
                    "热门搜索",
                    style: TextStyle(fontSize: 16.0),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: addHotKeyWidget(),
                ),
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.arrow_right,
                    color: Colors.blue,
                  ),
                  Text(
                    "常用网站",
                    style: TextStyle(fontSize: 16.0),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: addFriendLinkWidget(),
                ),
              ),
            ],
          ),
        ));
  }

  // 获取搜索热词
  void getHotKey() {
    DioManager().requestList<HotKeyEntity>(
        NWMethod.GET, ApiUrl.init().hotKeyList,
        params: {}, success: (data) {
      setState(() {
        hotKeyList = data;
      });
    }, error: (error) {
      FluttertoastUtils.showToast(error.errorMsg);
    });
  }

  // 获取常用网站
  void getFriendLink() {
    DioManager().requestList<FriendLinkEntity>(
        NWMethod.GET, ApiUrl.init().friendLinkList, params: {},
        success: (data) {
      setState(() {
        friendLinkList = data;
      });
    }, error: (error) {
      FluttertoastUtils.showToast(error.errorMsg);
    });
  }

  // 跳转搜索结果页
  void jumpSearchPage() {
    if (inputKey.isEmpty) {
      FluttertoastUtils.showToast("请输入关键词");
    } else {
      // 跳转搜索结果
      focusNode.unfocus();
      Navigator.pushNamed((context), RoutersNameConfig.search_result, arguments: inputKey);
    }
  }

  // 循环添加热搜组件
  List<Widget> addHotKeyWidget() {
    List<Widget> list = new List();
    for (var i = 0; i < hotKeyList.length; ++i) {
      var o = hotKeyList[i];
      Widget widget = GestureDetector(
        onTap: () {
          // 跳转搜索结果
          inputKey = o.name;
          jumpSearchPage();
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Text(o.name,
                style: TextStyle(color: (colors[i % colors.length]))),
          ),
        ),
      );

      list.add(widget);
    }

    return list;
  }

  // 循环添加常用网站组件
  List<Widget> addFriendLinkWidget() {
    List<Widget> list = new List();
    for (var i = 0; i < friendLinkList.length; ++i) {
      var o = friendLinkList[i];
      Widget widget = GestureDetector(
        onTap: () {
          Navigator.pushNamed((context), RoutersNameConfig.browser,
              arguments: jsonEncode({"url": o.link, "title": o.name}));
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Text(o.name,
                style: TextStyle(color: (colors[i % colors.length]))),
          ),
        ),
      );

      list.add(widget);
    }

    return list;
  }
}
