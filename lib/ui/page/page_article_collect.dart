import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wandroid/event/events.dart';
import 'package:wandroid/ui/widget/article_item.dart';
import 'package:wandroid/utils/api.dart';
import 'package:wandroid/utils/app_manager.dart';

class ArticleCollectPage extends StatefulWidget {
  @override
  _ArticleCollectPageState createState() => _ArticleCollectPageState();
}

class _ArticleCollectPageState extends State<ArticleCollectPage>
    with AutomaticKeepAliveClientMixin {
  bool _isHidden = false;

  ScrollController _scrollController = ScrollController();

  //收藏列表
  List _collects = [];
  var curPage = 0;
  var pageCount;

  StreamSubscription<CollectEvent> collectEventListen;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      var maxScroll = _scrollController.position.maxScrollExtent;

      var pixels = _scrollController.position.pixels;

      if (pixels == maxScroll && curPage < pageCount) {
        //加载更多
        _getCollects();
      }
    });
    collectEventListen = AppManager.eventBus.on<CollectEvent>().listen((event) {
      //页面没有被dispose
      if (mounted) {
        //取消收藏
        if (event.collect) {
          _collects.removeWhere((element) {
            return element['id'] == event.id;
          });
        }
      }
    });
    _getCollects();
  }

  @override
  void dispose() {
    collectEventListen?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  //tab切换不重置
  bool get wantKeepAlive =>true;

  _getCollects([bool refresh = false]) async {
    if (refresh) {
      curPage = 0;
    }
    var result = await Api.getArticleCollects(curPage);
    if (curPage == 0) {
      _collects.clear();
    }
    curPage++;
    var data = result['data'];
    pageCount = data['pageCount'];
    _collects.addAll(data['datas']);
    _isHidden = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: _isHidden,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        Offstage(
          //不为空就隐藏
          offstage: _collects.isNotEmpty,
          child: Center(
            child: Text("(＞﹏＜) 你还没有收藏任何内容......"),
          ),
        ),
        Offstage(
          //为空就隐藏
          offstage: _collects.isEmpty,
          child: RefreshIndicator(
            onRefresh: () => _getCollects(true),
            child: ListView.builder(
                //总是能滑动，因为数据少，listview无法滑动，
                //RefreshIndicator 就无法更新
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: _collects.length,
                controller: _scrollController,
                itemBuilder: (context, i) => _buildItem(i)),
          ),
        )
      ],
    );
  }

  _buildItem(int i) {
    //只收藏站内
    _collects[i]['id']=_collects[i]['originId'];
    _collects[i]['collect']=true;
    return ArticleItem(_collects[i]);
  }
}
