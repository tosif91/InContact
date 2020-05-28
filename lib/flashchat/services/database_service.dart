import 'dart:async';
import 'package:advancetut/flashchat/models/chat_history.dart';
import 'package:advancetut/flashchat/models/friend.dart';
import 'package:advancetut/flashchat/models/message.dart';
import 'package:advancetut/flashchat/models/message_info.dart';
import 'package:advancetut/flashchat/models/user.dart';
import 'package:advancetut/flashchat/services/local_storage_service.dart';
import 'package:advancetut/locator.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class DatabaseService {
  static final Firestore _ref = Firestore.instance;
  static final LocalStorageService _localStorageService =
      locator<LocalStorageService>();
  static final CollectionReference _usersRef = _ref.collection('users');
  final DocumentReference _myRef =
      _ref.collection('users').document(_localStorageService.getUserInfo().uid);
  bool isFirstMessage = false;
//TODO: user handling Block

  Future<dynamic> uploadUserDetail(User user) async {
    try {
      await _ref.collection("users").document(user.uid).setData(user.toMap());
      return user;
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> getUserDetail(FirebaseUser user) async {
    try {
      // print('getUserDetail');
      var result = await _ref
          .collection('users')
          .document(user.uid)
          .get()
          .then((value) => User(
                email: value.data['email'],
                name: value.data['name'],
                uid: value.data['uid'],
              ));
      return result;
    } catch (e) {
      return e;
    }
  } //getUserDetails

  makeMeOnline() {
    print('online');
  }

  makeMeOffline() {
    print('offline');
  }

//TODO: group Listeneing stream with some work Bloc:
  final StreamController<ChatHistory> _groupInfoStreamController =
      StreamController<ChatHistory>.broadcast();
  StreamSubscription _groupInfoSubscription;
  groupInfoRequest(String groupId) {
    final DocumentReference _groupRef =
        _ref.collection('groups').document(groupId);
    _groupInfoSubscription = _groupRef.snapshots().listen((recievedGroupInfo) {
      print('data of group coming');
      if (recievedGroupInfo.exists) {
        ChatHistory val = ChatHistory.fromMap(recievedGroupInfo.data);
        _groupInfoStreamController.add(val);
      } else
        _groupInfoStreamController.add(null);
    });
  }

  Stream listenToGroupInfoRealtime(String groupId) {
    groupInfoRequest(groupId);
    return _groupInfoStreamController.stream;
  } //this stream is called in chatview to provide use groupInfo is its an group..

//TODO: messaging Block:
  static final CollectionReference _msgRef = _ref.collection('messages');
  StreamController<List<Message>> _msgStreamController =
      StreamController<List<Message>>.broadcast();
  StreamSubscription _msgSubscription;

  sendMessage(Message msg, dynamic mainGroupInfo, User userData) async {
    final CollectionReference inMsgRef =
        _msgRef.document(mainGroupInfo.groupId).collection('messages');
    //String serverTime = Timestamp.now().microsecondsSinceEpoch.toString();
//transaction send main message.......................
    await _ref.runTransaction((transactionHandler) async {
      try {
        await transactionHandler.set(
            inMsgRef.document(msg.time), msg.toMap() //data to be send.
            );
      } catch (e) {
        return (e is PlatformException) ? e.message : e;
      }
    });
//notify all users message has send
    notifyAllUsers(
        mainGroupInfo, msg.message, inMsgRef, msg.time, userData.uid);
  } //sendMessage

  notifyAllUsers(dynamic mainGroupInfo, String lastMessage, var inMsgRef,
      String serverTime, String userUID) async {
    final WriteBatch msgBatch = _ref.batch();
    final sendToAllState = inMsgRef.document(serverTime);
    if (mainGroupInfo
        is ChatHistory) //friend chathistory will be create if already theis is an message persent
    {
      if (mainGroupInfo.totalUsers != null) {
        //we are in chatview of group..
        mainGroupInfo.users.forEach((user) {
          //  print('my id is ${user['uid']}');
          final DocumentReference userTotalUnseen = _usersRef
              .document(user['uid'])
              .collection('chathistory')
              .document(mainGroupInfo.groupId);

          final DocumentReference userLastMessage = _usersRef
              .document(user['uid'])
              .collection('chathistory')
              .document(mainGroupInfo.groupId);
          //here we are creating batch to notify each user that someon has send a message and also to tell about the last message..
          if (user['uid'] != userUID)
            msgBatch.updateData(
                userTotalUnseen, {'totalunseen': FieldValue.increment(1)});
          msgBatch.updateData(userLastMessage, {'lastmessage': lastMessage});
        }); //for each users
        msgBatch.updateData(sendToAllState, {'send': true});
        await msgBatch.commit(); // commiting our batch operation.
      } else {
        final receiverTotalUnseen = _usersRef
            .document(mainGroupInfo.id) //gives reciever uid
            .collection('chathistory')
            .document(mainGroupInfo.groupId);
        final receiverLastMessage = _usersRef
            .document(mainGroupInfo.id) //gives reciever uid
            .collection('chathistory')
            .document(mainGroupInfo.groupId);
        final senderLastMessage = _usersRef
            .document(userUID)
            .collection('chathistory')
            .document(mainGroupInfo.groupId);
        msgBatch.updateData(sendToAllState, {'send': true});
        msgBatch.updateData(
            receiverTotalUnseen, {'totalunseen': FieldValue.increment(1)});
        msgBatch.updateData(receiverLastMessage, {'lastmessage': lastMessage});
        msgBatch.updateData(senderLastMessage, {'lastmessage': lastMessage});

        await msgBatch.commit(); // commiting our batch operation.

      }
    } else {
      //its an friend object
      // two user interaction.

      final receiverTotalUnseen = _usersRef
          .document(mainGroupInfo.uid) //gives reciever uid
          .collection('chathistory')
          .document(mainGroupInfo.groupId);
      final receiverLastMessage = _usersRef
          .document(mainGroupInfo.uid) //gives reciever uid
          .collection('chathistory')
          .document(mainGroupInfo.groupId);
      final senderLastMessage = _usersRef
          .document(userUID)
          .collection('chathistory')
          .document(mainGroupInfo.groupId);
      msgBatch.updateData(sendToAllState, {'send': true});
      msgBatch.updateData(
          receiverTotalUnseen, {'totalunseen': FieldValue.increment(1)});
      msgBatch.updateData(receiverLastMessage, {'lastmessage': lastMessage});
      msgBatch.updateData(senderLastMessage, {'lastmessage': lastMessage});

      await msgBatch.commit(); // commiting our batch operation.

    } //for single user
    //make send to all true
  }

  createChatHistory(Friend obj, User userData, String message) async {
    WriteBatch batchRef = _ref.batch();
    DocumentReference userRef = _usersRef
        .document(userData.uid)
        .collection('chathistory')
        .document(obj.groupId);
    DocumentReference friendRef = _usersRef
        .document(obj.uid)
        .collection('chathistory')
        .document(obj.groupId);
    DocumentReference userFriendListRef = _usersRef
        .document(userData.uid)
        .collection('friends')
        .document(obj.uid);
    DocumentReference friendFriendListRef = _usersRef
        .document(obj.uid)
        .collection('friends')
        .document(userData.uid);
    batchRef.updateData(userFriendListRef, {'history': true});
    batchRef.updateData(friendFriendListRef, {'history': true});
    batchRef.setData(
        userRef,
        ChatHistory(
                name: obj.name,
                id: obj.uid,
                groupId: obj.groupId,
                lastMessage: message,
                totalUnseen: 0,
                lastAction: Timestamp.now().millisecondsSinceEpoch.toString())
            .toNormalChatInfo());
    batchRef.setData(
        friendRef,
        ChatHistory(
          name: userData.name,
          id: userData.uid,
          groupId: obj.groupId,
          lastAction: Timestamp.now().millisecondsSinceEpoch.toString(),
          lastMessage: message,
          totalUnseen: 0,
        ).toNormalChatInfo());
    await batchRef.commit();
  }

  //message query required
  DocumentSnapshot _lastMessage;
  final int _documentLimit = 20;
  bool _hasMore = true;
  //paged structure
  List<List<Message>> _allMessagePageRequest = List<List<Message>>();

  messageRequest(String groupId) async {  
    final CollectionReference messageRef =
        _ref.collection('messages').document(groupId).collection('messages');
    Query msgRequest =
        messageRef.orderBy('time', descending: true).limit(_documentLimit);
    print(_lastMessage);

    if (_lastMessage != null) {
      msgRequest = messageRef
          .orderBy('time', descending: true)
          .startAfterDocument(_lastMessage)
          .limit(_documentLimit);
    } else {
      _hasMore = true;
    }

    if (!_hasMore) {
      print('all message retrieved');
      return;
    }

    var currentIndexPage = _allMessagePageRequest.length;

    _msgSubscription = msgRequest.snapshots().listen((msgRetrieved) {
      if (msgRetrieved.documents.isNotEmpty) {
        print('new messages found');
        var message = msgRetrieved.documents
            .map((snapShot) => Message.fromMap(snapShot.data))
            .where((item) => item.message != null)
            .toList();
        var pageExists = currentIndexPage < _allMessagePageRequest.length;

        if (pageExists) {
          _allMessagePageRequest[currentIndexPage] = message;
        } else {
          _allMessagePageRequest.add(message);
        }
        var allMessages = _allMessagePageRequest.fold<List<Message>>(
            List<Message>(),
            (initialValue, pageItems) => initialValue..addAll(pageItems));

        if (allMessages != null) _msgStreamController.add(allMessages);

        if (currentIndexPage == _allMessagePageRequest.length - 1)
          _lastMessage = msgRetrieved.documents.last;

        _hasMore = message.length == _documentLimit;
      } else if (!_hasMore) _msgStreamController.add(null);
    });
  }

  void requestMoreMessages(String groupId) => messageRequest(groupId);

  Stream listenToMessageRealTime(String groupId) {
    //intialize all varibale for new chats
    print('intialize all varibale for new chats');
    _hasMore=true;
    _lastMessage?.data?.clear();
    _allMessagePageRequest?.clear();
    
    //register hanlder to retrieve msg when the msg data changes..
    messageRequest(groupId);
    return _msgStreamController.stream;
  }

  cancelChatViewStreams() async {
    //use to cancel chatview stream subscriptions so that no memory leaks occurs...
    if (_msgSubscription != null) _msgSubscription.cancel();
    if (_groupInfoSubscription != null) _groupInfoSubscription.cancel();
  }

//TODO:Notifications Block:

  final StreamController<List<Friend>> _notificatoinStreamController =
      StreamController<List<Friend>>.broadcast();
  StreamSubscription _notificationSubs;
  notificationRequest() {
    final CollectionReference _notificationRequesRecievedRef = _ref
        .collection('users')
        .document(_localStorageService.getUserInfo().uid)
        .collection('requestrecieved');
    var _notificationRequestRef =
        _notificationRequesRecievedRef; //.orderBy('time',descending: true);
    _notificationSubs =
        _notificationRequestRef.snapshots().listen((notifications) {
      if (notifications.documents != null) {
        List<Friend> _notificationList = notifications.documents
            .map((snapShot) => Friend.fromMap(snapShot.data))
            .toList();

        _notificatoinStreamController.add(_notificationList);
      } else
        _notificatoinStreamController.add(null);
    });
  }

  Stream listenToNotificatonsRealTime() {
    notificationRequest();
    return _notificatoinStreamController.stream;
  }

  acceptRequest(Friend obj) async {
    String uniqueId = _ref.collection('users').document().documentID.toString();
    print(uniqueId);
    WriteBatch _acceptRequestBatch = _ref.batch();
    final DocumentReference _notificationToReciever = _ref
        .collection('users')
        .document(_localStorageService.getUserInfo().uid)
        .collection('requestrecieved')
        .document(obj.uid);
    final DocumentReference _notificatoinToSender = _ref
        .collection('users')
        .document(obj.uid)
        .collection('requestsend')
        .document(_localStorageService.getUserInfo().uid);
    final DocumentReference _requestAcceptedUserRef = _ref
        .collection('users')
        .document(_localStorageService.getUserInfo().uid)
        .collection('friends')
        .document(obj.uid);
    final DocumentReference _requestAcceptedFriendRef = _ref
        .collection('users')
        .document(obj.uid)
        .collection('friends')
        .document(_localStorageService.getUserInfo().uid);
    //delete sends and request.............................
    _acceptRequestBatch.delete(_notificationToReciever);
    _acceptRequestBatch.delete(_notificatoinToSender);
    //write in friend and users -friend list...............
    _acceptRequestBatch.setData(
        _requestAcceptedUserRef,
        Friend(
                groupId: uniqueId,
                name: obj.name,
                email: obj.email,
                uid: obj.uid,
                time: Timestamp.now().millisecondsSinceEpoch.toString())
            .toAccepRequestMap());
    _acceptRequestBatch.setData(
        _requestAcceptedFriendRef,
        Friend(
          groupId: uniqueId,
          name: _localStorageService.getUserInfo().name,
          email: _localStorageService.getUserInfo().email,
          uid: _localStorageService.getUserInfo().uid,
          time: Timestamp.now().millisecondsSinceEpoch.toString(),
        ).toAccepRequestMap());

    await _acceptRequestBatch.commit(); //TODO:commited;
  }

  deleteRequest(Friend obj) async {
    WriteBatch _deleteRequestBatch = _ref.batch();
    final DocumentReference _notifyRequestDeleteUser = _ref
        .collection('users')
        .document(_localStorageService.getUserInfo().uid)
        .collection('requestrecieved')
        .document(obj.uid);
    final DocumentReference _notifyRequestDeleteToSender = _ref
        .collection('users')
        .document(obj.uid)
        .collection('requestsend')
        .document(_localStorageService.getUserInfo().uid);
//delete doc from both user and friend...........
    _deleteRequestBatch.delete(_notifyRequestDeleteUser);
    _deleteRequestBatch.delete(_notifyRequestDeleteToSender);

    await _deleteRequestBatch.commit(); //TODO: commited;
  }

//TODO:ChatHistory Block:

  final StreamController<List<ChatHistory>> _historyStreamController =
      StreamController<List<ChatHistory>>.broadcast();
  StreamSubscription _historySubs;
  chatHistoryRequest() {
    // method mainly used to limit the list length its not required in history but we are using it . without limit.
    final CollectionReference _historyRef = _ref
        .collection('users')
        .document(_localStorageService.getUserInfo().uid)
        .collection('chathistory');

    Query historyReq = _historyRef.orderBy('lastvisit',
        descending: true); // creating query on behalf of time and descending.

    _historySubs = historyReq.snapshots().listen((chatHistory) {
      if (chatHistory.documents.isNotEmpty) {
        List<ChatHistory> history = chatHistory.documents
            .map((snapShots) => ChatHistory.fromMap(snapShots.data))
            .where((item) => (item.name != null))
            .toList();

        _historyStreamController.add(history);
      } else {
        _historyStreamController.add(null);
      }
    });
  }

  Stream listenToChatHistoryRealTime() {
    chatHistoryRequest(); //you cand add this method code directly in  called method..

    return _historyStreamController.stream;
  }

  void cancelChatHistoryViewSubs() {
    if (_historySubs != null) _historySubs.cancel();
    if (_notificationSubs != null) _notificationSubs.cancel();
  }

  setMessageSeen(String groupId) async {
    final CollectionReference _historyRef = _ref
        .collection('users')
        .document(_localStorageService.getUserInfo().uid)
        .collection('chathistory');
    WriteBatch _batchWrite = _ref.batch();
    DocumentReference userHistoryGroupRef = _historyRef.document(groupId);
    final snapShot = await userHistoryGroupRef.get();
    if (snapShot.exists) {
      _batchWrite.updateData(userHistoryGroupRef, {'totalunseen': 0});
      await _batchWrite.commit().then((value) {
        //handle if u want
      });
    }
  }
//TODO:ManageFriend Block:

  Future<List<Friend>> fetchFriend({String name}) async {
    CollectionReference friendRef = _ref
        .collection('users')
        .document(_localStorageService.getUserInfo().uid)
        .collection('friends');

    return await friendRef.getDocuments().then((snapShot) {
      if (snapShot.documents != null)
        return snapShot.documents
            .map((item) => Friend.fromMap(item.data))
            .toList();
      else
        return null;
    });
  }

//TODO:GroupHandling Block:

  checkGroup(String groupId) async {
    // this function checks if user has any contact with the friends before...
    final snapShotFriend = await _ref
        .collection('users')
        .document(groupId)
        .collection('chathistory')
        .document(_localStorageService.getUserInfo().uid)
        .get();
    final snapShotUser = await _ref
        .collection('users')
        .document(_localStorageService.getUserInfo().uid)
        .collection('chathistory')
        .document(groupId)
        .get();
    if ((!snapShotUser.exists || snapShotUser == null) &&
        (!snapShotUser.exists || snapShotUser == null)) {
      //both needs to have chatHistory
      return 11;
    }
    if (!snapShotUser.exists || snapShotUser == null) {
      //user needs to hava chatHistory
      return 10;
    }
    if (!snapShotFriend.exists || snapShotFriend == null) {
      //friend needs to have
      return 11;
    }
    return 00;
  } //chechGroups ends here...

  createGroup(List<User> friend, groupSubject) async {
    String uniqueDocumentID = _ref.collection('user').document().documentID;
    friend.add(_localStorageService.getUserInfo());
    DocumentReference _groupRef =
        _ref.collection('groups').document(uniqueDocumentID);
    WriteBatch batch = _ref.batch();

    friend.forEach((users) {
      batch.setData(
          _ref
              .collection('users')
              .document(users.uid)
              .collection('chathistory')
              .document(uniqueDocumentID),
          ChatHistory(
            id: _localStorageService
                .getUserInfo()
                .uid, // stored as an group id will creating group
            groupId: uniqueDocumentID,
            name: groupSubject,
            totalUsers: friend.length.toString(),
            lastAction: Timestamp.now().millisecondsSinceEpoch.toString(),
            totalUnseen: 0,
            lastMessage: '',
          ).toUserGroupChatHistoryMap());
    });
    batch.setData(
      _groupRef,
      ChatHistory(
        id: _localStorageService.getUserInfo().uid,
        name: groupSubject,
        groupId: uniqueDocumentID,
        lastAction: Timestamp.now().millisecondsSinceEpoch.toString(),
        totalUsers: friend.length.toString(),
        users: convertObjListtoMapList(friend),
      ).toGroupHistoryMap(),
    );

    try {
      await batch.commit().then((onValue) {
        print('succedd');
      });
    } catch (e) {
      print(e);
    }
  }

  static List<Map> convertObjListtoMapList(List<dynamic> data) {
    List<Map> result = [];
    data.forEach((steps) {
      Map val = steps.toMap();
      result.add(val);
    });
    return result;
  }

//TODO: searchFriend handling block:

  Future<List<Friend>> checkCurrentRequestSends() async {
    final CollectionReference checkRequestSends = _ref
        .collection('users')
        .document(_localStorageService.getUserInfo().uid)
        .collection('requestsend');
    QuerySnapshot _forQuery = await checkRequestSends.getDocuments();

    return _forQuery.documents
        .map((snapShot) => Friend.fromMap(snapShot.data))
        .toList();
  }

  Future<List<Friend>> searchFriend(String name) async {
    Query searchFreindQuery =
        _ref.collection('users').where('name', isEqualTo: name);

    QuerySnapshot queryResult = await searchFreindQuery.getDocuments();
    print('{hey searched friens $queryResult.documents}');
    if (queryResult.documents != null)
      return queryResult.documents
          .map((snapShot) => Friend.fromMap(snapShot.data))
          .where((item) => item.uid != _localStorageService.getUserInfo().uid)
          .toList();
    else
      return null;
  }

  sendRequest(Friend obj) async {
    final WriteBatch batchFriendRequest = _ref.batch();
    final DocumentReference _friendRequestSendUserRef = _ref
        .collection('users')
        .document(_localStorageService.getUserInfo().uid)
        .collection('requestsend')
        .document(obj.uid);
    final DocumentReference _notifyFriendRequestRecieverRef = _ref
        .collection('users')
        .document(obj.uid)
        .collection('requestrecieved')
        .document(_localStorageService.getUserInfo().uid);

    obj.time = Timestamp.now().millisecondsSinceEpoch.toString();

    batchFriendRequest.setData(
        _friendRequestSendUserRef, obj.toSendRequestMap());
    batchFriendRequest.setData(
        _notifyFriendRequestRecieverRef,
        Friend(
                name: _localStorageService.getUserInfo().name,
                email: _localStorageService.getUserInfo().email,
                uid: _localStorageService.getUserInfo().uid,
                time: Timestamp.now().millisecondsSinceEpoch.toString())
            .toSendRequestMap());
    await batchFriendRequest.commit().then((onValue) {
      print('request send');
    });
  }

  cancelRequest(Friend obj) async {
    final WriteBatch batchFriendRequest = _ref.batch();
    final DocumentReference _friendRequestSendUserRef = _ref
        .collection('users')
        .document(_localStorageService.getUserInfo().uid)
        .collection('requestsend')
        .document(obj.uid);
    final DocumentReference _notifyFriendRequestRecieverRef = _ref
        .collection('users')
        .document(obj.uid)
        .collection('requestrecieved')
        .document(_localStorageService.getUserInfo().uid);
    batchFriendRequest.delete(_friendRequestSendUserRef);
    batchFriendRequest.delete(_notifyFriendRequestRecieverRef);
    await batchFriendRequest.commit().then((onValue) {
      print('requestCanceled');
    });
  }

  unfriend(Friend snapShot) async {
    final DocumentReference _userList = _ref
        .collection('users')
        .document(_localStorageService.getUserInfo().uid)
        .collection('friends')
        .document(snapShot.uid);
    final DocumentReference _friendList = _ref
        .collection('users')
        .document(snapShot.uid)
        .collection('friends')
        .document(_localStorageService.getUserInfo().uid);
    final WriteBatch _unfriendBatch = _ref.batch();
    _unfriendBatch.delete(_userList);
    _unfriendBatch.delete(_friendList);

    await _unfriendBatch
        .commit()
        .then((value) => debugPrint('unfriend succeed'));
  }
} //CLASS END HERE......
