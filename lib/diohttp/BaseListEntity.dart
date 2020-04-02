import 'EntityFactory.dart';

class BaseListEntity<T> {
  int errorCode;
  String errorMsg;
  List<T> data;

  BaseListEntity({this.errorCode, this.errorMsg, this.data});

  factory BaseListEntity.fromJson(json) {
    List<T> mData = new List<T>();
    if (json['data'] != null) {
      //遍历data并转换为我们传进来的类型
      (json['data'] as List).forEach((v) {
        mData.add(EntityFactory.generateOBJ<T>(v));
      });
    }
    return BaseListEntity(
      errorCode: json["errorCode"],
      errorMsg: json["errorMsg"],
      data: mData,
    );
  }
}
