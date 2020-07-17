import 'package:flutter/material.dart';

void main() {
  runApp(MainPage2());
}

class MainPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        ///默认首页的路由地址
        /// 如果指定了home，路由不能使用 /
        ///  "/": (_) {
        //          return MainPage2();
        //        },
        "page1": (_) {
          return MainPage2();
        },
        "page2": (_) => Page2()
      },
      title: "第一个页面",
      home: MainPageDetail(),
    );
  }
}

///2再加一层布局
class MainPageDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第一个页面"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/page1");
              //跳转动画
              Navigator.push(context, PageRouteBuilder(pageBuilder:
                  (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                //平移动画
//                return SlideTransition(
//                  child: Page2(),
//                  position:
//                  Tween(begin: Offset(1.0, 0.0), end: (Offset(0.0, 0.0)))
//                      .animate(animation),
//                );
                //透明度
                return FadeTransition(opacity: animation,
                    child: SlideTransition(
                      child: Page2(),
                      position:
                      Tween(
                          begin: Offset(1.0, 0.0), end: (Offset(0.0, 0.0)))
                          .animate(animation),
                    ));
              }));
            },
            child: Text("跳转第二个页面"),
          )
        ],
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第二个页面"),
      ),
      body: RaisedButton(
        onPressed: () {
          Navigator.pop(context, "ss");
        },
        child: Text("返回"),
      ),
    );
  }
}

///1创建一个builder包装
class MainPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "第一个页面",
        home: Builder(
          builder: bu,
        ));
  }

  Widget bu(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第一个页面"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Page2();
              })).then((value) => value.toString());
            },
            child: Text("跳转第二个页面"),
          )
        ],
      ),
    );
  }
}
