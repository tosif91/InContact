import 'package:advancetut/flashchat/models/user.dart';
import 'package:advancetut/flashchat/services/alert_service.dart';
import 'package:advancetut/flashchat/services/authentication_service.dart';
import 'package:advancetut/flashchat/services/database_service.dart';
import 'package:advancetut/flashchat/utilities/constants.dart';
import 'package:advancetut/flashchat/view_model/busy_model.dart';
import 'package:advancetut/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class RegistrationViewModel extends BusyModel{
 DatabaseService _databaseService=locator<DatabaseService>();
 AuthenticationService _authenticationService=locator<AuthenticationService>();
 AlertService _alertService=locator<AlertService>();
  
  Future<void> handleRegistration(String name,String email,String password,BuildContext context)async{
      await _authenticationService.registerUser(name,email, password)
   .then((data)async{
      if(data is AuthResult)
      {
      var result=  await _databaseService.uploadUserDetail(data,name);
        if(result is User)
            Navigator.pushNamedAndRemoveUntil(context, chat_screen, (Route<dynamic>route)=>false);
        else
        _alertService.showAlert(context, data);    
      }
      else 
        _alertService.showAlert(context, data);
   });

  }//handlerRegistration


}