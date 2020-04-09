
import 'package:advancetut/flashchat/services/alert_service.dart';
import 'package:advancetut/flashchat/services/authentication_service.dart';
import 'package:advancetut/flashchat/utilities/constants.dart';
import 'package:advancetut/flashchat/view_model/busy_model.dart';
import 'package:advancetut/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LoginViewModel extends BusyModel{
  AuthenticationService _authenticationService =locator<AuthenticationService>();
  AlertService _alertService=locator<AlertService>();
   
  Future<void> handleLogIn(String email, String password, BuildContext context)async{
     await _authenticationService.logInUser(email, password)
     .then((data){
       busy=false; 
       if(data is FirebaseUser)
       //TODO: here need to access firestore to get user details and upload in sharedPreferences
        Navigator.pushNamedAndRemoveUntil(context, chat_screen,(Route<dynamic>route)=>false,);
       
       else
           _alertService.showAlert(context, data);
     });
  }//handleLogin...
}
