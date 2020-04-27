import 'package:flutter/material.dart';

List<Widget> items=[];

class Item extends StatelessWidget {

  final index;
  Item({this.index});

  void more(){
    items.add(Container(child: Text('Hello', style: TextStyle(color: Colors.black),),
      color: Colors.white,
      width: double.infinity,)
    );
  }

  @override
  Widget build(BuildContext context) {
    return items[index];
  }
}
