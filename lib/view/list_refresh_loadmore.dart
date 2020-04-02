import 'package:flutter/material.dart';

typedef HeaderWidgetBuild = Widget Function(BuildContext context, int position);

typedef FootWidgetBuild = Widget Function(BuildContext context, int position);

typedef ItemWidgetBuild = Widget Function(BuildContext context, int position);

typedef LoadMoreFunction = void Function();

typedef OnRefreshFunction = Future<void> Function();

class ListPage extends StatefulWidget {
  List headerList;
  List footList;
  List listData;
  ItemWidgetBuild itemWidgetCreator;
  HeaderWidgetBuild headerCreator;
  FootWidgetBuild footCreator;
  LoadMoreFunction loadMoreFunction;
  OnRefreshFunction onRefreshFunction;

  bool isOnRefresh = true;
  bool isLoadMore = false;
  // 底部显示没有更多数据
  bool noMoreData = false;

  ListPage(List this.listData, ItemWidgetBuild this.itemWidgetCreator,
      {Key key,
      List this.headerList,
      List this.footList,
      bool this.isOnRefresh,
      bool this.isLoadMore,
      bool this.noMoreData,
      LoadMoreFunction this.loadMoreFunction,
      OnRefreshFunction this.onRefreshFunction,
      HeaderWidgetBuild this.headerCreator,
      FootWidgetBuild this.footCreator})
      : super(key: key);

  @override
  ListPageState createState() {
    return new ListPageState();
  }
}

class ListPageState extends State<ListPage> {
  ScrollController _scrollController = ScrollController(); //listview的控制器

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (widget.isLoadMore && !widget.noMoreData &&
          widget.loadMoreFunction != null &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        // 滑动到了最底部
        widget.loadMoreFunction();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOnRefresh && widget.onRefreshFunction != null) {
      return RefreshIndicator(
        onRefresh: widget.onRefreshFunction,
        child: new ListView.builder(
//          separatorBuilder: (context, index) => Divider(height: .0),
          itemBuilder: (BuildContext context, int position) {
            return buildItemWidget(context, position);
          },
          itemCount: _getListCount()+ (widget.isLoadMore ? 1 : 0),
          controller: _scrollController,
        ),
      );
    }
    return ListView.builder(
//      separatorBuilder: (context, index) => Divider(height: .0),
      itemBuilder: (BuildContext context, int position) {
        return buildItemWidget(context, position);
      },
      itemCount: _getListCount() + (widget.isLoadMore ? 1 : 0),
      controller: _scrollController,
    );
  }

  int _getListCount() {
    return getHeaderCount() + getItemCount() + getFootCount();
  }

  int getItemCount() {
    int itemCount = widget.listData.length != null ? widget.listData.length : 0;
    return itemCount;
  }

  int getHeaderCount() {
    int headerCount = widget.headerList != null ? widget.headerList.length : 0;
    return headerCount;
  }

  int getFootCount() {
    int footCount = widget.footList != null ? widget.footList.length : 0;
    return footCount;
  }

  Widget buildItemWidget(BuildContext context, int index) {
    if (index < getHeaderCount()) {
      return _headerItemWidget(context, index);
    } else if (getFootCount() > 0 && index < _getListCount() &&
        index >= getHeaderCount() + getItemCount()) {
      return _footItemWidget(context, index);
    } else if (widget.isLoadMore && index == _getListCount()) {
      return _addLoadMore(context, index);
    } else {
      int pos = index - getHeaderCount();
      return _itemBuildWidget(context, pos);
    }
  }

  Widget _headerItemWidget(BuildContext context, int index) {
    if (widget.headerCreator != null) {
      return widget.headerCreator(context, index);
    } else {
      return new GestureDetector(
        child: new Padding(
            padding: new EdgeInsets.all(10.0),
            child: new Text("Header Row $index")),
        onTap: () {
          print('header click $index --------------------');
        },
      );
    }
  }

  Widget _footItemWidget(BuildContext context, int index) {
    if (widget.footCreator != null) {
      return widget.footCreator(context, index);
    } else {
      return new GestureDetector(
        child: new Padding(
            padding: new EdgeInsets.all(10.0),
            child: new Text("Header Row $index")),
        onTap: () {
          print('header click $index --------------------');
        },
      );
    }
  }

  Widget _itemBuildWidget(BuildContext context, int index) {
    if (widget.itemWidgetCreator != null) {
      return widget.itemWidgetCreator(context, index);
    } else {
      return new GestureDetector(
        child: new Padding(
            padding: new EdgeInsets.all(10.0), child: new Text("Row $index")),
        onTap: () {
          print('click $index --------------------');
        },
      );
    }
  }

  // 在最末尾添加 加载更多/没有更多了
  Widget _addLoadMore(BuildContext context, int index) {
    if (widget.noMoreData) {
      return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16.0),
          child: Text(
            "没有更多了",
            style: TextStyle(color: Colors.grey),
          ));
    }
    // 加载更多
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: SizedBox(
          width: 24.0,
          height: 24.0,
          child: CircularProgressIndicator(strokeWidth: 2.0)),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }
}
