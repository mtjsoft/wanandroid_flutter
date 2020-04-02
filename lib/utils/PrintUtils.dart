import 'package:firstflutterapp/config/GlobalConfig.dart';

class PrintUtils {
  // 打印Debug日志
  static printf(Object object) {
    if (GlobalConfig.isDebug) {
      print(object);
    }
  }
}
