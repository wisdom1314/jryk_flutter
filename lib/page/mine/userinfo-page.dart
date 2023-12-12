import 'package:flutter/material.dart';
import 'package:jryk_flutter/common/app-color.dart';
import 'package:jryk_flutter/common/app-image.dart';
import 'package:jryk_flutter/widget/my-appbar-view.dart';
import 'package:image_picker/image_picker.dart';

class UserInfoPage extends StatefulWidget {


  @override
  _UserInfoPageState createState() {
    return _UserInfoPageState();
  }
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: MyAppBarView(title: '修改头像',),
      body: Container(
        color: AppColors.color_f4f4f4,
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: AppColors.color_ffffff,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('当前头像'),
                            Image(image: AssetImage(AppImages.memberPlaceholder),height: 50, width: 50,)
                          ],
                        ),
                        Divider(height: 1,color: AppColors.color_f4f4f4,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('更换头像'),
                            GestureDetector(onTap: () {
                              selectImageFromGallery();
                            }, child: Image(image: AssetImage(AppImages.memberPlaceholder),height: 50, width: 50,),)
                          ],
                        ),
                      ],
                    ),
                  )
                ),

                Padding(padding: EdgeInsets.only(bottom: 100),child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 120,
                      child: OutlinedButton(
                        onPressed: () {
                        },
                        child: Text('取消', style: TextStyle(color: AppColors.color_009eff, fontSize: 16)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 1, color: AppColors.color_009eff),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () {
                          // 处理确认按钮点击事件
                        },
                        child: Text('确认', style: TextStyle(color: AppColors.color_ffffff, fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.color_009eff,
                        ),

                      ),
                    )

                  ],
                ),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // 使用选择的图片
      print('选择的图片路径：${image.path}');
    } else {
      print('没有选择图片。');
    }
  }
}