import 'package:dio/dio.dart';

import 'http_manager.dart';

typedef void OnResult(Map<String, dynamic> data);

class Api {
  static const String baseUrl = "https://www.wanandroid.com/";

  //首页文章列表 http://www.wanandroid.com/article/list/0/json
  static const String ARTICLE_LIST = "article/list/";

  static const String BANNER = "banner/json";

  static const String REGISTER="/user/register";
  static const String LOGIN="user/login";
//收藏列表
  static const String COLLECT_ARTICLE_LIST = "lg/collect/list/";
  static const String COLLECT_WEBSITE_LIST = "lg/collect/usertools/json";

  static const String LOGIN_OUT="user/logout/json";

  static getArticleList(int page) async {
    return HttpManager.getInstance().request('$ARTICLE_LIST$page/json');
  }

  static getBanner() async {
    return await HttpManager.getInstance().request(BANNER);
  }

  static login(String userName,String password) async{
    var formData = FormData.fromMap(
        {"username": userName, "password": password});
    return await HttpManager.getInstance().request(LOGIN,data:formData,method: "post");

  }
  static register(String userName, String password) async {
    var formData = FormData.fromMap(
        {"username": userName, "password": password, "repassword": password});
    return await HttpManager.getInstance().request(REGISTER,data:formData,method: "post");
  }

  static void clearCookie() {
    HttpManager.getInstance().clearCookie();
  }

  static getArticleCollects(int curPage) async {
    return await HttpManager.getInstance().request("$COLLECT_ARTICLE_LIST/$curPage/json");
  }
}
