import 'package:flutter/material.dart';
import 'package:jryk_flutter/widget/my-appbar-view.dart';

class AgreementPage extends StatefulWidget {
  AgreementPage({Key? key}) : super(key: key);

  @override
  _AgreementPageState createState() {
    return _AgreementPageState();
  }
}

class _AgreementPageState extends State<AgreementPage> {
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
    return  Scaffold(
      appBar: MyAppBarView(title: '用户协议',),
      body: Container(

      ),
    );
  }
}