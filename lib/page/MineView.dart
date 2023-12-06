import 'package:flutter/material.dart';
import 'package:jryk_flutter/common/app-color.dart';
import 'package:jryk_flutter/common/app-image.dart';
import 'package:jryk_flutter/widget/my-appbar-view.dart';

class MineView extends StatefulWidget {

  @override
  _MineViewState createState() {
    return _MineViewState();
  }
}

class _MineViewState extends State<MineView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List _rowList = [
    {'title': '修改密码', 'image': AppImages.minePass},
    {'title': '关于我们', 'image': AppImages.mineAboutUs},
    {'title': '用户协议', 'image': AppImages.mineAgreement},
    {'title': '隐私协议', 'image': AppImages.minePrivacy}
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: MyAppBarView(title: '我的', leftVisible: false),
      body: Container(
        height: double.infinity,
        color: AppColors.color_f4f4f4,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.color_ffffff,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(image: AssetImage(AppImages.memberPlaceholder))
                    ],
                  )
                ),
                SizedBox(height: 30,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.color_ffffff
                  ),
                  child: _buildListWidget()
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _buildListWidget() {
    List<Widget> listItems = [];

    for (var item in _rowList) {
      print( item);
      listItems.add(
        GestureDetector(
          onTap: () {
            // 处理每个列表项的点击事件
            String title = item['title'];
            // 根据标题执行相应操作
            if (title == '修改密码') {
              // 处理修改密码逻辑
            } else if (title == '关于我们') {
              // 处理关于我们逻辑
            }
            // 其他逻辑...
          },
          child: Container(
            padding: EdgeInsets.all(12),
            // margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.color_f4f4f4, // 下划线颜色
                  width: 1.0, // 下划线宽度
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image(image: AssetImage(item['image'])),
                    SizedBox(width: 12),
                    Text(
                      item['title'],
                      style: TextStyle(fontSize: 16, color: AppColors.color_333333),
                    ),
                  ],
                ),
                Icon(Icons.keyboard_arrow_right, color: AppColors.color_999999,), // 右箭头图标
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listItems,
    );
  }

}