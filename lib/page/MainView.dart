import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jryk_flutter/page/ApplicationView.dart';
import 'package:jryk_flutter/page/GroupView.dart';
import 'package:jryk_flutter/page/MineView.dart';
import 'package:jryk_flutter/page/MonitorView.dart';

import '../util/Utils.dart';
import 'map/GaodeMapPage.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with WidgetsBindingObserver, RouteAware {
  int _currentIndex = 0;
  late List<Widget> _children;

  ///保存四个子页面的状态https://www.jianshu.com/p/7f4c286f366d
  late PageController _controller;

  bool isShowUploadDialog = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = PageController(initialPage: 0);
    _children =[GaodeMapPage(), GroupView(), ApplicationView(), MineView()];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  /// Called when the current route has been pushed.
  /// 当前的页面被push显示到用户面前 viewWillAppear.
  @override
  void didPush() {
    super.didPush();
    print('didPush()');
  }

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  /// 从当前页面push到另一个页面 viewWillDisappear.
  @override
  void didPushNext() {
    super.didPushNext();
    print('didPushNext()');
  }

  /// Called when the current route has been popped off.
  /// 当前的页面被pop viewWillDisappear.
  @override
  void didPop() {
    super.didPop();
    print('didPop()');
  }

  /// Called when the top route has been popped off, and the current route
  /// shows up.
  /// 上面的页面被pop后当前页面被显示时 viewWillAppear.
  @override
  void didPopNext() {
    super.didPopNext();
    print('didPopNext()');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 点击返回键的操作
        backDeskTop(); //设置为返回不退出app
        return false; //一定要return false
      },
      child: Scaffold(
        body: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          itemCount: _children.length,
          itemBuilder: (BuildContext context, int index) {
            return _children[index];
          },
          onPageChanged: (index) {
            if (index != _currentIndex) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: Color(0xFF009EFF),
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            _controller.jumpToPage(index);
            _onBottomBarClick(index);
          },
          items: [
            BottomNavigationBarItem(
              label: "监控",
              icon: _getImage("lib/assets/images/jiankong_hui.png"),
              activeIcon: _getImage("lib/assets/images/jiankong_lan.png"),
            ),
            BottomNavigationBarItem(
              label: "分组",
              icon: _currentIndex == 1
                  ? _getImage("lib/assets/images/fenzu_lan.png")
                  : _getImage("lib/assets/images/fenzu_hui.png"),
            ),
            BottomNavigationBarItem(
              label: "应用",
              icon: _currentIndex == 2
                  ? _getImage("lib/assets/images/yinyong_lan.png")
                  : _getImage("lib/assets/images/yinyong_hui.png"),
            ),
            BottomNavigationBarItem(
              label: "我的",
              icon: _getImage("lib/assets/images/wode_hui.png"),
              activeIcon: _getImage("lib/assets/images/wode_lan.png"),
            ),
          ],
        ),
      ),
    );
  }

  void _onBottomBarClick(int index) {
    _currentIndex = index;
  }

  Image _getImage(String path) {
    return Image.asset(path,
        width: ScreenUtil().setWidth(30),
        height: ScreenUtil().setWidth(30),
        fit: BoxFit.contain);
  }

  Future<bool> backDeskTop() async {
    try {
      final bool out = await Utils.methodChannel.invokeMethod('backDesktop');
      if (out) debugPrint('返回到桌面');
    } on PlatformException catch (e) {
      print("回退到安卓手机桌面失败${e.toString()}");
    }
    return Future.value(false);
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
