import 'package:flutter/services.dart';

class HandleOrientation{
  static potrait()=>
    SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]
    );
  
}