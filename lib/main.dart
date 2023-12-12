import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jryk_flutter/common/app-color.dart';
import 'package:jryk_flutter/page/MainView.dart';
import 'package:jryk_flutter/page/guide/guide-page.dart';
import 'package:jryk_flutter/page/login/login-page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    /// 修改状态栏文字颜色为白色
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: '聚瑞云控',
          theme: ThemeData(
            useMaterial3: true,
          ),
          home: child,
        );
      },
      child:  LoginPage()
    );
  }
}

