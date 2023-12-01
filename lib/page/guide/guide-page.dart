import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jryk_flutter/common/app-image.dart';
import 'package:jryk_flutter/common/app-color.dart';
import 'package:jryk_flutter/util/screen.dart';
import 'package:jryk_flutter/page/home/home.dart';
import 'package:jryk_flutter/util/navigator.dart';

class GuidePage extends StatefulWidget {
  @override
  _GuidePageState createState() {
    return _GuidePageState();
  }
}

class _GuidePageState extends State<GuidePage> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);


  List<Widget> _pages = [
    _buildPage("手机定位", "位置服务 尽在掌中", AppImages.guideFrist),
    _buildPage("位置监控", "位置查看 实时定位", AppImages.guideSecond),
    _buildPage("风控算法", "风险数据 随时掌握", AppImages.guideThrid),
    HomePage()
  ];

  static Widget _buildPage(String text, String infoText, String backgroundImage) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              backgroundImage, // 背景图资源路径
              fit: BoxFit.fitWidth, // 图片填充方式，可根据需要调整
            ),
          ),
          Positioned(child: Container(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(text, style: TextStyle( fontSize: Screen.sp(32), fontWeight: FontWeight.bold, color: AppColors.color_009eff ),)
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(infoText, style: TextStyle( fontSize: Screen.sp(20), fontWeight: FontWeight.w500, color: AppColors.color_383838 ),)
                  ],
                )
              ],
            ),
          ), bottom: Screen.indicatorH + Screen.h(100), left: 0, right: 0,)
        ],
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page == _pages.length - 1
          && _pageController.position.userScrollDirection == ScrollDirection.reverse) {
        NavigatorUtil.noAnimatePushReplacement(context, HomePage());
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return _pages[index];
            },
          ),
          Positioned(
            bottom: Screen.indicatorH + Screen.h(60),
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _pages.length-1; i++) {
      list.add(Container(
        width: _currentPage == i? Screen.w(20): Screen.w(10),
        height: Screen.w(10),
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: _currentPage == i? BorderRadius.circular(Screen.w(5)): BorderRadius.circular(Screen.w(2)),
          color: AppColors.color_009eff,
        ),
      ));
    }
    return list;
  }

}