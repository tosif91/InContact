import 'dart:async';

import 'package:advancetut/flashchat/models/chat_history.dart';
import 'package:advancetut/flashchat/models/friend.dart';
import 'package:advancetut/flashchat/services/authentication_service.dart';
import 'package:advancetut/flashchat/services/database_service.dart';
import 'package:advancetut/flashchat/utilities/constants.dart';
import 'package:advancetut/flashchat/view_model/busy_model.dart';
import 'package:advancetut/locator.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stacked_services/stacked_services.dart';

class ChatHistoryViewModel extends BusyModel  {
  NavigationService _navigationService=locator<NavigationService>();
  DatabaseService _databaseService = locator<DatabaseService>();
  AuthenticationService _authenticationService=locator<AuthenticationService>();
  List<Friend> notificationList=List<Friend>();
  //int totalNotification = 0 ;
  List<ChatHistory>historyList;
  StreamSubscription _notificationSubs,_historySubs,_connectivitySubs;
  bool isDeviceConnected=false;
   
  

  showMessages(ChatHistory snapShot) async {
    await _navigationService.navigateTo(chat_screen,arguments: snapShot); // chatHistory objext is send to chatScreen..
  }
  //handle floation action..............
  handleFloatingAction(int index, context) async {
//index gives 1 for group and 2 for message.
//for 1 navigate to createGroup.
//for 2 send message.
    (index == 1)
        ? await _navigationService.navigateTo(create_group_screen)
        : await  _navigationService.navigateTo( friend_list_screen);
  }

//TODO: notifications handling block:
  showFriendRequests(BuildContext context) async{
    await _navigationService.navigateTo(notification_screen);
    
  }

  void handleSearchIcon(BuildContext context) {
    _navigationService.navigateTo(friend_search_screen);
  }

//TODO: stream to listen

listenToNotificationRealtime(){
  
 _notificationSubs = _databaseService.listenToNotificatonsRealTime().listen((data){
  //print('my lisst of friend$data');
  //notificationList=null;
  if(data != null)
  notificationList=data;
  
  notifyListeners();
});
}
listenToChatHistoryRealTime(){
busy=true;  
_historySubs = _databaseService.listenToChatHistoryRealTime().listen((data){
  historyList=data;
  print(historyList);
  notifyListeners();
});
busy=false;
}

  handleSignOut() async{
    //this is an signout we need to clear all the steam services also here
     await _authenticationService.signOut();
     await Hive.box('userinfo').clear().then((value) => print('hive box cleared'));
  }

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('disposes chatHistoryView');
    if(_notificationSubs != null)
    _notificationSubs.cancel();
    if(_historySubs != null)
    _historySubs.cancel();
    _databaseService.cancelChatHistoryViewSubs();

    _connectivitySubs?.cancel();
  }

  void handleAppbarActions(BuildContext context, int i)async{
    switch (i) {
      case 1:
        await _navigationService.navigateTo(notification_screen);
        break;
      case 2:
       await _navigationService.navigateTo(search_friend_screen);
      break;
      
    }
  }

  //  makeMeOnline()async{
  //   _connectivitySubs = Connectivity().onConnectivityChanged.listen((event) async{
  //      print(event);
  //      if(event != ConnectivityResult.none) {
  //      isDeviceConnected = await DataConnectionChecker().hasConnection;
  //     if(isDeviceConnected)
  //     await _databaseService.makeMeOnline();
  //     else
  //     await _databaseService.makeMeOffline();
  //  }
  //   });
  //  }
  
  
}
