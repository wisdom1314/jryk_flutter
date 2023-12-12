import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:jryk_flutter/common/app-color.dart';
import 'package:jryk_flutter/util/screen.dart';
import 'package:jryk_flutter/widget/my-appbar-view.dart';

class PasswordPage extends StatefulWidget {


  @override
  _PasswordPageState createState() {
    return _PasswordPageState();
  }
}

class _PasswordPageState extends State<PasswordPage> {
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
      appBar: MyAppBarView(title: '修改密码',),
      body: Container(
        height: double.infinity,
        color: AppColors.color_f4f4f4,
        child: Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 10), child: ListView(
          children: [
            _buildInputCell('手机号码', '请输入手机号', ITextInputType.phone),
            _buildInputCell('新密码', '请输入新密码', ITextInputType.password),
            _buildInputCell('确认密码', '请输入确认密码', ITextInputType.password),
            _buildInputCell('验证码', '请输入验证码', ITextInputType.phone),

            SizedBox(height: 60), // 间隔
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                child: Text('确认修改', style: TextStyle(color: AppColors.color_ffffff, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.color_009eff,
                ),
                onPressed: () {
                },
              ),
            ),
          ],
        ),)

      ),
    );
  }

  Widget _buildInputCell(String labelText, String placeholder, ITextInputType keyBoardType) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Text(
            '* ',
            style: TextStyle(color: Colors.red), // 红色星号
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(labelText),
                Expanded(
                   flex: 1,
                   child: Padding(
                     padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                     child: LoginTextFieldWidget(
                       hitString: placeholder,
                       keyboardType: keyBoardType,
                       fieldCallBack: (content) {
                       },
                     ) ,
                   )
               ),
                Container(
                  child: labelText == '验证码'? GestureDetector(onTap: () {

                  },child: Text('获取验证码'),): null,
                )
              ],
            )
          ),
        ],
      ),
    );
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
