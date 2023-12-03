import 'package:flutter/material.dart';
import 'package:jryk_flutter/common/app-image.dart';
import 'package:jryk_flutter/util/screen.dart';
import 'package:jryk_flutter/common/app-color.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height, // 设置最小高度为屏幕高度
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.loginBack),
              fit: BoxFit.cover, // 让背景图片填满整个SingleChildScrollView
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(
              top: Screen.statusH + Screen.h(44 + 20),
              left: Screen.w(15),
              right: Screen.w(15),
              bottom: Screen.indicatorH, // 增加底部边距，避免内容被遮挡
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '您好',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  '欢迎来到聚瑞云控',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        indicatorColor: AppColors.color_009eff,
                        indicatorWeight: 4,
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(width: 4.0, color: AppColors.color_009eff),
                          insets: EdgeInsets.only(left: 20, right: 20),
                          borderRadius: BorderRadius.circular(2)// 下划线的宽度
                        ),
                        tabs: [
                          Tab(text: '账号登录'),
                          Tab(text: '设备号登录'),
                        ],
                        labelColor: AppColors.color_009eff,
                        unselectedLabelColor: AppColors.color_333333,
                        labelStyle: TextStyle(fontSize: Screen.sp(16)),
                      ),
                      SizedBox(
                        height: Screen.h(400), // 控制 TabBarView 高度，根据实际情况调整
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Center(child: Text('账号密码登录')),
                            Center(child: Text('手机号登录')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );

  }
}