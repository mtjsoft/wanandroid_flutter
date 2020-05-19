import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firstflutterapp/config/ApiUrl.dart';
import 'package:firstflutterapp/diohttp/DioManager.dart';
import 'package:firstflutterapp/diohttp/NWMethod.dart';
import 'package:firstflutterapp/entity/article_list_entity.dart';
import 'package:firstflutterapp/entity/banner_test_entity.dart';
import 'package:firstflutterapp/utils/FluttertoastUtils.dart';
import 'package:firstflutterapp/view/list_item.dart';
import 'package:firstflutterapp/view/list_refresh_loadmore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:sprintf/sprintf.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<BannerTestEntity> bannerList;

  int pageNum = 0;
  int total = 0;
  List<ArticleListData> articleList = new List();

  SwiperController _swiperController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _swiperController = SwiperController();
    _swiperController.startAutoplay();
    getBannerData();
    getArticleList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: new ListPage(articleList, _renderRow,
          isLoadMore: true,
          isOnRefresh: true,
          noMoreData: articleList.length >= total,
          loadMoreFunction: getArticleList,
          onRefreshFunction: _onRefresh,
          headerList: [0],
          headerCreator: addHeaderBanner),
    );
  }

  // item布局
  Widget _renderRow(BuildContext context, int index) {
    return ListItem.init().renderRow(context, index, articleList, 0,
        (data, position) {
      setState(() {
        articleList[position] = data;
      });
    });
  }

  // 添加头部banner
  Widget addHeaderBanner(BuildContext context, int index) {
    return ConstrainedBox(
        child: Swiper(
          onTap: (index) {
            // 点击
            Navigator.pushNamed((context), "browser",
                arguments: jsonEncode({
                  "url": bannerList[index].url,
                  "title": bannerList[index].title
                }));
          },
          autoplay: false,
          loop: false,
          outer: false,
          itemBuilder: (c, i) {
            return new CachedNetworkImage(
                imageUrl: "${bannerList[i].imagePath}",
                placeholder: (context, url) => new Container(
                      child: new Center(
                        child: new CircularProgressIndicator(),
                      ),
                      width: 160.0,
                      height: 90.0,
                    ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover);
          },
          pagination: new SwiperPagination(margin: new EdgeInsets.all(5.0)),
          itemCount: bannerList == null ? 0 : bannerList.length,
          controller: _swiperController,
        ),
        constraints: new BoxConstraints.loose(
            new Size(MediaQuery.of(context).size.width, 180.0)));
  }

  // 下拉刷新
  Future<void> _onRefresh() async {
    pageNum = 0;
    await getArticleList();
  }

  //获取首页banner
  void getBannerData() {
    DioManager().requestList<BannerTestEntity>(
        NWMethod.GET, ApiUrl.init().banner,
        params: {}, success: (data) {
      setState(() {
        bannerList = data;
      });
    }, error: (error) {
      FluttertoastUtils.showToast(error.errorMsg);
    });
  }

  // 获取首页列表
  void getArticleList() {
    DioManager().request<ArticleListEntity>(
        NWMethod.GET, sprintf(ApiUrl.init().articleList, [pageNum]), params: {},
        success: (data) {
      setState(() {
        total = data.total;
        if (pageNum == 0) {
          articleList = data.datas;
        } else {
          articleList.addAll(data.datas);
        }
        pageNum++;
      });
    }, error: (error) {
      FluttertoastUtils.showToast(error.errorMsg);
    });
  }
}
