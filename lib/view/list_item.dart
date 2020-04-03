import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firstflutterapp/config/ApiUrl.dart';
import 'package:firstflutterapp/config/routes_name_config.dart';
import 'package:firstflutterapp/diohttp/DioManager.dart';
import 'package:firstflutterapp/diohttp/NWMethod.dart';
import 'package:firstflutterapp/entity/article_list_entity.dart';
import 'package:firstflutterapp/utils/FluttertoastUtils.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

typedef StateFunction = void Function(ArticleListData data, int position);

class ListItem {
  static ListItem _listItem;

  static ListItem init() {
    if (_listItem == null) {
      _listItem = new ListItem();
    }
    return _listItem;
  }

  // 项目列表item
  Widget renderProjectRow(
      BuildContext context,
      int index,
      List<ArticleListData> articleList,
      int type,
      StateFunction stateFunction) {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 150,
                child: CachedNetworkImage(
                    imageUrl: articleList[index].envelopePic,
                    placeholder: (context, url) => new Container(
                          child: new Center(
                            child: new CircularProgressIndicator(),
                          ),
                          width: 160.0,
                          height: 90.0,
                        ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.orange,
                            radius: 10,
                            child: Text(
                              articleList[index].shareUser == null ||
                                  articleList[index].shareUser.isEmpty
                                  ? articleList[index].author.toUpperCase().substring(0,1)
                                  : articleList[index].shareUser.toUpperCase().substring(0,1),
                              style: TextStyle(color: Colors.white,fontSize: 12),
                            ),
                          ),
                          Text(
                              articleList[index].shareUser == null ||
                                  articleList[index].shareUser.isEmpty
                                  ? articleList[index].author.substring(1)
                                  : articleList[index].shareUser.substring(1),
                              style: TextStyle(color: Colors.orange)),
                          Expanded(
                            child: Text(articleList[index].niceDate,
                                textAlign: TextAlign.right,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.blue)),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(articleList[index].title,
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.0)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(articleList[index].desc,
                            textAlign: TextAlign.left,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0)),
                      ),
                      Row(
                        children: <Widget>[
                          Text(articleList[index].chapterName,
                              style: TextStyle(color: Colors.blue)),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  if (articleList[index].collect) {
                                    // 已收藏，就取消收藏
                                    cancleCollect(stateFunction, articleList,
                                        index, type);
                                  } else {
                                    // 未收藏，添加收藏
                                    addCollect(
                                        stateFunction, articleList, index);
                                  }
                                },
                                child: Icon(
                                  Icons.favorite,
                                  color: articleList[index].collect
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  // 通用的列表item布局
  // type: 0 站内列表  1： 我的收藏列表
  Widget renderRow(
      BuildContext context,
      int index,
      List<ArticleListData> articleList,
      int type,
      StateFunction stateFunction) {
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
                    CircleAvatar(
                      backgroundColor: Colors.orange,
                      radius: 10,
                      child: Text(
                        articleList[index].shareUser == null ||
                                articleList[index].shareUser.isEmpty
                            ? articleList[index].author.toUpperCase().substring(0,1)
                            : articleList[index].shareUser.toUpperCase().substring(0,1),
                        style: TextStyle(color: Colors.white,fontSize: 12),
                      ),
                    ),
                    Text(
                        articleList[index].shareUser == null ||
                                articleList[index].shareUser.isEmpty
                            ? articleList[index].author.substring(1)
                            : articleList[index].shareUser.substring(1),
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
                          onTap: () {
                            if (articleList[index].collect) {
                              // 已收藏，就取消收藏
                              cancleCollect(
                                  stateFunction, articleList, index, type);
                            } else {
                              // 未收藏，添加收藏
                              addCollect(stateFunction, articleList, index);
                            }
                          },
                          child: Icon(
                            Icons.favorite,
                            color: articleList[index].collect
                                ? Colors.red
                                : Colors.grey,
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

  // 收藏站内文章
  void addCollect(StateFunction stateFunction,
      List<ArticleListData> articleList, int index) {
    DioManager().request<String>(NWMethod.POST,
        sprintf(ApiUrl.init().addCollect, [articleList[index].id]), params: {},
        success: (data) {
      articleList[index].collect = true;
      FluttertoastUtils.showToast("收藏成功");
      if (stateFunction != null) {
        stateFunction(articleList[index], index);
      }
    }, error: (error) {
      FluttertoastUtils.showToast(error.errorMsg);
    });
  }

  // 取消收藏  type: 0 站内列表  1： 我的收藏列表
  void cancleCollect(StateFunction stateFunction,
      List<ArticleListData> articleList, int index, int type) {
    String api;
    Map<String, dynamic> params;
    switch (type) {
      case 0:
        api = ApiUrl.init().unCollectOriginId;
        params = {};
        break;
      case 1:
        api = ApiUrl.init().unCollect;
        int originId = articleList[index].originId;
        params = {"originId": originId != null && originId > 0 ? originId : -1};
        break;
    }
    DioManager().request<String>(
        NWMethod.POST, sprintf(api, [articleList[index].id]), params: params,
        success: (data) {
      articleList[index].collect = false;
      FluttertoastUtils.showToast("取消收藏成功");
      if (stateFunction != null) {
        stateFunction(articleList[index], index);
      }
    }, error: (error) {
      FluttertoastUtils.showToast(error.errorMsg);
    });
  }
}
