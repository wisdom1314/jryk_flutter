import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class Utils {
  static const MethodChannel methodChannel =
      MethodChannel('com.eyerising.flutter.zhb');

  static int bigEndianInt(Uint8List array, int start) {
    int v = 0;
    for (int i = 0; i < 4; i++) {
      v = (v << 8) | (array[start + i] & 0xFF);
    }
    return v;
  }

  static String bytetoString(Uint8List data) {
    String str = "";
    for (var i = 0; i < data.length; i++) {
      String dataStr = data[i].toRadixString(16);
      if (dataStr.length < 2) {
        dataStr = "0" + dataStr;
      }
      str = str + dataStr;
    }
    return str;
  }

  static Uint8List createCmd(int cmd, Uint8List? data) {
    int len = 5;
    Uint8List buf = Uint8List(20);
    if (data != null) {
      len += data.length;
      buf.setRange(5, 5 + data.length, data);
      buf[4] = numtobyte(data.length);
    }

    int t = new DateTime.now().millisecondsSinceEpoch ~/ 1000;
    buf[0] = numtobyte(0x10);
    buf[1] = numtobyte(t >> 8);
    buf[2] = numtobyte(t);
    buf[3] = numtobyte(cmd);
    int sum = 0;
    for (int i = 0; i < len; i++) {
      sum += buf[i] & 0xFF;
    }
    buf[19] = numtobyte(sum);
    return buf;
  }

  static int numtobyte(int value) {
    int temp = value;
    while (temp > 127) {
      temp = (temp - 256);
    }
    while (temp < -128) {
      temp = (temp + 256);
    }
    return temp;
  }

  static String getNiceHexArray(List<int> bytes) {
    return '${bytes.reversed.map((i) => i.toRadixString(16).padLeft(2, '0')).join(':')}'
        .toUpperCase();
  }

  static String? getNiceManufacturerData(Map<int, List<int>>? data) {
    if (data == null || data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  static bool isChinaPhoneLegal(String str) {
    return new RegExp('^[1][3,4,5,6,7,8,9][0-9]{9}\$').hasMatch(str); //和后台正则统一
    return new RegExp(
            '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
        .hasMatch(str);
  }

  static int hexToInt(String hex) {
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("Invalid hexadecimal value");
      }
    }
    return val;
  }

  static bool isSameArray(Uint8List? array1, Uint8List array2) {
    if (array1 == null) return false;
    if (array1.length != array2.length) return false;
    for (int i = 0; i < array1.length; i++)
      if (array1[i] != array2[i]) return false;
    return true;
  }

  static bool isSameArray2(List<int>? array1, List<int> array2) {
    if (array1 == null) return false;
    if (array1.length != array2.length) return false;
    for (int i = 0; i < array1.length; i++)
      if (array1[i] != array2[i]) return false;
    return true;
  }

  static Future<Uint8List> encrypt(Uint8List data) async {
    if (Platform.isAndroid) {
      // return await crypto2(data, "encrypt");
      return data;
    } else {
      // return Crypto.getInstance().encrypt(data);
      return data;
    }
  }

  static Future<Uint8List> decrypt(Uint8List data) async {
    if (Platform.isAndroid) {
      // return await crypto2(data, "decrypt");
      return data;
    } else {
      // return Crypto.getInstance().decrypt(data);
      return data;
    }
  }

  static Future<Uint8List> crypto2(Uint8List data, String type) async {
    // print("$type==========>>>>>>>>>>>> $data");
    Map<String, dynamic> map = new Map();
    map['data'] = data;
    map['type'] = type;
    Uint8List result = await Utils.methodChannel.invokeMethod('Crypto', map);
    List<int> data2 = [];
    for (int i = 0; i < result.length; i++) {
      data2.add(numtobyte(result.elementAt(i)));
    }
    print("data2 = $data2");
    return result;
    // print("$type==========>>>>>>>>>>>> ${param ?? Uint8List(7)}");
  }

  static String getMac(String scanMac) {
    String newMac = "", tempMac = "";
    tempMac = scanMac.replaceAll(":", "");
    tempMac = tempMac.replaceAll("：", "");
    if (tempMac.length == 12) {
      for (int i = 0; i < 6; i++) {
        String temp = tempMac.substring(i * 2, i * 2 + 2);
        newMac += temp + ":";
      }
      newMac = newMac.substring(0, newMac.length - 1);
    } else {
      newMac = scanMac;
    }
    print("newMac = $newMac");
    return newMac;
  }

  static Future<String> getDeviceDetails() async {
    String deviceName = '';
    String deviceVersion = '';
    String identifier = '';
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.sdkInt.toString();
        identifier = build.androidId;
        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor;
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    return deviceName + "====" + deviceVersion + "====" + identifier;
  }

  static Color getRandomColor() {
    return Color.fromARGB(255, Random.secure().nextInt(200),
        Random.secure().nextInt(200), Random.secure().nextInt(200));
  }
  static Future<bool> requestBlePermissions() async {
    var isLocationGranted = await Permission.locationWhenInUse.request();
    print('checkBlePermissions, isLocationGranted=$isLocationGranted');


    var isBleGranted = await Permission.bluetooth.request();
    print('checkBlePermissions, isBleGranted=$isBleGranted');

    var isBleScanGranted = await Permission.bluetoothScan.request();
    print('checkBlePermissions, isBleScanGranted=$isBleScanGranted');
    //
    var isBleConnectGranted = await Permission.bluetoothConnect.request();
    print('checkBlePermissions, isBleConnectGranted=$isBleConnectGranted');
    //
    var isBleAdvertiseGranted = await Permission.bluetoothAdvertise.request();
    print('checkBlePermissions, isBleAdvertiseGranted=$isBleAdvertiseGranted');
    requestWritePermission();
    if(Platform.isIOS) {
      return isBleGranted == PermissionStatus.granted;

    }else {
      return isLocationGranted == PermissionStatus.granted &&
          isBleScanGranted == PermissionStatus.granted &&
          isBleConnectGranted == PermissionStatus.granted &&
          isBleAdvertiseGranted == PermissionStatus.granted;
    }
  }
  static Future<bool> requestPermission(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.bluetoothScan,
    ].request();
    print("bluetooth = ${statuses[Permission.bluetooth]}");
    print("bluetoothConnect = ${statuses[Permission.bluetoothConnect]}");
    print("location = ${statuses[Permission.location]}");
    print("storage = ${statuses[Permission.storage]}");

    // if (await Permission.bluetooth.status != PermissionStatus.granted) {
    //   openAppSettings();
    // }
    // if (await Permission.bluetooth.status.isGranted == false) {
    //   openAppSettings();
    // }
    bool isVerified = true;
    isVerified = await singleRequestPermission(Permission.bluetooth);
    if (Platform.isIOS) {
      isVerified = true;
    } else if (Platform.isAndroid) {
      isVerified = await singleRequestPermission(Permission.location);
      if (isVerified == false) {
       showToastMessage(context, "连接蓝牙设备需要打开位置权限！");
        return isVerified;
      }
    }

    isVerified = await singleRequestPermission(Permission.storage);
    if (isVerified == false) {
     showToastMessage(context, "连接蓝牙设备需要打开读写权限！");
      return isVerified;
    }
    if (isVerified == false) {
      isVerified = await singleRequestPermission(Permission.bluetoothConnect);
      if (isVerified == false) {
       showToastMessage(context, "连接蓝牙设备需要打开蓝牙权限！");
        return isVerified;
      }
    }

    return isVerified;
  }
  static void showToastMessage(BuildContext context, var msg) {
    if (msg == null) {
      return;
    }
    String message = "";
    if (msg is String) {
      message = msg.replaceAll("\"", "");
    } else if (msg is Map) {
      if (msg.containsKey('value')) {
        message = msg['value'];
      } else {
        message = msg.toString();
      }
    } else {
      message = msg.toString();
    }
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0
    );
  }

  static Future<bool> requestLocationPermission(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationAlways,
    ].request();
    print("location = ${statuses[Permission.locationAlways]}");
    bool isVerified = true;
    if (await Permission.locationAlways.isGranted) {
    } else {
      isVerified = false;
    }
    if (await Permission.bluetooth.isPermanentlyDenied) {
      openAppSettings();
    }
    return isVerified;
  }

  static Future<bool> singleRequestPermission(Permission permission) async {
    PermissionStatus status = await permission.status;
    bool flag = false;
    if (status.isGranted) {
      flag = true;
    } else {
      PermissionStatus p = await permission.request();
      if (p.isGranted) {
        flag = true;
      } else if (p.isPermanentlyDenied) {
        // openAppSettings();
        flag = false;
      } else {
        flag = false;
      }
    }
    return flag;
  }
  static Future<bool> requestWritePermission() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      int androidVersion = androidInfo.version.sdkInt;
      if (androidVersion < 32) {
        // For Android versions earlier than 12
        await Permission.storage.request();
        return await Permission.storage.isGranted;
      } else {
        // For Android 12 and later
        await Permission.manageExternalStorage.request();
        return await Permission.manageExternalStorage.isGranted;
      }
    }
    return false; // If the platform is not Android
  }

  static double curLongitude = 120.415145,
      curLatitude = 31.32951; //初始地址：苏州科技城总部


  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.





  ///从html中提取纯文本
  static String stripHT(String strHtml) {
    String txtcontent = strHtml.replaceAll("?[^>]+>", ""); //剔出的标签
    txtcontent =
        txtcontent.replaceAll("\\s*|\t|\r|\n", ""); //去除字符串中的空格,回车,换行符,制表符
    txtcontent = stripHT2(txtcontent);
    txtcontent = trimHtml(txtcontent);
    return txtcontent;
  }

  static String stripHT2(String strHtml) {
    String txtcontent = strHtml.replaceAll("</?[^>]+>", ""); //剔出<html>的标签
    txtcontent = txtcontent.replaceAll(
        "<a>\\s*|\t|\r|\n</a>", ""); //去除字符串中的空格,回车,换行符,制表符
    print("1111111111111");
    return txtcontent;
  }

  static String trimHtml(str) {
    str = str.replaceAll("/(\n)/g", "");
    str = str.replaceAll("/(\t)/g", "");
    str = str.replaceAll("/(\r)/g", "");
    str = str.replaceAll("/<\/?[^>]*>/g", "");
    str = str.replaceAll("/\s*/g", "");
    str = str.replaceAll("/<[^>]*>/g", "");
    print("22222222222222");
    return str;
  }

  static String getTimeDiff(String? time) {
    if (time == null || time.length == 0) {
      return "";
    }
    DateTime curTime = DateTime.now();
    DateTime articleTime = DateTime.parse(time);
    int day = curTime.difference(articleTime).inDays;
    int hour = curTime.difference(articleTime).inHours;
    int minute = curTime.difference(articleTime).inMinutes;
    String showTime = "";
    if (day != 0) {
      if (articleTime.year == curTime.year) {
        showTime = articleTime.toString().substring(5, 10);
      } else {
        showTime = articleTime.toString().substring(0, 10);
      }
    } else if (hour != 0) {
      showTime = "$hour小时前";
    } else if (minute != 0) {
      showTime = "$minute分钟前";
    } else {
      showTime = "刚刚";
    }
    return showTime;
  }

  static DateTime parseDate(String dateString) {
    String s = dateString.substring(5, 7);
    int day = int.parse(s);
    s = dateString.substring(12, 16);
    int year = int.parse(s);
    s = dateString.substring(17, 19);
    int hour = int.parse(s);
    s = dateString.substring(20, 22);
    int min = int.parse(s);
    s = dateString.substring(23, 25);
    int sec = int.parse(s);
    s = dateString.substring(8, 11).toUpperCase();
    int month;
    switch (s) {
      case "JAN":
        month = DateTime.january;
        break;
      case "FEB":
        month = DateTime.february;
        break;
      case "MAR":
        month = DateTime.march;
        break;
      case "APR":
        month = DateTime.april;
        break;
      case "MAY":
        month = DateTime.may;
        break;
      case "JUN":
        month = DateTime.june;
        break;
      case "JUL":
        month = DateTime.july;
        break;
      case "AUG":
        month = DateTime.august;
        break;
      case "SEP":
        month = DateTime.september;
        break;
      case "OCT":
        month = DateTime.october;
        break;
      case "NOV":
        month = DateTime.november;
        break;
      case "DEC":
        month = DateTime.december;
        break;
      default:
        month = DateTime.january;
        break;
    }
    DateTime mDateTime = DateTime.utc(year, month, day, hour, min, sec);
    return mDateTime;
  }

  static DateTime? parseRecordTime(String time) {
    if (time.length < 19) return null;
    String s = time.substring(0, 4);
    int year = int.parse(s);
    s = time.substring(5, 7);
    int month = int.parse(s);
    s = time.substring(8, 10);
    int day = int.parse(s);

    s = time.substring(11, 13);
    int hour = int.parse(s);
    s = time.substring(14, 16);
    int min = int.parse(s);
    s = time.substring(17, 19);
    int sec = int.parse(s);

    DateTime mDateTime = DateTime.utc(year, month, day, hour, min, sec);
    return mDateTime;
  }

  static Image getScanImage() {
    return Image.asset("lib/assets/images/scan.png",
        width: ScreenUtil().setWidth(80), height: ScreenUtil().setHeight(80));
  }

  static Image getCheckScanImage() {
    return Image.asset("lib/assets/images/scan.png",
        width: ScreenUtil().setWidth(50), height: ScreenUtil().setHeight(50));
  }

  static getTextStyle() {
    return TextStyle(color: Colors.blue);
  }

  ///0未知，1图片，2视频
  static int getImageOrVideo(String? url) {
    if (url == null) {
      return 0;
    } else {
      var idx = url.indexOf('.');
      if (idx == -1) {
        return 0;
      }
      List<String> imgExt = [".png", ".jpg", ".jpeg", ".bmp", ".gif"];
      bool isImage = false;
      for (int i = 0; i < imgExt.length; i++) {
        if (url.endsWith(imgExt.elementAt(i))) {
          isImage = true;
          break;
        }
      }
      if (isImage) {
        return 1;
      } else {
        return 2;
      }
    }
  }



  static String getDeviceMac(String data) {
    String? mac = "";
    Map<String, dynamic> map = json.decode(data);
    if (map.containsKey('MAC')) {
      mac = map['MAC'];
    }
    return mac == null ? "" : mac;
  }
}
