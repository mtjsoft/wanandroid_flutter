import 'package:firstflutterapp/config/ApiUrl.dart';
import 'package:firstflutterapp/diohttp/DioManager.dart';
import 'package:firstflutterapp/diohttp/NWMethod.dart';
import 'package:firstflutterapp/entity/article_list_entity.dart';
import 'package:firstflutterapp/utils/FluttertoastUtils.dart';
import 'package:firstflutterapp/view/list_item.dart';
import 'package:firstflutterapp/view/list_refresh_loadmore.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

// 某个公众号历史数据
class ChaptersListPage extends StatefulWidget {
  int id = 408;
  String title = "鸿洋";

  ChaptersListPage(this.title, this.id);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ChaptersListPageState();
  }
}

class _ChaptersListPageState extends State<ChaptersListPage> {
  int total = 0;
  int pageNum = 1;
  List<ArticleListData> articleList = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return ListPage(articleList, _renderRow,
        isLoadMore: true,
        isOnRefresh: true,
        noMoreData: articleList.length >= total,
        loadMoreFunction: getList,
        onRefreshFunction: _onRefresh);
  }

  Widget _renderRow(BuildContext context, int index) {
    return ListItem.init().renderRow(context, index, articleList, 0,
            (data, position) {
          setState(() {
            articleList[position] = data;
          });
        });
  }

  // 下拉刷新
  Future<void> _onRefresh() async {
    pageNum = 1;
    await getList();
  }

  // 搜索列表
  void getList() {
    DioManager().request<ArticleListEntity>(NWMethod.GET,
        sprintf(ApiUrl.init().wxarticleList, [widget.id, pageNum]), params: {},
        success: (data) {
      setState(() {
        total = data.total;
        if (pageNum == 1) {
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
