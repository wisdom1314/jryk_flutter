import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    AMapFlutterLocation.setApiKey(
        "6517aafcbcf8d3fdc880cb7ba7118721", "752810fd6ea362ce8381b8810d9c807f");
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
        double? latitude = double.parse(event['latitude'] as String);
        double? longitude = double.parse(event['longitude'] as String);
        print("经纬度=======$latitude");
        if (latitude != null && longitude != null) {
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
    mapController!.clearDisk();
    super.dispose();
  }
  bool fistin=true;
  void _onLocationChanged(AMapLocation location) {
    if (null == location) {
      return;
    }
     setState(() {
       if(fistin&&location.latLng.latitude>0){
         mapController!.moveCamera(CameraUpdate.newCameraPosition(
           CameraPosition(
             //中心点
             target: location.latLng,
           ),
         ));
         fistin=false;
       }

     });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "高德地图",
          style: TextStyle(),
        ),
      ),
      body: Center(
          child: SizedBox(
            child: AMapWidget(
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
              mapType: MapType.normal,
              // 缩放级别范围
              minMaxZoomPreference: MinMaxZoomPreference(3, 20),
              // 隐私政策包含高德 必须填写
              privacyStatement:amapPrivacyStatement,
              // 地图创建成功时返回AMapController
              onMapCreated: (AMapController controller) {
                mapController = controller;
              },
            ),
          )),
    );
  }
}
