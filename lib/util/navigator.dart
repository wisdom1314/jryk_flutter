import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'navigator-route.dart';

class NavigatorUtil {
  /// 跳转页面
  static push(BuildContext context, Widget page) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
    return result;
  }

  /// 跳转并有返回值
  static Future getValuePush(BuildContext context, Widget page,
      {bool isAnmiate = true}) {
    Completer completer = Completer();
    Navigator.push(
        context,
        (isAnmiate)
            ? MaterialPageRoute(builder: (context) => page)
            : NavigatorRoute(builder: (context) => page))
        .then((value) {
      completer.complete(value);
    });
    return completer.future;
  }

  /// 跳转到指定界面，删除上面的
  static popUntil(BuildContext context, String name){
    Navigator.popUntil(context, ModalRoute.withName(name));
  }

  /// 跳转到指定界面，弹出中间部分
  static pushAndRemoveUtil(BuildContext context, Widget page){
    Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (_) => page), (route) => route == null);
  }

  /// 跳转到下个界面，pop自己
  static pushReplacement(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => page));
  }

  /// 没有动画
  static noAnimatePushReplacement(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration(milliseconds: 0),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      ),
    );
  }

}
