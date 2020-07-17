import 'package:flutter/material.dart';

void main() {
  runApp(MainPage2());
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "第一个页面",
      home: Scaffold(
        appBar: AppBar(
          title: Text("第一个页面"),
        ),
        body: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                //这里会报错，context上下文是MainPage，上一层是root，
                //navigator.off方法中findAncestorStateOfType会取上级（父类）的对象，
                ///父类StatefulElement为root为非StatefulElement对象，再往上取，返回null
//                Navigator.push(context, MaterialPageRoute(builder: (_) {
//                  return Page2();
//                }));
                ///1获得MaterialApp中子view的上下文
                ///不能使用MaterialApp上下文，因为它的上一级是MainPage
                ///创建一个builder包装
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return Page2();
                }));
                /***只要保证context为MaterialApp下一级就可以进行跳转了**/

                ///2再加一层布局
                /// home:MainPageDetail();
                ///
                /// 3
              },
              child: Text("跳转第二个页面"),
            )
          ],
        ),
      ),
    );
  }
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
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Page2();
              })).then((value) => {debugPrint(value.toString())});

              ///使用命名路由跳转
              Navigator.pushNamed(context, "page2");
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
