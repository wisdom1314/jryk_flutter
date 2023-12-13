import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uikit_forzzh/bubble/bubble.dart';
import 'package:flutter_uikit_forzzh/pop/popup_gravity.dart';
import 'package:flutter_uikit_forzzh/pop/popup_window.dart';
import 'package:flutter_uikit_forzzh/textview/marquee_view.dart';
import 'package:permission_handler/permission_handler.dart';

class GaodeMapPage extends StatefulWidget {
  const GaodeMapPage({Key? key}) : super(key: key);

  @override
  _GaodeMapPageState createState() => _GaodeMapPageState();
}

class _GaodeMapPageState extends State<GaodeMapPage> {
  static const AMapPrivacyStatement amapPrivacyStatement =
      AMapPrivacyStatement(hasContains: true, hasShow: true, hasAgree: true);
  static const AMapApiKey amapApiKeys = AMapApiKey(
      iosKey: '752810fd6ea362ce8381b8810d9c807f',
      androidKey: '6517aafcbcf8d3fdc880cb7ba7118721');

  AMapController? mapController;
  AMapFlutterLocation? location;

  PermissionStatus? permissionStatus;
  CameraPosition? currentLocation;
  int maptype = 0;
  bool isExpanded = true;
  GlobalKey btnKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // AMapFlutterLocation.setApiKey(
    //     "6517aafcbcf8d3fdc880cb7ba7118721", "752810fd6ea362ce8381b8810d9c807f");
    AMapFlutterLocation.updatePrivacyAgree(true);
    AMapFlutterLocation.updatePrivacyShow(true, true);

    requestPermission();
  }

  Future<void> requestPermission() async {
    final status = await Permission.location.request();
    permissionStatus = status;
    switch (status) {
      case PermissionStatus.denied:
        break;
      case PermissionStatus.granted:
        requestLocation();
        break;
      case PermissionStatus.limited:
        break;
      default:
        requestLocation();
        break;
    }
  }

  void requestLocation() {
    location = AMapFlutterLocation()
      ..setLocationOption(AMapLocationOption())
      ..onLocationChanged().listen((event) {
        print(event['latitude']);
        print(event['longitude']);
        if (event['latitude'] != null && event['longitude'] != null) {
          double? latitude = double.parse(event['latitude'] as String);
          double? longitude = double.parse(event['longitude'] as String);
          setState(() {
            currentLocation = CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 10,
            );
          });
        }
      })
      ..startLocation();
  }

  @override
  void dispose() {
    location?.destroy();
    super.dispose();
  }

  bool fistin = true;

  void _onLocationChanged(AMapLocation location) {
    if (null == location) {
      return;
    }
    setState(() {
      if (fistin && location.latLng.latitude > 0) {
        mapController!.moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            //中心点
            zoom: 14,
            target: location.latLng,
          ),
        ));
        fistin = false;
      }
    });
  }

  void _updateMessage(int mapType) {
    setState(() {
      maptype = mapType;
      print("huidiaodianjiweixing");
    });
  }

  @override
  Widget build(BuildContext context) {
    final AMapWidget map = AMapWidget(
      apiKey: amapApiKeys,
      onLocationChanged: _onLocationChanged,
      //定位小蓝点
      myLocationStyleOptions: MyLocationStyleOptions(
        true,
        circleFillColor: Colors.lightBlue,
        circleStrokeColor: Colors.blue,
        circleStrokeWidth: 1,
      ),
      // 普通地图normal,卫星地图satellite,夜间视图night,导航视图 navi,公交视图bus,
      mapType: maptype == 0 ? MapType.normal : MapType.satellite,
      // 缩放级别范围
      minMaxZoomPreference: MinMaxZoomPreference(3, 20),
      // 隐私政策包含高德 必须填写
      privacyStatement: amapPrivacyStatement,
      // 地图创建成功时返回AMapController
      onMapCreated: (AMapController controller) {
        mapController = controller;
      },
    );
    return Scaffold(
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
        actions: <Widget>[
          InkWell(
            child: Center(
              child: Row(
                children: [
                  Text('搜索', style: TextStyle(color: Colors.black)),
                  SizedBox(width: ScreenUtil().setWidth(15)),
                ],
              ),
            ),
            onTap: () {
              // 保持历史搜索记录
            },
          )
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.white], // 渐变色数组
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Center(
          child: SizedBox(
        child: Stack(
          children: [
            // Your map layer
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: map,
              ),
            ),
            // Floating buttons
            Positioned(
              top: 40.0,
              right: 16.0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: isExpanded ? 50 : 50,
                height: isExpanded ? 250 : 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: isExpanded
                      ? [
                          // Add your buttons here
                          FloatingButton(
                            key: btnKey,
                            icon: Icons.swap_calls,
                            label: '切换',
                            onTap: () {
                              RenderBox box = btnKey.currentContext
                                  ?.findRenderObject() as RenderBox;
                              showPopupWindow(
                                context,
                                bgColor: Colors.transparent,
                                clickOutDismiss: true,
                                gravity: PopupGravity.leftCenter,
                                targetRenderBox: box,
                                offsetY: 30,
                                duration: const Duration(milliseconds: 300),
                                childFun: (pop) {
                                  return StatefulBuilder(
                                      key: GlobalKey(),
                                      builder: (popContext, popState) {
                                        return Bubble(
                                          width: 200.0,
                                          height: 100.0,
                                          color: Colors.white,
                                          position: BubbleArrowDirection.right,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              MapTypeButton(
                                                imagePath:
                                                    "lib/assets/images/biaozhunditu.png",
                                                label: '标准地图',
                                                onTap: () {
                                                  _updateMessage(0);
                                                  pop.dismiss(popContext);
                                                },
                                              ),
                                              SizedBox(width: 18.0),
                                              MapTypeButton(
                                                imagePath:
                                                    "lib/assets/images/weixingditu.png",
                                                label: '卫星地图',
                                                onTap: () {
                                                  _updateMessage(1);
                                                  pop.dismiss(popContext);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                              );
                            },
                          ),
                          FloatingButton(
                              icon: Icons.list, label: '列表', onTap: () {}),
                          FloatingButton(
                              icon: Icons.message, label: '消息', onTap: () {}),
                          FloatingButton(
                              icon: Icons.info, label: '状态', onTap: () {}),
                          Positioned(
                            bottom: 16.0,
                            right: 16.0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              child: Text(
                                isExpanded ? "收起" : "展开",
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ]
                      : [
                          Positioned(
                            bottom: 16.0,
                            right: 16.0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              child: Text(
                                isExpanded ? "收起" : "展开",
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: (MediaQuery.of(context).size.width - 250) / 2,
              child: Container(
                width: 250.0, // 设置按钮宽度
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 车辆图片
                    Positioned(
                      left: 0,
                      child: Container(
                        width: 120.0, // 设置按钮宽度
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // 处理上一辆按钮的点击事件
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.white.withOpacity(0.7), // 设置背景颜色并添加半透明效果
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "lib/assets/images/shangyiliang.png",
                                width: 30.0,
                                height: 30.0,
                              ),
                              Text("上一辆",
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 下一辆按钮
                    Positioned(
                      right: 0,
                      child: Container(
                        width: 120.0, // 设置按钮宽度
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // 处理下一辆按钮的点击事件
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.white.withOpacity(0.7), // 设置背景颜色并添加半透明效果
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "lib/assets/images/xiayiliang.png",
                                width: 30.0,
                                height: 30.0,
                              ),
                              Text("下一辆",
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Image.asset(
                      "lib/assets/images/car.png",
                      width: 80.0,
                      height: 80.0,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

class MapTypeButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const MapTypeButton({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.all(2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  imagePath,
                  width: 60.0,
                  height: 32.0,
                ),
                SizedBox(height: 8),
                Text(label),
              ],
            )));
  }
}

class FloatingButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const FloatingButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.black),
            SizedBox(width: 8),
            Text(label, style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
