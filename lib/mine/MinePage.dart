import 'package:cached_network_image/cached_network_image.dart';
import 'package:firstflutterapp/config/GlobalConfig.dart';
import 'package:firstflutterapp/config/routes_name_config.dart';
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

  String username = "Mtj";

  bool isLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferencesUtils.setUserName(username);

    FluttertoastUtils.showToast(SharedPreferencesUtils.getUserName());
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
                image: new NetworkImage(
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
                  visible: isLogin,
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            username,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: GlobalConfig.themeColor, fontSize: 18),
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "积分：1000",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "排名：1000",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !isLogin,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, RoutersNameConfig.login_page);
                      },
                      child: Text(
                        "点击登录",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
}
