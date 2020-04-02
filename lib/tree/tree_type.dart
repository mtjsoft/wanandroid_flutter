import 'dart:convert';

import 'package:firstflutterapp/config/ApiUrl.dart';
import 'package:firstflutterapp/config/GlobalConfig.dart';
import 'package:firstflutterapp/config/routes_name_config.dart';
import 'package:firstflutterapp/diohttp/DioManager.dart';
import 'package:firstflutterapp/diohttp/NWMethod.dart';
import 'package:firstflutterapp/entity/tree_type_entity.dart';
import 'package:firstflutterapp/utils/FluttertoastUtils.dart';
import 'package:flutter/material.dart';

// 体系
class TreeTypePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _TreeTypePageState();
  }
}

class _TreeTypePageState extends State<TreeTypePage> {
  int fristIndex = 0;
  int secendIndex = 0;
  List<TreeTypeEntity> _list = new List();

  // 二级高度
  double height = 50;
  List<Color> colors = GlobalConfig.colors;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fristIndex = 0;
    secendIndex = 0;
    getTreeTypeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('体系'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 3, //宽度
                minWidth: MediaQuery.of(context).size.width / 3,
                minHeight: double.infinity),
            color: Colors.grey[200],
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      fristIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    alignment: Alignment.centerLeft,
                    color: index == fristIndex
                        ? colors[index % colors.length]
                        : Colors.grey[200],
                    child: Text(
                      _list[index].name,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: index == fristIndex
                              ? Colors.white
                              : Colors.black38),
                    ),
                  ),
                );
              },
              itemCount: _list != null ? _list.length : 0,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, //每行列
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio:
                          (MediaQuery.of(context).size.width / 3 * 2 - 20) /
                              2 /
                              height),
                  itemCount: _list[fristIndex].children.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // 二级分类点击，跳体系分类列表
                        String json = jsonEncode({
                          "list": _list[fristIndex].children,
                          "index": index,
                          "title": _list[fristIndex].name
                        });
                        Navigator.pushNamed(
                            context, RoutersNameConfig.treeListPage,
                            arguments: json);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _list[fristIndex].children[index].name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: colors[index % colors.length]),
                        ),
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }

  // 获取体系分类列表
  void getTreeTypeList() {
    DioManager().requestList<TreeTypeEntity>(
        NWMethod.GET, ApiUrl.init().treeTypeList,
        params: {}, success: (data) {
      setState(() {
        _list = data;
      });
    }, error: (error) {
      FluttertoastUtils.showToast(error.errorMsg);
    });
  }
}
