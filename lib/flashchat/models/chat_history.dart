
import 'package:flutter/cupertino.dart';

class ChatHistory {
  final String totalUsers;
    String id;
   String name;
   final String lastAction;
  final List<Map> users;
 String groupId;
   String lastMessage;
   int totalUnseen;
  ChatHistory(
      {@required this.name,
      @required this.id,
      this.lastAction,
      this.totalUsers,
      this.users,
      this.groupId,
      this.lastMessage,
      this.totalUnseen,
      });

  Map<String, dynamic> toUserHistoryMap() => {
        'name': name,
        'uid': id,
        'lastvisit': lastAction,
      };

  Map<String, dynamic> toUserGroupChatHistoryMap() => 
      {
        'subject': name,
        'adminid': id,
        'groupid': groupId,
        'lastvisit': lastAction,
        'totalusers': totalUsers,
        'totalunseen':totalUnseen,
        'lastmessage':lastMessage,

      };

  Map<String, dynamic> toGroupHistoryMap() => 
      {
        'subject': name,
        'adminid': id,
        'groupid': groupId,
        'totalusers': totalUsers,
        'lastvisit': lastAction,
        'users': users
      };
  static ChatHistory fromMap(Map<String, dynamic> map) => ChatHistory(
        name: (map['name'] != null) 
              ? map['name'] 
              : map['subject'],
        
        totalUsers: (map['totalusers'] != null) 
                    ? map['totalusers'] 
                    : null,

        id: (map['uid'] != null) 
            ? map['uid'] 
            : map['adminid'],

        groupId: (map['groupid'] != null) 
                 ? map['groupid'] 
                 : null,

        lastAction: map['lastvisit'],

        lastMessage: (map['lastmessage'] != null)
                     ? map['lastmessage']
                     :'no message',

        totalUnseen: (map['totalunseen']  != null)                     
                     ?map['totalunseen']
                     :0,
        users: (map['users'] != null)
                ?List.from(map['users'])                     
                :null,
      
      );

    static fromGroupMap(Map<String,dynamic> map)=>ChatHistory(
      name: map['subject'],
       id: map['adminid'],
       totalUsers: map['totalusers'],
       lastAction: map['lastvisit'],
       groupId: map['groupid'],
       users: map['users'],
       
       )  ;
     
      Map<String,dynamic> toNormalChatInfo()=>{
      'groupid': groupId, //provide uniqueId of group
      'uid' : id,//provide id of opposit person
      'totalunseen':totalUnseen,
      'lastmessage':lastMessage,
       'name':name,
       'lastvisit':lastAction,
     };

}
