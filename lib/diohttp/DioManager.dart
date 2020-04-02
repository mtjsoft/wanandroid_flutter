import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:firstflutterapp/config/ApiUrl.dart';
import 'package:firstflutterapp/config/GlobalConfig.dart';
import 'package:firstflutterapp/diohttp/BaseEntity.dart';
import 'package:firstflutterapp/diohttp/BaseListEntity.dart';
import 'package:firstflutterapp/diohttp/ErrorEntity.dart';
import 'package:firstflutterapp/diohttp/NWMethod.dart';

class DioManager {
  static final DioManager _shared = DioManager._internal();

  factory DioManager() => _shared;

  Dio dio;

  DioManager._internal() {
    if (dio == null) {
      BaseOptions options = BaseOptions(
          baseUrl: ApiUrl.init().baseUrl,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          receiveDataWhenStatusError: false,
          connectTimeout: 30000,
          receiveTimeout: 3000,
          headers: {
            "version": '2.0.9',
            "Authorization": '',
          });
      dio = Dio(options);
      dio.interceptors
          .add(LogInterceptor(responseBody: GlobalConfig.isDebug)); //是否开启请求日志
      var cookieJar = CookieJar();
      dio.interceptors.add(CookieManager(cookieJar));
    }
  }

  // 请求，返回参数为 T
  // method：请求方法，NWMethod.POST等
  // path：请求地址
  // params：请求参数
  // success：请求成功回调
  // error：请求失败回调
  Future request<T>(NWMethod method, String path,
      {Map<String, dynamic> params,
      Function(T) success,
      Function(ErrorEntity) error}) async {
    try {
      Response response = await dio.request(path,
          queryParameters: params,
          options: Options(method: NWMethodValues[method]));
      if (response != null && response.statusCode == HttpStatus.ok) {
        BaseEntity entity = BaseEntity<T>.fromJson(response.data);
        if (entity.errorCode == 0) {
          success(entity.data);
        } else {
          error(ErrorEntity(
              errorCode: entity.errorCode, errorMsg: entity.errorMsg));
        }
      } else {
        error(ErrorEntity(errorCode: -1, errorMsg: "未知错误"));
      }
    } on DioError catch (e) {
      error(createErrorEntity(e));
    }
  }

  // 请求，返回参数为 List<T>
  // method：请求方法，NWMethod.POST等
  // path：请求地址
  // params：请求参数
  // success：请求成功回调
  // error：请求失败回调
  Future requestList<T>(NWMethod method, String path,
      {Map<String, dynamic> params,
      Function(List<T>) success,
      Function(ErrorEntity) error}) async {
    try {
      Response response = await dio.request(path,
          queryParameters: params,
          options: Options(method: NWMethodValues[method]));
      if (response != null && response.statusCode == HttpStatus.ok) {
        BaseListEntity entity = BaseListEntity<T>.fromJson(response.data);
        if (entity.errorCode == 0) {
          success(entity.data);
        } else {
          error(ErrorEntity(
              errorCode: entity.errorCode, errorMsg: entity.errorMsg));
        }
      } else {
        error(ErrorEntity(errorCode: -1, errorMsg: "未知错误"));
      }
    } on DioError catch (e) {
      error(createErrorEntity(e));
    }
  }

  // 错误信息
  ErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.CANCEL:
        {
          return ErrorEntity(errorCode: -1, errorMsg: "请求取消");
        }
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        {
          return ErrorEntity(errorCode: -1, errorMsg: "连接超时");
        }
        break;
      case DioErrorType.SEND_TIMEOUT:
        {
          return ErrorEntity(errorCode: -1, errorMsg: "请求超时");
        }
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        {
          return ErrorEntity(errorCode: -1, errorMsg: "响应超时");
        }
        break;
      case DioErrorType.RESPONSE:
        {
          try {
            int errCode = error.response.statusCode;
            String errMsg = error.response.statusMessage;
            return ErrorEntity(errorCode: errCode, errorMsg: errMsg);
//          switch (errCode) {
//            case 400: {
//              return ErrorEntity(errorCode: errCode, errorMsg: "请求语法错误");
//            }
//            break;
//            case 403: {
//              return ErrorEntity(errorCode: errCode, errorMsg: "服务器拒绝执行");
//            }
//            break;
//            case 404: {
//              return ErrorEntity(errorCode: errCode, errorMsg: "无法连接服务器");
//            }
//            break;
//            case 405: {
//              return ErrorEntity(errorCode: errCode, errorMsg: "请求方法被禁止");
//            }
//            break;
//            case 500: {
//              return ErrorEntity(errorCode: errCode, errorMsg: "服务器内部错误");
//            }
//            break;
//            case 502: {
//              return ErrorEntity(errorCode: errCode, errorMsg: "无效的请求");
//            }
//            break;
//            case 503: {
//              return ErrorEntity(errorCode: errCode, errorMsg: "服务器挂了");
//            }
//            break;
//            case 505: {
//              return ErrorEntity(errorCode: errCode, errorMsg: "不支持HTTP协议请求");
//            }
//            break;
//            default: {
//              return ErrorEntity(errorCode: errCode, errorMsg: "未知错误");
//            }
//          }
          } on Exception catch (_) {
            return ErrorEntity(errorCode: -1, errorMsg: "未知错误");
          }
        }
        break;
      default:
        {
          return ErrorEntity(errorCode: -1, errorMsg: error.message);
        }
    }
  }
}
