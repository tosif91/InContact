import 'package:advancetut/flashchat/services/authentication_service.dart';
import 'package:advancetut/flashchat/services/local_storage_service.dart';
import 'package:advancetut/flashchat/utilities/constants.dart';
import 'package:advancetut/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked_services/stacked_services.dart';

class SplashViewModel {
  AuthenticationService _authenticationService = AuthenticationService();
  NavigationService _navigationService = locator<NavigationService>();
  bool hiveBox;

  Future<void> handleUser(BuildContext context) async {
    await LocalStorageService.openBoxUserInfo()
        .then((value) => hiveBox = value);
    await _authenticationService.ifUser().then((user) {
      if (hiveBox) {
        print("hive succedd SPLASH");
        if (user != null)
          Navigator.popAndPushNamed(context, chat_history_screen);
        else
          Navigator.popAndPushNamed(context, login_screen);
      } else {
        print('got an error on hive handle it');
      }
    });
  }
}
