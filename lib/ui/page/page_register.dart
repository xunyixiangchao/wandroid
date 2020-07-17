
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:wandroid/utils/api.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  FocusNode _userNameNode = FocusNode();
  FocusNode _pwdNode = FocusNode();
  FocusNode _pwd2Node = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _username, _pwd, _pwd2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("注册"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          //因为输入框会弹出软键盘，所以使用了一个滑动的ListView
          padding: EdgeInsets.fromLTRB(22, 18, 22, 22),
          children: <Widget>[
            _buildUserName(),
            _buildPwd(),
            _buildPwd2(),
            _buildRegister()
          ],
        ),
      ),
    );
  }

  Widget _buildUserName() {
    //以用户名输入框为默认焦点，则进入页面会自动 弹出输入框
    return TextFormField(
      autofocus: true,
      decoration: InputDecoration(labelText: "用户名", hintText: "请输入用户名"),
      //软键盘的动作类型
      textInputAction: TextInputAction.next,
      //按下action响应
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_pwdNode);
      },
      focusNode: _userNameNode,
      //校验输入内容的合法性
      validator: (String value) {
        if (value.length < 6 || value.length > 12 || value.trim().isEmpty) {
          return "用户名长度在6-12位";
        }
        _username = value;
      },
    );
  }

  Widget _buildPwd() {
    return TextFormField(
      decoration: InputDecoration(labelText: "密码", hintText: "请输入密码"),
      //软键盘的动作类型
      textInputAction: TextInputAction.next,
      //按下action响应
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_pwd2Node);
      },
      focusNode: _pwdNode,
      //校验输入内容的合法性
      validator: (String value) {
        if (value.length < 6 || value.length > 12 || value.trim().isEmpty) {
          return "密码长度在6-12位";
        }
        _pwd = value;
      },
    );
  }

  Widget _buildPwd2() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "确认密码",
        hintText: "请确认密码",
      ),
      //errorStyle: ),错误时的样式
      //软键盘的动作类型
      textInputAction: TextInputAction.done,
      //按下action响应
      onEditingComplete: () {},
      focusNode: _pwd2Node,
      //校验输入内容的合法性
      validator: (String value) {
        if (value.length < 6 || value.length > 12 || value.trim().isEmpty) {
          return "密码长度在6-12位";
        }
        _pwd2 = value;
        if (_pwd != _pwd2) {
          return "两次密码不一致";
        }
      },
    );
  }

  Widget _buildRegister() {
    return Container(
      height: 52,
      margin: EdgeInsets.only(top: 18),
      child: RaisedButton(
        onPressed: _click,
        color: Theme.of(context).primaryColor,
        child: Text(
          "注册",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  _click() async {
    //校验form
    if (_formKey.currentState.validate()) {
      //barrierDismissible是否允许按返回dismiss
      showDialog(context: context,barrierDismissible: false,builder: (_){
        return Center(child: CircularProgressIndicator() ,);
      });
      //可以去注册
      var result = await Api.register(_username, _pwd);
      Navigator.pop(context);
      if (result['errorCode'] == -1) {
        var error = result['errorMsg'];
        Toast.show(error,context,);
//        _scaffoldKey.currentState.showSnackBar(SnackBar(
//          content: Text(error),
//        ));
      }
      //点击注册按钮
      _userNameNode.unfocus();
      _pwdNode.unfocus();
      _pwd2Node.unfocus();
    }
  }
}
