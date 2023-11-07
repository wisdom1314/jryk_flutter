import 'package:logger/logger.dart';

/// 日志包装类
class MyLogger {
  late Logger _logger;

  static final MyLogger _instance = MyLogger._internal();

  factory MyLogger() {
    return _instance;
  }

  ///初始化
  MyLogger._internal() {
    _logger = Logger(
      printer: PrettyPrinter(),
    );
  }

  static final MyLogger logger = MyLogger._instance;

  void logDebug(String message) {
    _logger.d(message);
  }

  void logInfo(String message) {
    _logger.i(message);
  }

  void logWarning(String message) {
    _logger.w(message);
  }

  void logError(String message, {dynamic error}) {
    _logger.e(message, error: error);
  }

  void logCustom(String message) {
    _logger.t(message);
  }

}
