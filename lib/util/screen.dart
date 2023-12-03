import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 屏幕尺寸适配器
class Screen {
  Screen._();

  /// 根据屏幕宽度适配
  static double w(double width) {
    return ScreenUtil().setWidth(width);
  }

  /// 根据屏幕高度适配
  static double h(double height) {
    return ScreenUtil().setHeight(height);
  }

  /// 设置字体大小
  static double sp(double fontSize) {
    return ScreenUtil().setSp(fontSize);
  }

  static double get screenW {
    return ScreenUtil().screenWidth;
  }

  static double get screenH {
    return ScreenUtil().screenHeight;
  }

  static double get indicatorH {
    return ScreenUtil().bottomBarHeight;
  }

  static double get statusH {
    return ScreenUtil().statusBarHeight;
  }

}
