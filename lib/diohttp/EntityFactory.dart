import 'package:firstflutterapp/generated/json/base/json_convert_content.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (json == null) {
      return null;
    }
    return JsonConvert.fromJsonAsT<T>(json);
  }
}
