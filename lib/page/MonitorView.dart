import 'package:flutter/material.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

class MonitorView extends StatefulWidget {
  @override
  _MonitorViewState createState() {
    return _MonitorViewState();
  }
}

class _MonitorViewState extends State<MonitorView> {
  static const AMapPrivacyStatement amapPrivacyStatement =
  AMapPrivacyStatement(hasContains: true, hasShow: true, hasAgree: true);
  late AMapWidget map;
  ///在创建地图时设置privacyStatement属性

  static const AMapApiKey amapApiKeys = AMapApiKey(
      androidKey: '6517aafcbcf8d3fdc880cb7ba7118721',
      iosKey: '752810fd6ea362ce8381b8810d9c807f');

  @override
  void initState() {
    super.initState();
     map = AMapWidget(
      ///配置apiKey,设置为null或者不设置则优先使用native端配置的key
      apiKey: amapApiKeys,
      privacyStatement:amapPrivacyStatement,
    );
  }

  @override
  void dispose() {
    super.dispose();
    
  }

  Widget build(BuildContext context) {
    ///使用默认属性创建一个地图

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: map,
    );
  }
}