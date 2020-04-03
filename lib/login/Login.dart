import 'package:firstflutterapp/config/ApiUrl.dart';
import 'package:firstflutterapp/config/GlobalConfig.dart';
import 'package:firstflutterapp/config/routes_name_config.dart';
import 'package:firstflutterapp/diohttp/DioManager.dart';
import 'package:firstflutterapp/diohttp/NWMethod.dart';
import 'package:firstflutterapp/entity/user_info_entity.dart';
import 'package:firstflutterapp/utils/FluttertoastUtils.dart';
import 'package:firstflutterapp/utils/PrintUtils.dart';
import 'package:firstflutterapp/utils/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

class Login extends StatelessWidget {
  // 创建 focusNode
  FocusNode focusNode1 = new FocusNode();
  FocusNode focusNode2 = new FocusNode();

  String account = "";
  String password = "";

  bool register = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    //获取路由参数
    var args = ModalRoute.of(context).settings.arguments;
    if (args != null) {
      register = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('玩android${register ? "注册" : "登录"}'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[200],
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50,
                  child: Icon(
                    Icons.android,
                    size: 40,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 30, 24, 10),
                child: TextField(
                  focusNode: focusNode1,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5.0),
                    hintText: "请输入账号",
                    prefixIcon: Icon(Icons.account_circle),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  autofocus: false,
                  textInputAction: TextInputAction.done,
                  onChanged: (String input) {
                    // 输入文字改变监听
                    account = input;
                  },
                  maxLength: 12,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 10, 24, 10),
                child: TextField(
                  focusNode: focusNode2,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5.0),
                    hintText: "请输入密码",
                    prefixIcon: Icon(Icons.enhanced_encryption),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  autofocus: false,
                  textInputAction: TextInputAction.done,
                  onChanged: (String input) {
                    // 输入文字改变监听
                    password = input;
                  },
                  obscureText: true,
                  maxLength: 20,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 50, 24, 10),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    color: GlobalConfig.themeColor,
                    child: Text(
                      "${register ? "注册" : "登录"}",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      login(context);
                    },
                  ),
                ),
              ),
              Visibility(
                visible: !register,
                child: GestureDetector(
                  onTap: () {
                    // 跳注册
                    Navigator.pushNamed(context, RoutersNameConfig.login_page,arguments: true);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(24, 10, 24, 10),
                    child: Text(
                      "注册新账号",
                      style: TextStyle(color: GlobalConfig.themeColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 登录
  void login(BuildContext context) {
    if (account.isEmpty) {
      FluttertoastUtils.showToast("请输入账号");
    } else if (password.isEmpty) {
      FluttertoastUtils.showToast("请输入密码");
    } else {
      focusNode1.unfocus();
      focusNode2.unfocus();
      if (register) {
        // 注册
        DioManager().request<UserInfoEntity>(
            NWMethod.POST, ApiUrl.init().register, params: {
          "username": account,
          "password": password,
          "repassword": password
        }, success: (data) {
          // 注册成功，返回登录
          FluttertoastUtils.showToast("注册成功！请登录");
          Navigator.of(context).pop();
        }, error: (error) {
          FluttertoastUtils.showToast(error.errorMsg);
        });
      } else {
        DioManager().request<UserInfoEntity>(NWMethod.POST, ApiUrl.init().login,
            params: {"username": account, "password": password},
            success: (data) {
          // 保存用户昵称及ID、collectIds[]
          FluttertoastUtils.showToast("登录成功！");
          UserInfoEntity userInfoEntity = data;
          userInfoEntity.password = password;
          SharedPreferencesUtils.saveUserInfo(userInfoEntity);
          Navigator.of(context).pop(userInfoEntity);
        }, error: (error) {
          FluttertoastUtils.showToast(error.errorMsg);
        });
      }
    }
  }
}
