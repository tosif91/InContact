import 'package:advancetut/flashchat/models/chat_history.dart';
import 'package:advancetut/flashchat/models/friend.dart';
import 'package:advancetut/flashchat/services/database_service.dart';
import 'package:advancetut/flashchat/utilities/constants.dart';
import 'package:advancetut/flashchat/view_model/busy_model.dart';
import 'package:advancetut/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stacked_services/stacked_services.dart';

class FriendListViewModel extends BusyModel{
 List<Friend>friendList=List<Friend>();
DatabaseService _databaseService=locator<DatabaseService>();
NavigationService _navigationService=locator<NavigationService>();
 fetchFriend()async{
   busy =true;
   friendList= await _databaseService.fetchFriend();
   print(friendList);
   busy=false;
  // notifyListeners();   if issue found uncomment it..
 }

  sendMessage(Friend snapShot) {
  //TODO: work pending..
  print(snapShot.uid);
  _navigationService.replaceWith(chat_screen,arguments: snapShot);  //this snapshot is of friend Object
  }

  unfriend(Friend snapShot,int index) {
    
    debugPrint('unfriend started');
  friendList.removeAt(index);
  notifyListeners();
  _databaseService.unfriend(snapShot);

  } 
}