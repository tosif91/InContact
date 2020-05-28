import 'package:advancetut/flashchat/models/user.dart';
import 'package:advancetut/flashchat/services/alert_service.dart';
import 'package:advancetut/flashchat/services/authentication_service.dart';
import 'package:advancetut/flashchat/services/database_service.dart';
import 'package:advancetut/flashchat/services/local_storage_service.dart';
import 'package:advancetut/flashchat/utilities/constants.dart';
import 'package:advancetut/flashchat/view_model/busy_model.dart';
import 'package:advancetut/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';

class RegistrationViewModel extends BusyModel{
 DatabaseService _databaseService=locator<DatabaseService>();
 AuthenticationService _authenticationService=locator<AuthenticationService>();
 AlertService _alertService=locator<AlertService>();
 LocalStorageService _localStorageService=locator<LocalStorageService>();

  Future<void> handleRegistration(String name,String email,String password,BuildContext context)async{
   busy=true;
  

   try{
       var authResult=await _authenticationService.registerUser(name,email, password);
      if(authResult is AuthResult)
      {
      var uploadUserResult=  await _databaseService.uploadUserDetail(
        User(
        email: authResult.user.email,
        name: name,
        uid: authResult.user.uid
        )
      );
        if(uploadUserResult is User){
            var localStorageResult=await _localStorageService.saveUserInfo(uploadUserResult);
            
            if(localStorageResult)
              await Navigator.pushNamedAndRemoveUntil(context, chat_history_screen, (Route<dynamic>route)=>false);
            else
            handleException(context, localStorageResult);
            
            }
        else
         handleException(context, uploadUserResult);
      }
      else 
        handleException(context, authResult);
          
   
  }catch(e)
  { 
    handleException(context, e);
  }
  }//handlerRegistration


 handleException(BuildContext context,var error)async{
          await _authenticationService.signOut();
          busy = false;
          _alertService.showAlert(context, (error is PlatformException) ? error.message : 'something went wrong');
 }

//validation phase here

validateEmail(String email)=> EmailValidator.validate(email) ?null : 'email address is not vlid';


  validateConfirmPassword(String value, passwordConfirmation)=>value==passwordConfirmation ?null:'password didnt matches';


  validatePassword(String password) {
    Pattern pattern =
      r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
  RegExp regex = new RegExp(pattern);
   if (!regex.hasMatch(password))
    return 'Invalid password';
  else
    return null;
  }

  validateName(String name) {
     Pattern pattern =
      r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(name))
    return 'Invalid username';
  else
    return null;
  }

//handling focus on text field
void fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}


}