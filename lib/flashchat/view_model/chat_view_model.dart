import 'dart:async';

import 'package:advancetut/flashchat/models/chat_history.dart';
import 'package:advancetut/flashchat/models/friend.dart';
import 'package:advancetut/flashchat/models/message.dart';
import 'package:advancetut/flashchat/models/user.dart';
import 'package:advancetut/flashchat/services/database_service.dart';
import 'package:advancetut/flashchat/services/local_storage_service.dart';
import 'package:advancetut/flashchat/view_model/busy_model.dart';
import 'package:advancetut/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatViewModel extends BusyModel {
  final DatabaseService _databaseService = locator<DatabaseService>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();
  List<Message> messages;
  ChatHistory groupInfo;
  StreamSubscription _messageSubscription, _groupInfoSubscription;
  //query purpose ..
  bool isLoading = false;

  //temp in

  Future<void> sendMessage(
      String message, User userData, dynamic groupInfo) async {
    if (groupInfo is Friend) {
      if (!groupInfo.history) {
        await _databaseService.createChatHistory(groupInfo, userData, message);
        groupInfo.history = true;
      }
    }

    await _databaseService.sendMessage(
        Message(
            send: false,
            message: message,
            sender: userData.name,
            time: Timestamp.now().millisecondsSinceEpoch.toString(),
            uid: userData.uid),
        groupInfo, //may be friend or chatHisory object.
        userData);
  }

  User getUserInfo() {
    if (_localStorageService.checkState()) {
      return _localStorageService.getUserInfo();
    } else {
      //sum logic to implement.
      //TODO: create alert that local data is deleted and handle .. it.
    }
  }

//stream listeners here.....................................

  void listenToGroupInfo(String groupId) {
    // this groupid is provided by argument passed to this view.
    _groupInfoSubscription =
        _databaseService.listenToGroupInfoRealtime(groupId).listen((data) {
      groupInfo = data;
      print('my group ${groupInfo.id}');
      notifyListeners();
    });
  }

  void listenToMessages(String groupId) {
    busy = true;

    _messageSubscription =
        _databaseService.listenToMessageRealTime(groupId).listen((data) {
      messages = data;
      //here whenevr new message came when we are inside the chat then it will set totalunseen to 0;
      _databaseService.setMessageSeen(groupId);
      notifyListeners();
    });

    busy = false;
  }

  @override
  void dispose() {
    if (_messageSubscription != null) _messageSubscription.cancel();
    if (_groupInfoSubscription != null) _groupInfoSubscription.cancel();
    _databaseService.cancelChatViewStreams();
  }

  messageSeen(String groupId) async {
    await _databaseService.setMessageSeen(groupId);
  }

  moreMessageRequest(String groupId)  {
    print('fetching more messages');
     _databaseService.requestMoreMessages(groupId);
  }
}
