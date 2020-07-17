import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:wandroid/event/events.dart';
import 'package:wandroid/ui/page/page_register.dart';
import 'package:wandroid/utils/api.dart';
import 'package:wandroid/utils/app_manager.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FocusNode _userNameNode = FocusNode();
  FocusNode _pwdNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String _username, _pwd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          //因为输入框会弹出软键盘，所以使用了一个滑动的ListView
          padding: EdgeInsets.fromLTRB(22, 18, 22, 22),
          children: <Widget>[
            _buildUserName(),
            _buildPwd(),
            _buildLogin(),
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
      onEditingComplete: () {},
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

  Widget _buildLogin() {
    return Container(
      height: 52,
      margin: EdgeInsets.only(top: 18),
      child: RaisedButton(
        onPressed: _click,
        color: Theme.of(context).primaryColor,
        child: Text(
          "登录",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildRegister() {
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: InkWell(
          child: Text(
            "注册账号",
            style: TextStyle(color: Colors.blue, fontSize: 18),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return RegisterPage();
            }));
          },
        ));
  }

  _click() async {
    //点击登录按钮
    _userNameNode.unfocus();
    _pwdNode.unfocus();
    //校验form
    if (_formKey.currentState.validate()) {
      //barrierDismissible是否允许按返回dismiss
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
      //可以去注册
      var result = await Api.login(_username, _pwd);
      Navigator.pop(context);
      if (result['errorCode'] == -1) {
        var error = result['errorMsg'];
        Toast.show(
          error,
          context,
        );
//        _scaffoldKey.currentState.showSnackBar(SnackBar(
//          content: Text(error),
//        ));
      }else if(result['errorCode'] == 0) {
        Toast.show("登录成功", context);
        Navigator.pop(context);
        AppManager.eventBus.fire(LoginEvent(_username));
      }
    }
  }
}
