import 'package:firstflutterapp/chapters/chapters_list.dart';
import 'package:firstflutterapp/config/ApiUrl.dart';
import 'package:firstflutterapp/config/GlobalConfig.dart';
import 'package:firstflutterapp/diohttp/DioManager.dart';
import 'package:firstflutterapp/diohttp/NWMethod.dart';
import 'package:firstflutterapp/entity/chapters_entity.dart';
import 'package:firstflutterapp/utils/FluttertoastUtils.dart';
import 'package:flutter/material.dart';

class ChaptersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ChaptersPageState();
  }
}

class _ChaptersPageState extends State<ChaptersPage> {
  // 公众号列表
  List<ChaptersEntity> _list = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChaptersList();
  }

  @override
  Widget build(BuildContext context) {
    //获取路由参数
    return DefaultTabController(
        length: _list.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text('公众号'),
            bottom: TabBar(
                isScrollable: true,
                tabs: _list.map((e) {
                  return Tab(text: e.name);
                }).toList()),
          ),
          body: TabBarView(
            children: _list.map((e) {
              return new ChaptersListPage(e.name, e.id);
            }).toList(),
          ),
        ));
  }

  // 获取公众号列表
  void getChaptersList() {
    DioManager().requestList<ChaptersEntity>(
        NWMethod.GET, ApiUrl.init().chaptersList,
        params: {}, success: (data) {
      setState(() {
        _list = data;
      });
    }, error: (error) {
      FluttertoastUtils.showToast(error.errorMsg);
    });
  }
}
