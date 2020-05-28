import 'dart:async';

import 'package:advancetut/flashchat/models/friend.dart';
import 'package:advancetut/flashchat/services/database_service.dart';
import 'package:advancetut/flashchat/view_model/busy_model.dart';
import 'package:advancetut/locator.dart';
import 'package:flutter/cupertino.dart';



class SearchFriendViewModel extends BusyModel {
  DatabaseService _databaseService = locator<DatabaseService>();
  List<Friend> searchList = List<Friend>();
  List<Friend> _requestAlreadySend = List<Friend>();
  List<Friend> _requestAlreadyRecieved = List<Friend>();
  List<Friend> _friendList = List<Friend>();
  bool handlingRequest = false;
  StreamSubscription _notificatoinSubs;
  

  listenToRequestRecievedRealtime() {
    _notificatoinSubs = _databaseService.listenToNotificatonsRealTime().listen((data) {
  
      _requestAlreadyRecieved = data;

    });
  }
  
 searchFriend(String name) async {
    busy=true;
    print('i have searche name :: $name');
    //handlingRequest=true;
    await _databaseService.fetchFriend(name: name).then((data) {
      _friendList =data;
    });

    await _databaseService.checkCurrentRequestSends().then((data) {
      _requestAlreadySend = data;
    });
    
    await _databaseService.searchFriend(name).then((data) {
      searchList = data.map((snapShot) {
        // check if user has send request.
        if (_requestAlreadySend != null)
          _requestAlreadySend.forEach((item) {
            if (item.uid == snapShot.uid) {
              snapShot.selected = true;
            }
          });
        // check if user has recieved request.
        if (_requestAlreadyRecieved != null)
          _requestAlreadyRecieved.forEach((item) {
            if (item.uid == snapShot.uid) {
              snapShot.recieved = true;
            }
          });

        if(_friendList != null)
        // chek if person is already friend.
        _friendList.forEach((item){
          if(item.uid==snapShot.uid)
          snapShot.isFriend=true;
        });

      //print(snapShot.recieved);
        return snapShot;
      }).toList();
    });
handlingRequest=true;
    busy=false;
  }

  requestHandler(int index, context) async {
    Friend passObj=searchList[index];
    /*
    this function handles two functionality -->
    1. if request is already send then we will get (slected = true and recieved = true )
    2. if request is already recieved then we will get our (selected = false  and recieved = true )
    1->1. if selected = true (means request is send if we call this method then request will be cancelled and selected = false )
    2->2. if recieved = true (meanse request is recieved and we need to aceept or reject this request by handlin (selected))
     */
    if (searchList[index].recieved) {
      // block state that request is already recieved...
      //TODO: for responsive UI.
      searchList.removeAt(index);
      notifyListeners();
      
      if (passObj.selected) {
        // request accepted..
        await _databaseService.acceptRequest(passObj);
      } else {
        //request rejected..
        await _databaseService.deleteRequest(passObj);
      }
    }
    else {
      if (passObj.selected) {
        //block state that request is already send...
        //TODO:reponsive UI.
        searchList[index].selected = false;
        notifyListeners();
        await _databaseService.cancelRequest(passObj);
      }
      else {
        // block state that we got a pure new search...
        //TODO:responsive UI.
        searchList[index].selected = true;
        notifyListeners();
        await _databaseService.sendRequest(passObj);
      }
    }
    //atlast
    //print('${searchList[index].selected} and ${searchList[index].recieved} and ${searchList[index].isFriend}');
    //notifyListeners();
    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: Text('handle something.'),
    // ));
  }

@override
  void dispose()async{ 
   searchList?.clear();
   _requestAlreadyRecieved?.clear();
   _requestAlreadySend?.clear();
   _friendList?.clear();
   handlingRequest=false;
   await _notificatoinSubs.cancel().then((value) => print('notification stream cancelled from searchFriendViewModel'));
    
  }

}
