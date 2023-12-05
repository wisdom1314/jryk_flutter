import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Container(
            height: ScreenUtil().setHeight(35),
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: TextField(
              // 进来默认不选中，键盘不弹出
              cursorColor: Colors.grey,
              autofocus: false,
              decoration: InputDecoration(
                hintText: '请输入设备号/车牌号/车架号查询',
                border: OutlineInputBorder(
                  // 去掉TextField边框
                  borderSide: BorderSide.none,
                  // 圆角和外层一样
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                // 获得输入的内容
                // this._keyWords = value;
              },
            ),
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite),
                  Text('收藏'),
                ],
              ),
              onPressed: () {
                // 处理收藏按钮点击事件
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CategoryButton(title: '全部', isSelected: true),
                  CategoryButton(title: '在线', isSelected: false),
                  CategoryButton(title: '离线', isSelected: false),
                  CategoryButton(title: '行驶', isSelected: false),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // 你的列表项数量
                itemBuilder: (context, index) {
                  return Container(
                      color: Colors.white, // 设置 Container 的颜色，即 ListTile 的背景颜色
                      child: const ListTile(
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              color: Color(0xFFf3f3f3),  // 设置分割线的颜色
                              thickness: 10.0, // 设置分割线的厚度
                            ),
                            SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '湘F46500',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Spacer(),
                                StatusCircle(status: '在线', color: Colors.green),
                              ],
                            ),
                            SizedBox(height: 12),
                            Divider(
                              color: Color(0xFFf3f3f3), //  设置分割线的颜色
                              thickness: 1.0, // 设置分割线的厚度
                            ),
                            SizedBox(height: 8),
                            Text('设备状态: 在线'),
                            SizedBox(height: 8),
                            Text('车主信息: --'),
                            SizedBox(height: 8),
                            Text('设备型号: JR-02 '),
                            SizedBox(height: 8),
                            Text('剩余电量: 100%'),
                            SizedBox(height: 8),
                            Text('发送间隔: 2分钟可续航1天'),
                            SizedBox(height: 8),
                            Text('最后上传: 2023-08-27 17:16:34'),
                            SizedBox(height: 8),
                            Text('基站定位: 2023-08-26 22:06:57 云南省曲靖市麒麟区翠峰北路宏强商务宾馆东北224米'),
                            SizedBox(height: 8),
                            Text('卫星定位: 2023-08-27 17:16:30 云南省曲靖市麒麟区雅和巷曲靖天福烟叶复烤有限责任公司东118'),
                            // 其他信息
                          ],
                        ),
                        // 其他列表项样式
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String title;
  final bool isSelected;

  const CategoryButton({required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 80,
        height: 80,
        child: ElevatedButton(
          onPressed: () {
            // 处理分类按钮点击事件
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                isSelected ? Colors.blue : Colors.white),
          ),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black),
          ),
        ));
  }
}

class StatusCircle extends StatelessWidget {
  final String status;
  final Color color;

  const StatusCircle({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: color,
      ),
      child: Text(
        status,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
