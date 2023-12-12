import 'package:flutter/material.dart';
import 'package:jryk_flutter/common/app-image.dart';
import 'package:jryk_flutter/util/screen.dart';
import 'package:jryk_flutter/common/app-color.dart';
import 'package:jryk_flutter/util/navigator.dart';
import 'package:jryk_flutter/page/guide/guide-page.dart';
import 'package:jryk_flutter/page/MainView.dart';
import 'package:jryk_flutter/service/service-common.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  late FocusNode _phoneFocusNode;
  late FocusNode _passFocusNode;

  String ? _name; // 用户名
  String ? _pass; // 密码
  bool _isHide = true;
  bool _isChecked = false;

  FocusNode _deviceFocusNode = new FocusNode();
  FocusNode _devicePassFocusNode = new FocusNode();
  String ? _device; // 设备号
  String ? _devicePass; // 密码
  bool _deviceIsHide = true;
  bool _deviceIsChecked = false;

  String loginTop = AppImages.loginTop;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _phoneFocusNode = new FocusNode();
    _passFocusNode = new FocusNode();
    _tabController.addListener(() {
      print('sdsdsd ${_tabController.index.toString()}');
      setState(() {
        if (_tabController.index == 0) {
          loginTop = AppImages.loginTop;
        } else if (_tabController.index == 1) {
          loginTop = AppImages.loginTopSecond; // 设置第二个标签的图像路径
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height, // 设置最小高度为屏幕高度
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.loginBack),
              fit: BoxFit.cover, // 让背景图片填满整个SingleChildScrollView
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(
              top: Screen.statusH + Screen.h(44 + 20),
              left: Screen.w(15),
              right: Screen.w(15),
              bottom: Screen.indicatorH, // 增加底部边距，避免内容被遮挡
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '您好',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  '欢迎来到聚瑞云控',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10) ),
                            image: DecorationImage(
                              image: AssetImage(loginTop),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        child: TabBar(
                          dividerColor: Colors.white,
                          controller: _tabController,
                          indicatorColor: AppColors.color_009eff,
                          indicatorWeight: 4,
                          indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(width: 4.0, color: AppColors.color_009eff),
                              insets: EdgeInsets.only(left: 20, right: 20),
                              borderRadius: BorderRadius.circular(2)// 下划线的宽度
                          ),
                          tabs: [
                            Tab(text: '账号登录'),
                            Tab(text: '设备号登录'),
                          ],
                          labelColor: AppColors.color_009eff,
                          unselectedLabelColor: AppColors.color_ffffff,
                          labelStyle: TextStyle(fontSize: Screen.sp(16)),
                        ),
                      ),
                      SizedBox(
                        height: Screen.h(400), // 控制 TabBarView 高度，根据实际情况调整
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Padding(padding: EdgeInsets.only(left: 20, top: 60, right: 20, bottom: 20),child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.color_efefef, // 背景色
                                    borderRadius: BorderRadius.circular(25.0), // 圆角值
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20, right: 20),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: LoginTextFieldWidget(
                                            focusNode: _phoneFocusNode,
                                            hitString: '请输入您的用户名',
                                            keyboardType: ITextInputType.text,
                                            fieldCallBack: (content) {
                                              _name = content;
                                            },
                                          ),
                                          flex: 1,
                                        )
                                      ],
                                    ),
                                  )
                                ),
                                SizedBox(height: 20),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.color_efefef, // 背景色
                                    borderRadius: BorderRadius.circular(25.0), // 圆角值
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20, right: 20),
                                    child:  Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: LoginTextFieldWidget(
                                            focusNode: _passFocusNode,
                                            hitString: '请输入密码',
                                            keyboardType: ITextInputType.password,
                                            ishidePwd: _isHide,
                                            fieldCallBack: (content) {
                                              _pass = content;
                                            },
                                          ),
                                          flex: 1,
                                        ),
                                        Container(
                                          child: IconButton(
                                              icon: !_isHide
                                                  ? Icon(
                                                Icons.visibility,
                                                color: AppColors.color_999999,
                                              )
                                                  : Icon(Icons.visibility_off, color: AppColors.color_999999,),
                                              onPressed: () {
                                                setState(() {
                                                  _isHide = !_isHide;
                                                });
                                              }),
                                          width: 40,
                                        )
                                      ],
                                    ),
                                  )

                                ),
                                SizedBox(height: 60),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _isChecked = !_isChecked;
                                        });
                                      },
                                      child: Container(
                                        width: 18.0,
                                        height: 18.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 1.0,
                                            color: AppColors.color_999999
                                          ),
                                        ),
                                        child: _isChecked
                                            ? Center(
                                          child: Container(
                                            width: 12.0,
                                            height: 12.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        )
                                            : null,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text('阅读并同意', style: TextStyle(fontSize: Screen.sp(12)),),
                                    GestureDetector(onTap: (){},child: Text('《用户协议》',style: TextStyle(color: AppColors.color_009eff, fontSize: Screen.sp(12),fontWeight: FontWeight.bold))),
                                    Text('和',style: TextStyle(fontSize: Screen.sp(12))),
                                    GestureDetector(onTap: (){},child: Text('《用户隐私协议》',style: TextStyle(color: AppColors.color_009eff, fontSize: Screen.sp(12), fontWeight: FontWeight.bold)))
                                  ],
                                ),
                                SizedBox(height: 40),
                                // 登录按钮
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    child: Text('登录', style: TextStyle(color: AppColors.color_ffffff, fontSize: 16)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.color_009eff,
                                    ),
                                    onPressed: () {
                                      doLogin(context);
                                      // NavigatorUtil.noAnimatePushReplacement(context, MainView());
                                    },
                                  ),
                                ),

                              ],
                            ),),
                            Padding(padding: EdgeInsets.only(left: 20, top: 60, right: 20, bottom: 20),child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: AppColors.color_efefef, // 背景色
                                      borderRadius: BorderRadius.circular(25.0), // 圆角值
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 20, right: 20),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: LoginTextFieldWidget(
                                              focusNode: _deviceFocusNode,
                                              hitString: '请输入您的设备号',
                                              keyboardType: ITextInputType.text,
                                              fieldCallBack: (content) {
                                                _device = content;
                                              },
                                            ),
                                            flex: 1,
                                          )
                                        ],
                                      ),
                                    )
                                ),
                                SizedBox(height: 20),
                                Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: AppColors.color_efefef, // 背景色
                                      borderRadius: BorderRadius.circular(25.0), // 圆角值
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 20, right: 20),
                                      child:  Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: LoginTextFieldWidget(
                                              focusNode: _devicePassFocusNode,
                                              hitString: '请输入密码',
                                              keyboardType: ITextInputType.password,
                                              ishidePwd: _deviceIsHide,
                                              fieldCallBack: (content) {
                                                _devicePass = content;
                                              },
                                            ),
                                            flex: 1,
                                          ),
                                          Container(
                                            child: IconButton(
                                                icon: !_deviceIsHide
                                                    ? Icon(
                                                  Icons.visibility,
                                                  color: AppColors.color_999999,
                                                )
                                                    : Icon(Icons.visibility_off, color: AppColors.color_999999,),
                                                onPressed: () {
                                                  setState(() {
                                                    _deviceIsHide = !_deviceIsHide;
                                                  });
                                                }),
                                            width: 40,
                                          )
                                        ],
                                      ),
                                    )

                                ),
                                SizedBox(height: 60),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _deviceIsChecked = !_deviceIsChecked;
                                        });
                                      },
                                      child: Container(
                                        width: 18.0,
                                        height: 18.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 1.0,
                                              color: AppColors.color_999999
                                          ),
                                        ),
                                        child: _deviceIsChecked
                                            ? Center(
                                          child: Container(
                                            width: 12.0,
                                            height: 12.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        )
                                            : null,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text('阅读并同意', style: TextStyle(fontSize: Screen.sp(12)),),
                                    GestureDetector(onTap: (){},child: Text('《用户协议》',style: TextStyle(color: AppColors.color_009eff, fontSize: Screen.sp(12),fontWeight: FontWeight.bold))),
                                    Text('和',style: TextStyle(fontSize: Screen.sp(12))),
                                    GestureDetector(onTap: (){},child: Text('《用户隐私协议》',style: TextStyle(color: AppColors.color_009eff, fontSize: Screen.sp(12), fontWeight: FontWeight.bold)))
                                  ],
                                ),
                                SizedBox(height: 40),
                                // 登录按钮
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    child: Text('登录', style: TextStyle(color: AppColors.color_ffffff, fontSize: 16)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.color_009eff,
                                    ),
                                    onPressed: () {
                                      NavigatorUtil.noAnimatePushReplacement(context, MainView());
                                    },
                                  ),
                                ),

                              ],
                            ),),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }

  hideFocus() {
    /// 失去焦点
    _phoneFocusNode.unfocus();
    _passFocusNode.unfocus();

    _deviceFocusNode.unfocus();
    _devicePassFocusNode.unfocus();
  }

   doLogin(BuildContext context) {
    Map<String, dynamic> _params = Map();
    _params['accName'] = '959062073296';
    _params['password'] = '073296';
    _params['loginModel'] = 6;
    ServiceCommon.login(_params).then((result) {
      print('sdsdsd ${result}');
    });
  }
}

/// 输入框
enum ITextInputType { phone, password, text }

typedef void ITextFieldCallBack(String content);

class LoginTextFieldWidget extends StatefulWidget {
  final ITextInputType keyboardType;
  final FocusNode ? focusNode;
  final String ? hitString;
  final ITextFieldCallBack ? fieldCallBack;
  final bool ishidePwd;

  LoginTextFieldWidget(
      {Key? key,
        this.keyboardType = ITextInputType.phone,
        this.focusNode,
        this.hitString,
        this.fieldCallBack,
        this.ishidePwd = true})
      : super(key: key);

  @override
  _LoginTextFieldWidgetState createState() {
    return _LoginTextFieldWidgetState();
  }
}

class _LoginTextFieldWidgetState extends State<LoginTextFieldWidget> {
  String _inputText = '';
  bool _hasdeleteIcon = false;
  bool _isPassword = false;

  TextInputType _getTextInput() {
    switch (widget.keyboardType) {
      case ITextInputType.phone:
        return TextInputType.phone;
        break;

      case ITextInputType.password:
        _isPassword = true;
        return TextInputType.text;
        break;
      case ITextInputType.text:
        return TextInputType.text;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = new TextEditingController.fromValue(
        TextEditingValue(
            text: _inputText,
            selection: new TextSelection.fromPosition(TextPosition(
                affinity: TextAffinity.downstream,
                offset: _inputText.length))));
    TextField textField = new TextField(
      controller: _controller,
      keyboardType: _getTextInput(),
      focusNode: widget.focusNode,
      onTap: () {
        _hasdeleteIcon = _inputText.isNotEmpty ? true : false;
      },
      onChanged: (str) {
        setState(() {
          _inputText = str;
          _hasdeleteIcon = (_inputText.isNotEmpty);
          widget.fieldCallBack!(_inputText);
        });
      },
      onEditingComplete: () {
        _hasdeleteIcon = false;
        widget.focusNode?.unfocus();
      },
      decoration:  InputDecoration(
        border: InputBorder.none,
        hintText: widget.hitString,
        hintStyle: new TextStyle(
          color: AppColors.color_a8a8a8,
          fontSize: 15,
        ),
        suffixIcon: _hasdeleteIcon
            ? new Container(
          width: 20.0,
          height: 20.0,
          child: new IconButton(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(0.0),
            iconSize: 18.0,
            icon: Icon(Icons.cancel),
            onPressed: () {
              setState(() {
                _inputText = "";
                _hasdeleteIcon = (_inputText.isNotEmpty);
                widget.fieldCallBack!(_inputText);
              });
            },
          ),
        )
            : new Text(""),
      ),
      obscureText: (_isPassword && widget.ishidePwd) ? true : false,
    );
    // TODO: implement build
    return textField;
  }
}
