import 'package:flutter/material.dart';
import 'package:wandroid/ui/page/page_collect.dart';
import 'package:wandroid/ui/page/page_login.dart';
import 'package:wandroid/utils/api.dart';
import 'package:wandroid/utils/app_manager.dart';
import 'package:wandroid/event/events.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  void initState() {
    super.initState();
    AppManager.eventBus.on().listen((event) {
      setState(() {
        _username = (event as LoginEvent).username;
        AppManager.prefs.setString(AppManager.ACCOUNT, _username);
      });
    });

    _username = AppManager.prefs.getString(AppManager.ACCOUNT);
  }

  void _itemClick(Widget page) {
    //如果未登录 则进入登录界面
    var dstPage=_username==null?LoginPage():page;
    //如果page为null,则跳转
    if(dstPage!=null){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return dstPage;
      }));
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget userHeader = DrawerHeader(
      //bg
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: InkWell(
        //点击进入登录页
        onTap: () => _itemClick(null), //点击
        child: Column(
          children: <Widget>[
            ///头像
            Padding(
              padding: EdgeInsets.only(bottom: 18.0),
              child: CircleAvatar(
//                backgroundImage: AssetImage("assets/images/logo.png"),
                radius: 38.0,
              ),
            ),

            ///显示用户名
            Text(
              //前者为null就用它
              _username ?? "请先登录",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            )
          ],
        ),
      ),
    );
    return ListView(
      ///不设置会导致状态栏灰色
      padding: EdgeInsets.zero,
      children: <Widget>[
        userHeader,
        //收藏
        InkWell(
          onTap: () => _itemClick(CollectPage()),
          child: ListTile(
            leading: Icon(Icons.favorite),
            title: Text(
              "收藏列表",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
          child: Divider(
            color: Colors.grey,
          ),
        ),

        ///退出登录
        Offstage(
          offstage: _username == null,
          child: InkWell(
            onTap: () {
              setState(() {
                AppManager.prefs.setString(AppManager.ACCOUNT, null);
                Api.clearCookie();
                _username = null;
              });
            },
            child: ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                "退出登录",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

var _username = null;

