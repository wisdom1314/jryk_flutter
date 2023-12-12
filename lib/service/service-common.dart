import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:jryk_flutter/http/result-bean.dart';
import 'package:jryk_flutter/common/api.dart';
import 'base/remote-repo.dart';

class ServiceCommon {
  /// 登录
  /// 登录接口
  static Future<ResultBean<String>> login(Map<String, dynamic> params) {
    Completer<ResultBean<String>> completer = Completer();
    RemoteRepo.inst.httpRequest.post(Api.LOGIN_URL, data: json.encode(params),
        successCallBack: (data, msg) {
          String responseJson = json.decode(data);
          completer.complete(ResultBean(responseJson, msg));
        }, errorCallBack: (code, msg) {
          completer.completeError(ResultBean(code, msg));
        });
    return completer.future;
  }

}