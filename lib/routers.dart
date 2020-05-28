

import 'package:advancetut/flashchat/utilities/constants.dart';
import 'package:advancetut/flashchat/view/chat_history_view.dart';
import 'package:advancetut/flashchat/view/create_group_view.dart';
import 'package:advancetut/flashchat/view/friend_list_view.dart';
import 'package:advancetut/flashchat/view/notification_view.dart';
import 'package:advancetut/flashchat/view/search_friend_view.dart';

import 'package:advancetut/flashchat/view/login_view.dart';
import 'package:advancetut/flashchat/view/splash_view.dart';
import 'package:advancetut/flashchat/view/welcome_view.dart';
import 'package:advancetut/flashchat/view/registration_view.dart';
import 'package:advancetut/flashchat/view/chat_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Routers{

static Route<dynamic> toGenerateRoute(RouteSettings settings){
  switch(settings.name){
    case friend_list_screen:
    return MaterialPageRoute(builder: (context)=>FriendListView());
    case notification_screen:
    return MaterialPageRoute(builder: (context)=>NotificationView());
    case search_friend_screen:
    return MaterialPageRoute(builder: (context)=>SearchFriendView());
    case create_group_screen:
    return MaterialPageRoute(builder: (context)=>CreateGroupView());
    case chat_history_screen:
    return MaterialPageRoute(builder: (context)=>ChatHistoryView());
    case splash_screen:
    return MaterialPageRoute(builder: (context)=>SplashView());
    
    case login_screen :
    return MaterialPageRoute(builder: (context)=>LoginView());
    case welcome_screen:
    return MaterialPageRoute(builder: (context)=>WelcomeView());
    case registration_screen:
    return MaterialPageRoute(builder: (context)=>RegistrationView());
    case chat_screen:
    return MaterialPageRoute(builder: (context)=>ChatView(userChatHistoryInfo: settings.arguments,));
    case friend_search_screen:
    return MaterialPageRoute(builder: (context)=>SearchFriendView());
    default:
    return MaterialPageRoute(builder: (context)=>Container(
      alignment: Alignment.center,
      child:Text('Invalid Route'),
      ));
    }//switch
  }
}
