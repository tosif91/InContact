import 'package:flutter/cupertino.dart';

class MessageInfo{
  final String lastMessage;
  final int totalUnseen;

  MessageInfo({@required this.lastMessage,@required this.totalUnseen});

  Map<String,dynamic> toMap()=>{
    'lastmessage':lastMessage,
    'totalunseen':totalUnseen,
  };
  
  }