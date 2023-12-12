
import 'package:jryk_flutter/http/http-request.dart';

class RemoteRepo {
  /// 单例对象
  static final inst = RemoteRepo._();

  /// 网络请求对象
  late HttpRequest _httpRequest;

  RemoteRepo._() {
    _init();
  }

  _init() {
    _httpRequest = HttpRequest.getInstance();
  }

  /// 获取网络请求对象
  HttpRequest get httpRequest {
    return _httpRequest;
  }
}
