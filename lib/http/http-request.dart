import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jryk_flutter/widget/my-toast.dart';
import 'package:jryk_flutter/common/api.dart';
import 'package:jryk_flutter/common/config.dart';
import 'package:jryk_flutter/http/code.dart';
import 'package:jryk_flutter/http/result-bean.dart';
import 'package:jryk_flutter/http/return-body-entity.dart';
import 'package:jryk_flutter/common/api.dart';

class HttpRequest {
  static String _baseUrl = Api.BASE_URL;

  late BaseOptions options;
  late Dio dio;

  static HttpRequest? instance;
  HttpRequest._() {
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    options = BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: _baseUrl,
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: Duration(milliseconds: 10000),
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: Duration(milliseconds: 15000),
      //Http请求头.
      headers: getHeaders(),
      //表示期望以那种格式(方式)接受响应数据。接受四种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
    );
    dio = Dio(options);
  } // 私有构造函数

  static HttpRequest getInstance() {
    instance ??= HttpRequest._(); // 使用 null-aware assignment 进行初始化
    return instance!;
  }

  CancelToken cancelToken = CancelToken();

  void refreshToken() {

  }
  static Map<String, dynamic> getHeaders() {
    Map<String, dynamic> httpHeaders = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    return httpHeaders;
  }
  /*
   * get请求
   */
  get(url,
      { queryParameters,
        options,
        cancelToken,
        bool showDialog = false,
        Function(String data, String message)? successCallBack,
        Function(int code, String message)? errorCallBack}) async {
    Response? response;
    try {
      if (showDialog) {}
      response = await dio.get(url,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken);
    } on DioException catch (e) {
      formatError(e);
    }
    if (showDialog) {}
    if (response != null && null != response.data) {
      ReturnBodyEntity returnBodyEntity = ReturnBodyEntity.fromJson(
          json.decode(response.data));
      if (null != returnBodyEntity) {
        switch (returnBodyEntity.code) {
          case Code.SUCCESS:
            successCallBack!(
                jsonEncode(returnBodyEntity.data), returnBodyEntity.message ??
                '');
            break;
          case Code.TOKEN_OUT_OF_DATA:

          /// token过期
            errorCallBack!(
                returnBodyEntity.code ?? -1, returnBodyEntity.message ?? '');
            MyToast.showToast(returnBodyEntity.message ?? '');
            Future.delayed(Duration(milliseconds: 3000)).then((_) {
              /// 跳转登录页面
            });
            break;
          default:
            errorCallBack!(
                returnBodyEntity.code ?? -1, returnBodyEntity.message ?? '');
            MyToast.showToast(returnBodyEntity.message ?? '');
            break;
        }
      } else {
        errorCallBack!(Code.NETWORK_JSON_EXCEPTION, "网络数据有问题");
        MyToast.showToast("网络数据有问题");
      }
    } else {
      errorCallBack!(Code.NETWORK_ERROR, "网络不稳定，请稍后重试");
      MyToast.showToast("网络不稳定，请稍后重试");
    }
  }


  /*
   * post请求
   */
  post(url,
      {data,
        queryParameters,
        options,
        cancelToken,
        bool showDialog = false,
        Function(String data, String message)? successCallBack,
        Function(int code, String message)? errorCallBack}) async {
    Response? response;
    try {
      if (showDialog) {
      }
      response = await dio.post(url,
          queryParameters: queryParameters,
          data: data,
          options: options,
          cancelToken: cancelToken);
      print('888${response}');
      print('6666666 ${url}, ${queryParameters}, ${data}, ${options}');
    } on DioException catch (e) {
      formatError(e);
      print('66666667 ${e}');
    }
    if (showDialog) {
    }
    if (response!=null && null != response.data) {
      ReturnBodyEntity returnBodyEntity =
      ReturnBodyEntity.fromJson(json.decode(response.data));
      if (null != returnBodyEntity) {
        switch (returnBodyEntity.code) {
          case Code.SUCCESS:
            successCallBack!(
                jsonEncode(returnBodyEntity.data), returnBodyEntity.message??'');
            break;
          case Code.TOKEN_OUT_OF_DATA:
          /// token过期
            errorCallBack!(returnBodyEntity.code??-1, returnBodyEntity.message??'');
            MyToast.showToast(returnBodyEntity.message??'');
            Future.delayed(Duration(milliseconds: 3000)).then((_) {

            });
            break;
          default:
            errorCallBack!(returnBodyEntity.code??-1, returnBodyEntity.message??'');
            MyToast.showToast(returnBodyEntity.message??'');
            break;
        }
      } else {
        errorCallBack!(Code.NETWORK_JSON_EXCEPTION, "网络数据有问题");
        MyToast.showToast('网络数据有问题');
      }
    } else {
      print('34343434 ${response}');
      errorCallBack!(Code.NETWORK_ERROR, "网络不稳定，请稍后重试");
      MyToast.showToast('网络不稳定，请稍后重试');
    }
  }


  put(url,
      {data,
        queryParameters,
        options,
        cancelToken,
        bool showDialog = false,
        Function(String data, String message)? successCallBack,
        Function(int code, String message)? errorCallBack}) async {
    late Response response;
    try {
      if (showDialog) {

      }
      response = await dio.put(url,
          queryParameters: queryParameters,
          data: data,
          options: options,
          cancelToken: cancelToken);
    } on DioException catch (e) {
      formatError(e);
    }
    if (showDialog) {

    }
    if (null != response.data) {
      ReturnBodyEntity returnBodyEntity =
      ReturnBodyEntity.fromJson(json.decode(response.data));
      if (null != returnBodyEntity) {
        switch (returnBodyEntity.code) {
          case Code.SUCCESS:
            successCallBack!(
                jsonEncode(returnBodyEntity.data), returnBodyEntity.message??'');
            break;
          case Code.TOKEN_OUT_OF_DATA:

          /// token过期
            errorCallBack!(returnBodyEntity.code??-1, returnBodyEntity.message??'');
            MyToast.showToast(returnBodyEntity.message??'');
            Future.delayed(Duration(milliseconds: 3000)).then((_) {

            });
            break;
          default:
            errorCallBack!(returnBodyEntity.code??-1, returnBodyEntity.message??'');
            MyToast.showToast(returnBodyEntity.message??'');
            break;
        }
      } else {
        errorCallBack!(Code.NETWORK_JSON_EXCEPTION, "网络数据有问题");
        MyToast.showToast('网络数据有问题');
      }
    } else {
      errorCallBack!(Code.NETWORK_ERROR, "网络不稳定，请稍后重试");
      MyToast.showToast('网络不稳定，请稍后重试');
    }
  }


  delete(url,
      {data,
        queryParameters,
        options,
        cancelToken,
        bool showDialog = false,
        Function(String data, String message)? successCallBack,
        Function(int code, String message)? errorCallBack}) async {
    late Response response;
    try {
      if (showDialog) {

      }
      response = await dio.delete(url,
          queryParameters: queryParameters,
          data: data,
          options: options,
          cancelToken: cancelToken);
    } on DioException catch (e) {
      formatError(e);
    }
    if (showDialog) {

    }
    if (null != response.data) {
      ReturnBodyEntity returnBodyEntity =
      ReturnBodyEntity.fromJson(json.decode(response.data));
      if (null != returnBodyEntity) {
        switch (returnBodyEntity.code) {
          case Code.SUCCESS:
            successCallBack!(
                jsonEncode(returnBodyEntity.data), returnBodyEntity.message??'');
            break;
          case Code.TOKEN_OUT_OF_DATA:

          /// token过期
            errorCallBack!(returnBodyEntity.code??-1, returnBodyEntity.message??'');

            MyToast.showToast(returnBodyEntity.message??'');
            Future.delayed(Duration(milliseconds: 3000)).then((_) {

            });
            break;
          default:
            errorCallBack!(returnBodyEntity.code??-1, returnBodyEntity.message??'');
            MyToast.showToast(returnBodyEntity.message??'');
            break;
        }
      } else {
        errorCallBack!(Code.NETWORK_JSON_EXCEPTION, "网络数据有问题");
        MyToast.showToast('网络数据有问题');
      }
    } else {
      errorCallBack!(Code.NETWORK_ERROR, "网络不稳定，请稍后重试");
      MyToast.showToast('网络不稳定，请稍后重试');
    }
  }

  /*
   * 下载文件
   */
  downloadFile(urlPath, savePath) async {
    late Response response;
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
            //进度
            print("$count $total");
          });
      print('downloadFile success---------${response.data}');
    } on DioException catch (e) {
      print('downloadFile error---------$e');
      formatError(e);
    }
    return response.data;
  }

  /*
   * error统一处理
   */
  void formatError(DioException e) {
    /// 请求错误处理
    if (e.type == DioExceptionType.connectionTimeout) {
      /// Caused by a connection timeout.
      print("连接超时");
    } else if (e.type == DioExceptionType.sendTimeout) {
      /// It occurs when url is sent timeout.
      print("请求超时");
    } else if (e.type == DioExceptionType.receiveTimeout) {
      /// It occurs when receiving timeout.
      print("响应超时");
    }  else if (e.type == DioExceptionType.badCertificate) {
      /// Caused by an incorrect certificate as configured by [ValidateCertificate]
      print("非法证书");
    } else if (e.type == DioExceptionType.badResponse) {
      /// The [DioException] was caused by an incorrect status code as configured by
      /// [ValidateStatus].
      print("出现异常");
    } else if (e.type == DioExceptionType.cancel) {
      /// When the request is cancelled, dio will throw a error with this type.
      print("请求取消");
    } else if(e.type == DioExceptionType.connectionError) {
      /// Caused for example by a `xhr.onError` or SocketExceptions.
      print("链接错误");
    }
    else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误");
    }
  }

}