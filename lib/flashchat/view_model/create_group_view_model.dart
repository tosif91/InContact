import 'package:advancetut/flashchat/models/friend.dart';
import 'package:advancetut/flashchat/models/user.dart';
import 'package:advancetut/flashchat/services/database_service.dart';
import 'package:advancetut/flashchat/utilities/constants.dart';
import 'package:advancetut/flashchat/view_model/busy_model.dart';
import 'package:advancetut/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked_services/stacked_services.dart';

class CreateGroupViewModel extends BusyModel{
  NavigationService _navigationService=locator<NavigationService>();
  DatabaseService _databaseService= locator<DatabaseService>();
  List<Friend> friendList=List<Friend>();
  List<User> selectedFriend =List<User>();
  int totalSelection=0;
  bool admin=false;  
  searchFriend()async{
    // navigate t0 search friend screen..
    await   _navigationService.navigateTo( search_friend_screen);
  }

  createGroup(String groupSubject,BuildContext context)async{
   busy=true;
   await _databaseService.createGroup(selectedFriend,groupSubject);
    Navigator.pop(context);
    
  }

  
  unselectItem(int index){
    totalSelection--;
    friendList[index].selected=false;
    notifyListeners(); //for responsiveness
    selectedFriend.removeWhere((item)=> item.uid == friendList[index].uid);
   
  }

  selectItem(int index){
    totalSelection++;
    friendList[index].selected=true;
    notifyListeners();   //for reponsiveness.
    selectedFriend.add(User(
      name: friendList[index].name,
      email: friendList[index].email,
      uid: friendList[index].uid));
  }

  fetchFriendsList()async{
  busy=true;
  
  friendList=await _databaseService.fetchFriend();
  
  //to refresh all contents to its new state
  totalSelection=0;                         
  if(selectedFriend != null)
  selectedFriend.clear();
  busy=false;
  notifyListeners();
  }

}