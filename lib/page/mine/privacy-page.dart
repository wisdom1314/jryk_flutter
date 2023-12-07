import 'package:flutter/material.dart';
import 'package:jryk_flutter/widget/my-appbar-view.dart';

class PrivacyPage extends StatefulWidget {
  PrivacyPage({Key? key}) : super(key: key);

  @override
  _PrivacyPageState createState() {
    return _PrivacyPageState();
  }
}

class _PrivacyPageState extends State<PrivacyPage> {
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
      appBar: MyAppBarView(title: '隐私协议',),
      body: Container(

      ),
    );
  }
}