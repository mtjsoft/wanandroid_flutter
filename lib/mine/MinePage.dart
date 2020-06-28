import 'package:cached_network_image/cached_network_image.dart';
import 'package:firstflutterapp/config/ApiUrl.dart';
import 'package:firstflutterapp/config/GlobalConfig.dart';
import 'package:firstflutterapp/config/routes_name_config.dart';
import 'package:firstflutterapp/diohttp/DioManager.dart';
import 'package:firstflutterapp/diohttp/NWMethod.dart';
import 'package:firstflutterapp/entity/user_info_entity.dart';
import 'package:firstflutterapp/utils/FluttertoastUtils.dart';
import 'package:firstflutterapp/utils/shared_preferences.dart';
import 'package:flutter/material.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MinePageState();
  }
}

class _MinePageState extends State<MinePage> {
  UserInfoEntity _userInfoEntity;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferencesUtils.getUserInfo().then((user) {
      setState(() {
        _userInfoEntity = user;
      });
      // 登录成功，获取积分排名
      getRank();
    }).catchError((onError) {
      setState(() {
        _userInfoEntity = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://www.mtjsoft.cn/media/wanandroid/userbg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
            width: double.infinity,
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(Icons.android),
                ),
                Visibility(
                  visible: _userInfoEntity != null,
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            _userInfoEntity != null
                                ? "${_userInfoEntity.nickname}  LV${_userInfoEntity.level != null ? _userInfoEntity.level : 0}"
                                : "未登录",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: GlobalConfig.themeColor, fontSize: 18),
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "积分：${_userInfoEntity != null && _userInfoEntity.coinCount != null ? _userInfoEntity.coinCount : 0}",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "排名：${_userInfoEntity != null && _userInfoEntity.rank != null ? _userInfoEntity.rank : 0}",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: _userInfoEntity == null,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: () {
                        // 登录成功返回userInfoEntity
                        loginPage(context);
                      },
                      child: Text(
                        "点我登录",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // 我的收藏
              if (_userInfoEntity == null) {
                loginPage(context);
              } else {
                Navigator.pushNamed(context, RoutersNameConfig.collectListPage);
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: 50),
              color: Colors.grey[200],
              padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.star_border,
                    size: 18,
                  ),
                  Text(
                    "我的收藏",
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 12,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // 最新项目
              Navigator.pushNamed(context, RoutersNameConfig.projectListPage);
            },
            child: Container(
              margin: EdgeInsets.only(top: 1),
              color: Colors.grey[200],
              padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.assignment,
                    size: 18,
                  ),
                  Text(
                    "最新项目",
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 12,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // 公众号
              Navigator.pushNamed(context, RoutersNameConfig.chapter);
            },
            child: Container(
              margin: EdgeInsets.only(top: 1),
              color: Colors.grey[200],
              padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.dashboard,
                    size: 18,
                  ),
                  Text(
                    "公众号",
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 12,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: _userInfoEntity != null,
            child: GestureDetector(
                onTap: () {
                  // 退出登录
                  setState(() {
                    _userInfoEntity = null;
                  });
                  SharedPreferencesUtils.removeUserInfo();
                  DioManager().cookieJar.deleteAll();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 1),
                  color: Colors.grey[200],
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.settings_backup_restore,
                        size: 18,
                      ),
                      Text(
                        "退出登录",
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  // 获取积分排行
  void getRank() {
    DioManager().request<UserInfoEntity>(NWMethod.GET, ApiUrl.init().userCoin,
        params: {}, success: (data) {
      UserInfoEntity newUserInfo = _userInfoEntity;
      newUserInfo.rank = data.rank;
      newUserInfo.level = data.level;
      newUserInfo.coinCount = data.coinCount;
      setState(() {
        _userInfoEntity = newUserInfo;
      });
    }, error: (error) {
      FluttertoastUtils.showToast(error.errorMsg);
    });
  }

  // 跳登录页
  void loginPage(context) {
    Navigator.pushNamed(context, RoutersNameConfig.login_page).then((onValue) {
      if (onValue != null && onValue is UserInfoEntity) {
        setState(() {
          _userInfoEntity = onValue;
        });
        // 登录成功，获取积分排名
        getRank();
      }
    });
  }
}
