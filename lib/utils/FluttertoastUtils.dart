import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FluttertoastUtils {

  // 弹出toast
  static showToast(
    String msg, {
    Toast toastLength,
    ToastGravity gravity,
    double fontSize,
    Color backgroundColor,
    Color textColor,
  }) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: toastLength,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize);
  }

  // 取消toast
  static cancelToast(){
    Fluttertoast.cancel();
  }
}
