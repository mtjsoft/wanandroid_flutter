import 'package:firstflutterapp/config/ApiUrl.dart';
import 'package:firstflutterapp/diohttp/DioManager.dart';
import 'package:firstflutterapp/diohttp/NWMethod.dart';
import 'package:firstflutterapp/entity/article_list_entity.dart';
import 'package:firstflutterapp/entity/tree_type_entity.dart';
import 'package:firstflutterapp/utils/FluttertoastUtils.dart';
import 'package:firstflutterapp/view/list_item.dart';
import 'package:firstflutterapp/view/list_refresh_loadmore.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

// 某个公众号历史数据
class TreeListPage extends StatefulWidget {
  String title = "";
  int index = 0;
  List<TreeTypechild> list;

  TreeListPage({Key key, this.list, this.index, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _TreeListPageState();
  }
}

class _TreeListPageState extends State<TreeListPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController; //需要定义一个Controller

  int _currentTabIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentTabIndex = widget.index;
    _tabController = TabController(
        length: widget.list.length,
        vsync: this,
        initialIndex: _currentTabIndex);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: widget.list.map((e) {
                return Tab(text: e.name);
              }).toList()),
        ),
        body: TabBarView(
            controller: _tabController,
            children: widget.list.map((e) {
              return new Tree(e.id);
            }).toList()));
//        body: IndexedStack(
//          index: _currentTabIndex,
//          children: widget.list.map((e) {
//            return new Tree(e.id);
//          }).toList(),
//        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }
}

// 每个分类一个界面
class Tree extends StatefulWidget {
  int cid;

  Tree(this.cid);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new TreeState();
  }
}

class TreeState extends State<Tree> {
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
    // TODO: implement build
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
    pageNum = 0;
    await getList();
  }

  // 体系分类列表
  void getList() {
    DioManager().request<ArticleListEntity>(
        NWMethod.GET, sprintf(ApiUrl.init().articleList, [pageNum]),
        params: {"cid": widget.cid}, success: (data) {
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
