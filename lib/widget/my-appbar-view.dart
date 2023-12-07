import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jryk_flutter/common/app-color.dart';
import 'package:jryk_flutter/util/screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAppBarView extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final IconData leftIcon;
  final Color ? leftIconColor;
  final IconData ? rightIcon;
  final String ? rightTitle;
  final Color ? rightIconTitleColor;
  final Color titleColor;
  final double ? titleSize;
  final double ? contentHeight;
  final VoidCallback ? rightCallback;
  final VoidCallback ? leftCallback;
  final bool leftVisible;
  final bool rightVisible;
  /// 左边按钮是否隐藏
  final Color barBackColor;
  /// 导航栏颜色
  final bool isBrightnessDark;
  /// 状态栏颜色
  final bool showBottomLine;

  const MyAppBarView({
    Key? key,
    required this.title,
    this.titleColor = AppColors.color_333333,
    this.titleSize,
    this.leftIcon = Icons.keyboard_arrow_left,
    this.leftIconColor,
    this.contentHeight,
    this.rightIcon,
    this.rightTitle,
    this.rightIconTitleColor,
    this.rightCallback,
    this.leftCallback,
    this.leftVisible = true,
    this.rightVisible = true,
    this.barBackColor = AppColors.color_ffffff,
    this.isBrightnessDark = true,
    this.showBottomLine = true,
  })  : assert(title != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AppBarState();
  }

  @override
  Size get preferredSize => Size.fromHeight(contentHeight ??
      ScreenUtil().statusBarHeight + (Platform.isIOS ? 44 : Screen.h(44)));
}

class AppBarState extends State<MyAppBarView> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (widget.isBrightnessDark)
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white], // 渐变色数组
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // color: widget.barBackColor,
        height: widget.contentHeight ??
            ScreenUtil().statusBarHeight + (Platform.isIOS ? 44 : Screen.h(44)),
        child: SafeArea(
            top: true,
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        /// 左边按钮
                        Expanded(
                          flex: 1,
                          child: Visibility(
                            child: InkWell(
                              onTap: () {
                                if(widget.leftCallback != null) {
                                  widget.leftCallback!();
                                }else {
                                  Navigator.pop(context);
                                }

                              },
                              child: Container(
                                padding: EdgeInsets.all(Screen.w(10)),
                                child: Icon(
                                  widget.leftIcon,
                                  color: widget.leftIconColor,
                                ),
                              ),
                            ),
                            visible: widget.leftVisible,
                            /// 返回按钮是否隐藏
                          ),
                        ),

                        /// 中间文本内容
                        Expanded(
                          flex: 6,
                          child: Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: widget.titleColor,
                                fontSize: widget.titleSize ?? Screen.sp(17)),
                          ),
                        ),

                        /// 右边按钮
                        Expanded(
                          flex: 1,
                          child: widget.rightIcon != null
                              ? Visibility(
                            child: GestureDetector(
                              onTap: widget.rightCallback,
                              child: Container(
                                padding: EdgeInsets.all(Screen.w(10)),
                                child: Icon(
                                  widget.rightIcon,
                                  color: widget.rightIconTitleColor,
                                ),
                              ),
                            ),
                            visible: widget.rightVisible,
                          )
                              : widget.rightTitle != null
                              ? Visibility(
                            child: GestureDetector(
                              onTap: widget.rightCallback,
                              child: Container(
                                child: Text(
                                  widget.rightTitle ?? '',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: Screen.sp(14),
                                      color:
                                      widget.rightIconTitleColor),
                                ),
                              ),
                            ),
                            visible: widget.rightVisible,
                          )
                              : Container(),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    child: Container(
                      height: 0.5,
                      color: AppColors.color_d8d8d8,
                    ),
                    visible: widget.showBottomLine,
                  )
                ],
              ),
            )),
      ),
    );
  }
}
