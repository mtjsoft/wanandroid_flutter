import 'package:firstflutterapp/config/ApiUrl.dart';
import 'package:firstflutterapp/diohttp/DioManager.dart';
import 'package:firstflutterapp/diohttp/NWMethod.dart';
import 'package:firstflutterapp/entity/article_list_entity.dart';
import 'package:firstflutterapp/utils/FluttertoastUtils.dart';
import 'package:firstflutterapp/view/list_item.dart';
import 'package:firstflutterapp/view/list_refresh_loadmore.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

// 搜索结果
class SearchResultPage extends StatefulWidget {

  String keyWord = "";

  SearchResultPage(String this.keyWord);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _SearchResultPageState();
  }
}

class _SearchResultPageState extends State<SearchResultPage> {
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
        title: Text(widget.keyWord),
      ),
      body: new ListPage(articleList, _renderRow,
          isLoadMore: true,
          isOnRefresh: true,
          noMoreData: articleList.length >= total,
          loadMoreFunction: getList,
          onRefreshFunction: _onRefresh),
    );
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
    pageNum = 0;
    await getList();
  }

  // 搜索列表
  void getList() {
    DioManager().request<ArticleListEntity>(
        NWMethod.POST, sprintf(ApiUrl.init().queryList, [pageNum]),
        params: {"k": widget.keyWord}, success: (data) {
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
