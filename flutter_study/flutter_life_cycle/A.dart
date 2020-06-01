import 'package:flutter/material.dart';
import 'package:qfqz_app/B.dart';
import 'package:qfqz_app/utils/navigator_then.dart';

class APage extends StatefulWidget{
  _Astate createState() => _Astate();
}

class _Astate extends State<APage>{

  @override
  Widget build(BuildContext context) {
    print("A build");
     return Scaffold(
       appBar: AppBar(
         title: Text("A"),
       ),
       body: InkWell(
         child: Container(child: Text("跳转至B"),margin: const EdgeInsets.all(20),),
         onTap: () {
           NavigatorThen.push(
             context,
             MaterialPageRoute(builder: (context) => BPage()),
           ).then((e) {
             print("after b return");
           });
         }
       ),
     );
  }

  @override
  void initState() {
    print("A initState");
  }

  @override
  void debugFillProperties(properties) {
    print("A debugFillProperties");
  }

  @override
  void didChangeDependencies() {
    print("A didChangeDependencies");
  }

  @override
  void dispose() {
    super.dispose();
    print("A dispose");
  }

  @override
  void deactivate() {
    print("A deactivate");
  }

  @override
  void reassemble() {
    print("A reassemble");
  }

  @override
  void didUpdateWidget(oldWidget) {
    print("A didUpdateWidget");
  }

}