import 'dart:convert';

import 'package:firstflutterapp/config/routes_name_config.dart';
import 'package:firstflutterapp/entity/article_list_entity.dart';
import 'package:firstflutterapp/utils/FluttertoastUtils.dart';
import 'package:flutter/material.dart';

class ListItem {
  static ListItem _listItem;

  static ListItem init() {
    if (_listItem == null) {
      _listItem = new ListItem();
    }
    return _listItem;
  }

  // item布局
  Widget renderRow(
      BuildContext context, int index, List<ArticleListData> articleList) {
    return GestureDetector(
      onTap: () => {
        Navigator.pushNamed((context), RoutersNameConfig.browser,
            arguments: jsonEncode({
              "url": articleList[index].link,
              "title": articleList[index].title
            }))
      },
      child: Card(
          margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          clipBehavior: Clip.antiAlias,
          elevation: 5.0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          //设置圆角
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.account_circle,
                      color: Colors.orange,
                    ),
                    Text(
                        articleList[index].shareUser.isEmpty
                            ? articleList[index].author
                            : articleList[index].shareUser,
                        style: TextStyle(color: Colors.orange)),
                    Expanded(
                      child: Text(articleList[index].niceDate,
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.blue)),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(articleList[index].title,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
                Row(
                  children: <Widget>[
                    Text(articleList[index].chapterName,
                        style: TextStyle(color: Colors.blue)),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () =>
                              {FluttertoastUtils.showToast(index.toString())},
                          child: Icon(
                            Icons.favorite,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
