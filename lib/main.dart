import 'package:flutter/material.dart';
import 'package:wandroid/ui/page/page_home.dart';
import 'package:wandroid/ui/widget/main_drawer.dart';
import 'package:wandroid/utils/app_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppManager.initApp();
    return MaterialApp(
      home: Scaffold(
        drawer:Drawer(
          child: MainDrawer(),
        ),
        appBar: AppBar(
          title: Text(
            '文章',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: HomePage(),
      ),
    );
  }
}

















