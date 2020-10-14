import 'package:firstflutterapp/config/ApiUrl.dart';
import 'package:firstflutterapp/diohttp/DioManager.dart';
import 'package:firstflutterapp/diohttp/NWMethod.dart';
import 'package:firstflutterapp/entity/article_list_entity.dart';
import 'package:firstflutterapp/utils/FluttertoastUtils.dart';
import 'package:firstflutterapp/view/list_item.dart';
import 'package:firstflutterapp/view/list_refresh_loadmore.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

// 我的收藏
class MineCollectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MineCollectPageState();
  }
}

class _MineCollectPageState extends State<MineCollectPage> {
  int total = 0;
  int pageNum = 0;
  List<ArticleListData> articleList = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的收藏"),
      ),
      body: ListPage(articleList, _renderRow,
          isLoadMore: true,
          isOnRefresh: true,
          noMoreData: articleList.length >= total,
          loadMoreFunction: getList,
          onRefreshFunction: _onRefresh),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    return ListItem.init().renderRow(context, index, articleList, 1,
            (data, position) {
          if (!data.collect) {
            setState(() {
              articleList.removeAt(position);
              total--;
            });
          } else {
            setState(() {
              articleList[position] = data;
            });
          }
        });
  }

  // 下拉刷新
  Future<void> _onRefresh() async {
    pageNum = 0;
    await getList();
  }

  // 搜索列表
  void getList() {
    DioManager().request<ArticleListEntity>(
        NWMethod.GET, sprintf(ApiUrl
        .init()
        .collectList, [pageNum]), params: {},
        success: (data) {
          data.datas.forEach((p) {
            p.collect = true;
          });
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
