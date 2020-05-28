import 'package:flutter/cupertino.dart';

class Friend {
  final String name;
  final String email;
  final String uid;
  String time;
  String groupId;
  bool history;
  bool selected;
  bool recieved;
  bool isFriend;
 
  Friend(
      {@required this.name,
      @required this.email,
      @required this.uid,
      this.groupId,
      this.time,
      this.history,
      //this are hardcoded to ui responsiveness
      this.selected = false,
      this.recieved=false,
      this.isFriend=false,
      });

  static Friend getUserObj(
          String uName, String uEmail, String uUid, String tTime) =>
      Friend(name: uName, email: uEmail, uid: uUid, time: tTime);

  //tosendrequestMap
  Map<String, dynamic> toSendRequestMap() => {
        'name': this.name,
        'email': this.email,
        'uid': this.uid,
        'time': this.time,
      };
//toacceptRequestMap
Map<String, dynamic> toAccepRequestMap() => {
        'name': this.name,
        'email': this.email,
        'uid': this.uid,
        'time': this.time,
        'groupid':this.groupId,
        'history':false,
      };

  //fromMap
  static Friend fromMap(Map<String, dynamic> map) => Friend(
      groupId: map['groupid'],
      email: map['email'],
      name: map['name'],
      uid: map['uid'],
      time: map['time'] ,
      history:map['history'],
      recieved: false,
      selected: false,
      isFriend: false,
      );
}
