import 'dart:convert';

import 'package:firstflutterapp/config/ApiUrl.dart';
import 'package:firstflutterapp/config/GlobalConfig.dart';
import 'package:firstflutterapp/config/routes_name_config.dart';
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
  List<ChaptersEntity> _list = new List();
  List<Color> colors = GlobalConfig.colors;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChaptersList();
  }

  @override
  Widget build(BuildContext context) {
    //获取路由参数

    return Scaffold(
        appBar: AppBar(
          title: Text('公众号'),
        ),
        body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, //每行列
              childAspectRatio: 1.0,
            ),
            itemCount: _list == null ? 0 : _list.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // 二级分类点击，跳体系分类列表
                  Navigator.pushNamed(context, RoutersNameConfig.chapter_list,
                      arguments: jsonEncode(
                          {"id": _list[index].id, "title": _list[index].name}));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        //卡片阴影
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(4.0, 4.0),
                            blurRadius: 4.0)
                      ]),
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(10, index < 4 ? 10 : 0,
                      (index + 1) % 4 == 0 ? 10 : 0, 10),
                  child: Text(
                    _list[index].name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                ),
              );
            }));
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
