



import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class Message{
  final String message,sender;
  final String time,uid;
  bool send;
  StorageUploadTask task;
  Message({@required this.message,@required this.sender,@required this.time,@required this.uid,@required this.send});

Map<String,dynamic>toMap()=>{'message':message,'sender':sender,'time':time,'uid':uid,'send':false};

static Message fromMap(Map<String,dynamic> map) => 
  Message(
    time: map['time'],
    sender: map['sender'],
    message: map['message'],
    uid: map['uid'],
    send:map['send'],
  );

}