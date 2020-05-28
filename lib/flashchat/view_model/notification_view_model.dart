import 'package:advancetut/flashchat/models/friend.dart';
import 'package:advancetut/flashchat/services/database_service.dart';
import 'package:advancetut/flashchat/view_model/busy_model.dart';
import 'package:advancetut/locator.dart';
import 'package:flutter/material.dart';

class NotificationViewModel extends BusyModel{
List<Friend>notificationList=List<Friend>();
DatabaseService _databaseService=locator<DatabaseService>();

listenToNotificationRealTime(){
busy=true;

_databaseService.listenToNotificatonsRealTime().listen((data){
  notificationList=data;
  notifyListeners();
  print(notificationList);
});

busy=false;
//notifyListeners();  uncomment it if ui does not respond
}
requestHandler(int index, context) async {
    
    var passObj=notificationList[index];
    notificationList.removeAt(index);
    notifyListeners();         //responsive UI
    
    (passObj.selected)
        ? await _databaseService.acceptRequest(passObj)
        : await _databaseService.deleteRequest(passObj);
    
    //atLast..........................
    if(passObj.selected)
    print('request accepted');
    print('request deleted');
  }  
  

}