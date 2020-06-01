import 'package:flutter/material.dart';

class BPage extends StatefulWidget{
  _Astate createState() => _Astate();
}

class _Astate extends State<BPage>{

  @override
  Widget build(BuildContext context) {
    print("B build");
     return Scaffold(
       appBar: AppBar(
         title: Text("B"),
       ),
       body: Text("this is B"),
     );
  }

  @override
  void initState() {
    print("B initState");
  }

  @override
  void debugFillProperties(properties) {
    print("B debugFillProperties");
  }

  @override
  void didChangeDependencies() {
    print("B didChangeDependencies");
  }

  @override
  void dispose() {
    super.dispose();
    print("B dispose");
  }

  @override
  void deactivate() {
    print("B deactivate");
  }

  @override
  void reassemble() {
    print("B reassemble");
  }

  @override
  void didUpdateWidget(oldWidget) {
    print("B didUpdateWidget");
  }

}