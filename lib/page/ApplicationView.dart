import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class ApplicationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('应用'),
          centerTitle: true,
        ),
        body: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '常用应用',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomColumn(imagePath:"lib/assets/images/cheliangchangtingdian.png", title: '电子围栏'),
                CustomColumn(imagePath:"lib/assets/images/cheliangguanli.png", title: '车辆管理'),
                CustomColumn(imagePath:"lib/assets/images/dianziweilan.png", title: '车辆常驻'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomColumn extends StatelessWidget {
  final String imagePath;
  final String title;

  const CustomColumn({required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // 处理每个栏目的点击事件
          print('你点击了 $title');
        },
        child: Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Colors.grey[300]!, // 设置淡灰色边框颜色
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 32.0,
                height: 32.0,
              ),
              SizedBox(height: 8.0),
              Text(
                title,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
