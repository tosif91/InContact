import 'package:flutter/material.dart';

class BaseWidget extends StatefulWidget {
 const BaseWidget({@required this.title,@required this.child});
 final Widget child;
 final String title;

  @override
  _BaseWidgetState createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar:  AppBar(title: Text('${widget.title}'),centerTitle: true,
      actions: <Widget>[

      ],),
      body:widget.child,
    );
  }
}