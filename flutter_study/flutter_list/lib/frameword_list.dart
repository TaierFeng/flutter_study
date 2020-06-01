import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//列表基类
/*
 * 所有的列表都包括：获取数据，下拉刷新，上拉加载更多，显示数据，等待Loading\
 * @author jiaErFeng
 */
class FrameWordListState<T extends StatefulWidget> extends State {

  List dataList = [];

  String title = "";
  String hasNoDataText = "暂无内容";

  //是否显示上拉加载组件
  bool isGetMore = false;

  //listView的控制器
  ScrollController _scrollController = ScrollController();

  //是否正在加载数据
  bool isLoading = false;
  int pageNum = 1;
  int pageSize = 10;
  int dataCount = 1;
  int total = 0;
  bool isDataLoadingSuccess = false;
  //背景颜色
  Color _backgroundColor = Color.fromRGBO(245, 245, 245, 100);

  T get widget => _widget;
  T _widget;

  initState() {
    super.initState();
    _widget = super.widget;
    initScroll();
    getData(pageNum, pageSize, true);
  }

  /// 绑定滚动事件
  /// 一般用于列表滚动到最后面时显示的内容
  ///
  void initScroll() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
        _getMore();
      }
    });
  }

  ///发起请求
  ///Response result = Dio.get(url);
  ///或者是：Response result = Dio.post(url);
  ///
  makeResponse() async {
    Response result = new Response();
    return result;
  }

  ///获取数据
  ///从response中获取数据，判断请求是否成功
  ///如果成功，则加载数据，失败则提示加载失败
  getData(pageNum, pageSize, isRefresh) async {
    Response response = await makeResponse();
    if (response.statusCode != 200 || response.data["code"] != 0) {
      Fluttertoast.showToast(msg: response.statusMessage,
          timeInSecForIos: 2,
          gravity: ToastGravity.TOP);
      setState(() {
        isDataLoadingSuccess = true;
      });
    } else {
      List data = response.data["data"];
      setState(() {
        successRequest(isRefresh,data);
        total = response.data["count"];
        isDataLoadingSuccess = true;
      });
    }
  }

  ///数据请求成功后处理函数
  ///一般都是给数据赋值
  successRequest(bool isRefresh,List data) {
    if (isRefresh && dataList.length > 0) dataList = [];
    for (int i = 0; i < data.length; i++) {
      dataList.add(data[i]);
    }
  }

  ///获取列表数据
  ///用于在加载列表时
  getDataList() {
    return dataList;
  }

  //列表中相同的每一项的样式
  initListItemWidget(item) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.black12, width: 1)
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent, //添加这句才能点击空白处，否则只能通过点击文字出发onTap。
        child: Container(
            padding: const EdgeInsets.only(
                left: 20.0, right: 10.0, top: 15.0, bottom: 15.0),
            child: Row(
              children: <Widget>[
                Text(
                  item['subject'],
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            )
        ),
        onTap: () {
          listItemAction(item);
        },
      ),
    );
  }

  //列表中相同的每一项的前面项的样式
  initListBeforeItemWidget() {
    return Container();
  }
  //列表中相同的每一项的后面项的样式
  initListAfterItemWidget() {
    return Container();
  }

  //列表项点击事件
  listItemAction(item) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => LeaningPage(examId: dataList[i]['id'].toString(),examTitle: dataList[i]['subject'].toString())),
//     );
  }

  //ListWidget主体部分
  List<Widget> bodyListWidget() {
    // widget list
    List<Widget> result = [];
    List datas = getDataList();
    var item;

    if (datas.isEmpty) {
      result.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: hasNoDataText==""?const EdgeInsets.all(0):const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text(hasNoDataText),
              )
            ],
          )
      );
    }
    result.add(initListBeforeItemWidget());
    for (var i = 0; i < datas.length; i++) {
      item = datas[i];
      result.add(
        initListItemWidget(item),
      );
    }
    result.add(initListAfterItemWidget());

    // 返回
    return result;
  }

  //底部菜单栏
  setBottomNavigationBar() {
    return null;
  }

  //判断是否有数据
  Widget _loadingOrHasData() {
    Widget bodyWidget = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: CupertinoActivityIndicator(),
        )
      ],
    );

    if (isDataLoadingSuccess) {
      bodyWidget = Container(
        color: _backgroundColor,
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView(
            children: bodyListWidget(),
            controller: _scrollController,
            //保持ListView在任何时候都可以滚动，解决item太少不能下拉刷新的问题
            physics: new AlwaysScrollableScrollPhysics(),
          ),
        ),
      );
    }

    return bodyWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: _loadingOrHasData(),
      bottomNavigationBar: setBottomNavigationBar(),
    );
  }

  //下拉刷新方法,为list重新赋值
  Future<Null> _onRefresh() async {
    print('refresh');
    pageNum = 1;
    dataCount = 1;
    getData(pageNum, pageSize, true);
    isGetMore = false;
    Fluttertoast.showToast(msg: '刷新成功');
  }

  //上拉加载更多
  Future _getMore() async {
    if (dataCount > total / pageSize) {
      setState(() {
        isGetMore = false;
      });
      return;
    }
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      print('加载更多');
      setState(() {
        pageNum = pageNum + 1;
        getData(pageNum, pageSize, false);
        isLoading = false;
        isGetMore = true;
        dataCount++;
      });
    }
  }

  //设置标题
  setTitle(String title) {
    this.title = title;
  }

  setHasNoDataText(String text) {
    hasNoDataText = text;
  }

  setBackgroundColor(Color color) {
    this._backgroundColor = color;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

}
