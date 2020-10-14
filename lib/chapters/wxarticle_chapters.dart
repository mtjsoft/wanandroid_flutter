import 'package:firstflutterapp/chapters/chapters_list.dart';
import 'package:firstflutterapp/entity/chapters_entity.dart';
import 'package:flutter/material.dart';

class ChaptersPage extends StatefulWidget {

  // 公众号列表
  List<ChaptersEntity> list;

  ChaptersPage({Key key, this.list}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ChaptersPageState();
  }
}

class _ChaptersPageState extends State<ChaptersPage> with SingleTickerProviderStateMixin{

  TabController _tabController; //需要定义一个Controller

  int _currentTabIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    getChaptersList();
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
    //获取路由参数
    return Scaffold(
      appBar: AppBar(
        title: Text('公众号'),
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
          return ChaptersListPage(e.name, e.id);
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }
}
