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

  var userCoin = "lg/coin/userinfo/json"; // 获取个人积分，需要登录后访问 GET

  var banner = "banner/json"; // 首页banner  GET

  var articleList = "article/list/%i/json"; // 首页文章列表  GET

  var hotKeyList = "hotkey/json"; // 搜索热词  GET

  var friendLinkList = "friend/json"; // 常用网站  GET

  var queryList = "article/query/%i/json"; // 搜索  POST

  var treeTypeList = "tree/json"; // 体系分类  Get

  var chaptersList = "wxarticle/chapters/json"; // 公众号列表  Get

  var wxarticleList = "wxarticle/list/%i/%i/json"; // 查看某个公众号历史数据  GET

  var collectList = "lg/collect/list/%i/json"; // 收藏文章列表  GET

  var addCollect = "lg/collect/%i/json"; // 收藏站内文章  POST

  var unCollectOriginId = "lg/uncollect_originId/%i/json"; //  文章列表取消收藏  POST

  var unCollect = "lg/uncollect/%i/json"; //  我的收藏页面取消收藏  POST

  var projectList = "project/list/%i/json"; //  项目列表数据  GET
}
