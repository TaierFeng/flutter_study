
import 'package:flutter/material.dart';


class SelectedCallback {
  SelectedCallback(this.id, this.name);

  int id;
  String name;
}

class SelectorPage extends StatefulWidget {
  SelectorPage({Key key, this.id, this.name}) : super(key: key);

  final double id;
  final String name;

  @override
  State<StatefulWidget> createState() => _SelectorPageState();
}

class _SelectorPageState extends State<SelectorPage> {
  List _dataList = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() {
    setState(() {
      _dataList = [{"id":1,"name":"类别1"},{"id":2,"name":"类别2"},{"id":3,"name":"类别3"},{"id":4,"name":"类别A"},{"id":5,"name":"类别B"}];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择条件界面'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: _dataList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(width: 0.2, color: Colors.grey))),
                    child: Text(_dataList[index]["name"]),
                  ),
                  onTap: () async {
                    int id = _dataList[index]["id"];
                    String name = _dataList[index]["name"];
                    Navigator.pop(
                        context, SelectedCallback(id, name));
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
