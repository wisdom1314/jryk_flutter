import 'package:flutter/material.dart';
import 'package:jryk_flutter/common/app-color.dart';
import 'package:jryk_flutter/common/app-image.dart';
import 'package:jryk_flutter/widget/my-appbar-view.dart';

class AboutUsPage extends StatefulWidget {


  @override
  _AboutUsPageState createState() {
    return _AboutUsPageState();
  }
}

class _AboutUsPageState extends State<AboutUsPage> {
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
      appBar:MyAppBarView(title: '关于我们'),
      body:  Container(
        height: double.infinity,
        color: AppColors.color_f4f4f4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                color: AppColors.color_ffffff,
                child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image(image: AssetImage(AppImages.assetsImgLoginLogo)),
                          Text('聚瑞云控秉承“正直 责任 务实 创新”的价值观，专注于研发物联网智能设备，北斗GPS设备、智能监控设备、SAAS平台、大数据分析，为交通运输、家居、物流、公共安全等领域提供全方位、专业化的物联网解决方案。全国统一热线: 4000654680')
                        ],
                      ),
                    )
                ),
              ),
            ) )
          ],
        )
      )
    );
  }
}