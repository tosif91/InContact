import 'package:flutter/foundation.dart';

class BusyModel extends ChangeNotifier{
   bool _busy=false;
   set busy(bool value){
    _busy=value;
    notifyListeners();
    }
   
  get busy=>_busy;
}