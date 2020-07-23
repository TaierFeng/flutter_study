import 'package:flutter/material.dart';
import 'package:selectparam/selector.dart';


class SelectPage extends StatefulWidget {
  SelectPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<SelectPage> {
  TextEditingController _addressController = TextEditingController();
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        icon: Icon(
                          Icons.place,
                          color: Colors.blue,
                        ),
                        hintText: '-选择查询条件-',
                      ),
                      //设置TextField 不可编辑
                      controller: _addressController,
                      enableInteractiveSelection: false,
                      onTap: () async {
                        //取消焦点
                        FocusScope.of(context).requestFocus(new FocusNode());
                        SelectedCallback result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectorPage(
                                id: 1,
                                name: "1",
                              ),
                            ));
                        if (result != null) {
//                          id = result.id;
                          setState(() {
                            _addressController.text = result.name;
                            _text = "您所选择的是：id=" +
                                result.id.toString() +
                                "   name=" +
                                result.name;
                          });
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
            Text(_text)
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
