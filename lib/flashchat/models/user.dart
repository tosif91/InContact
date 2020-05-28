import 'package:flutter/cupertino.dart';


class User { 

  final  String name;
  final String email;
  final String uid;
  

  User({@required this.name,@required this.email,@required this.uid});
  
  static User getUserObj(String uName,String uEmail,String uUid)=>User(name: uName,email: uEmail,uid: uUid);
  
  //toMap
  Map<String,dynamic> toMap()=>{'name':this.name ,'email':this.email,'uid':this.uid };
  
  //fromMap
  static User fromMap(Map<String,dynamic> map)=>User(email: map['email'],name: map['name'],uid: map['uid']);
}