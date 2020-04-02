import 'EntityFactory.dart';

class BaseEntity<T> {
  int errorCode;
  String errorMsg;
  T data;

  BaseEntity({this.errorCode, this.errorMsg, this.data});

  factory BaseEntity.fromJson(json) {
    return BaseEntity(
      errorCode: json["errorCode"],
      errorMsg: json["errorMsg"],
      // data值需要经过工厂转换为我们传进来的类型
      data: EntityFactory.generateOBJ<T>(json["data"]),
    );
  }
}
