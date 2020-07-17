import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPage extends StatefulWidget {
  final data;

  WebViewPage(this.data);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool isLoad = true;
  FlutterWebviewPlugin flutterWebViewPlugin;

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin = FlutterWebviewPlugin();
    flutterWebViewPlugin.onStateChanged.listen((state) {
      if (state.type == WebViewState.finishLoad) {
        setState(() {
          isLoad = false;
        });
      } else if (state.type == WebViewState.startLoad) {
        setState(() {
          isLoad = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        title: Text(widget.data['title']),
        //appbar下边摆放一个进度条
        bottom: PreferredSize(
          //提供一个希望的大小
          preferredSize: const Size.fromHeight(1.0),
          child: const LinearProgressIndicator(),
        ),

        ///透明度
        bottomOpacity: isLoad ? 1.0 : 0.0,
      ),
      withLocalStorage: true, //缓存，数据缓存
      url: widget.data['url'],
      withJavascript: true, //webviewscaffold
    );
  }
}
