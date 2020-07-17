import 'package:flutter/material.dart';
import 'package:wandroid/ui/page/page_article_collect.dart';
import 'package:wandroid/ui/page/page_website_collect.dart';
import 'package:wandroid/utils/icons.dart';

class CollectPage extends StatefulWidget {
  @override
  _CollectPageState createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  final tabs = ["文章", "网站"];
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text( "我的收藏" ),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(article,size: 32,),),
              Tab(icon: Icon(website,size: 32,),)
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ArticleCollectPage(),
            WebsiteCollectPage()
          ],
        ),
      ),


    );
  }
}

