import 'package:advancetut/flashchat/models/user.dart';
import 'package:advancetut/flashchat/services/alert_service.dart';
import 'package:advancetut/flashchat/services/authentication_service.dart';
import 'package:advancetut/flashchat/services/database_service.dart';
import 'package:advancetut/flashchat/services/local_storage_service.dart';
import 'package:advancetut/flashchat/utilities/constants.dart';
import 'package:advancetut/flashchat/view_model/busy_model.dart';
import 'package:advancetut/locator.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BusyModel {
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  AlertService _alertService = locator<AlertService>();
  DatabaseService _databaseService = locator<DatabaseService>();
  LocalStorageService _localStorageService = locator<LocalStorageService>();

  Future<void> handleLogIn(
      String email, String password, BuildContext context) async {
    //use to hide keyboard from focus state
    FocusScope.of(context).requestFocus(FocusNode());
    busy = true;

    try {
      var authResult = await _authenticationService.logInUser(email, password);
      if (authResult is AuthResult) {
        print('auth');
        var getUserResult =
            await _databaseService.getUserDetail(authResult.user);
        if (getUserResult is User) {
          print('user');
          //print('${getUserResult.uid} getttin user result....');
          var localStorageResult =
              await _localStorageService.saveUserInfo(getUserResult);

          if (localStorageResult)
          {print('localStorage');
            await Navigator.pushNamedAndRemoveUntil(
              context,
              chat_history_screen,
              (Route<dynamic> route) => false,
            );}
          else
            handleException(context, localStorageResult);
        } else
          handleException(context, getUserResult);
      } else
        handleException(context, authResult);
    } catch (e) {
      handleException(context, e);
    }
  } //handleLogin...

  handleException(BuildContext context, var error) async {
    await _authenticationService.signOut();
    busy = false;
    _alertService.showAlert(context,
        (error is PlatformException) ? error.message : 'something went wrong');
  }
//validation methos ................
 

 

  validateEmail(String email)=> EmailValidator.validate(email) ?null : 'email address is not vlid';


  //handling focus on text field
void fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

}
