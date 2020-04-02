class ApiUrl {
  static ApiUrl _apiUrl;

  static ApiUrl init() {
    if (_apiUrl == null) {
      _apiUrl = new ApiUrl();
    }
    return _apiUrl;
  }

  // 配置默认请求地址
  var baseUrl = "https://www.wanandroid.com/";

  /// ========================玩Android===============================**/

  var login = "user/login"; // 登录  POST

  var register = "user/register"; // 注册  POST

  var logout = "user/logout/json"; // 退出  GET

  var banner = "banner/json"; // 首页banner  GET

  var articleList = "article/list/%i/json"; // 首页文章列表  GET

  var hotKeyList = "hotkey/json"; // 搜索热词  GET

  var friendLinkList = "friend/json"; // 常用网站  GET

  var queryList = "article/query/%i/json"; // 搜索  POST

  var treeTypeList = "tree/json"; // 体系分类  Get

  var chaptersList = "wxarticle/chapters/json"; // 公众号列表  Get

  var wxarticleList = "wxarticle/list/%i/%i/json"; // 查看某个公众号历史数据  GET
}
