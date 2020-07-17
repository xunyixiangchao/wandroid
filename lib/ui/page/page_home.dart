import 'package:banner_view/banner_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wandroid/ui/page/page_webview.dart';
import 'package:wandroid/ui/widget/article_item.dart';
import 'package:wandroid/utils/api.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //滑动控制器
  ScrollController _controller = ScrollController();

  //Banner图
  List banners = [];

  List articles = [];
  int curPage = 0;

  bool _isHide = true;

  ///总文章数有多少
  var totalCount = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      //获得ScrollController 监听控件 可以滚动的最大范围
      var maxScroll = _controller.position.maxScrollExtent;

      ///获得当前位置的像素值
      var pixels = _controller.position.pixels;

      ///当前滑动位置到达底部，同时还有更多数据
      if (maxScroll == pixels && curPage < totalCount) {
        ///加载更多
        _getArticleList();
      }
    });

    //下拉刷新请求
    _pullToRefresh();
  }

  @override
  Widget build(BuildContext context) {
    //帧布局
    return Stack(
      children: <Widget>[
        ///正在加载
        Offstage(
          offstage: !_isHide, //是否隐藏
          child: new Center(
            child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.red)),
          ),
        ),

        ///内容
        Offstage(
          offstage: _isHide,
          //SwipeRefresh 下拉刷新组件
          child: new RefreshIndicator(
              child: ListView.builder(
                //+1代表banner的条目
                itemCount: articles.length + 1,
                itemBuilder: (context, i) => _buildItem(i),
                controller: _controller,
              ),
              onRefresh: _pullToRefresh),
        ),
      ],
    );
  }

  /// 下拉刷新，请求文章列表与banner图
  Future<void> _pullToRefresh() async {
    curPage = 0;
    //组合两个异步任务，创建一个 都完成后的新的Future
    Iterable<Future> futures = [_getArticleList(), _getBanner()];
    await Future.wait(futures);
    _isHide = false;
    setState(() {});
    return null;
  }

  ///获取banner
  _getBanner([bool update = true]) async {
    var data = await Api.getBanner();
    if (data != null) {
      banners.clear();
      banners.addAll(data['data']);
      if (update) {
        setState(() {});
      }
    }
  }

  ///首页文章列表
  _getArticleList([bool update = true]) async {
    /// 请求成功是map，失败是null
    var data = await Api.getArticleList(curPage);
    if (data != null) {
      var map = data['data'];
      var datas = map['datas'];

      ///文章总数
      totalCount = map["pageCount"];

      if (curPage == 0) {
        articles.clear();
      }
      curPage++;
      articles.addAll(datas);

      ///更新ui
      if (update) {
        setState(() {});
      }
    }
  }

  Widget _buildItem(int i) {
    //获得屏幕宽高
    //MediaQuery.of(context).size.height
    if (i == 0) {
      return Container(
        height: 180,
        child: _bannerView(),
      );
    }
    var itemData = articles[i - 1];
    itemData['url']=itemData['link'];
    return ArticleItem(itemData);
  }

  Widget _bannerView() {
    //map:转换，将list中的每一个条目执行map方法参数接收的这个方法，这个方法返回T类型，
    //map方法最终会返回一个Iterable<T>
    List<Widget> list = banners.map((item) {
//      return Image.network(
//        item['imagePath'],
//        fit: BoxFit.cover,
//      ); //fit图片充满容器
      return InkWell(
        child: Image.network(
          item['imagePath'],
          fit: BoxFit.cover,
        ),
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context){
            return WebViewPage(item);
          }));
        },
      );
    }).toList();

    return list.isNotEmpty
        ? BannerView(
            list,
            //控制轮播时间
            intervalDuration: const Duration(seconds: 3),
          )
        : null;
  }
}
