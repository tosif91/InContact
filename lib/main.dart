import 'package:advancetut/flashchat/view/splash_view.dart';
import 'package:advancetut/locator.dart';
import 'package:advancetut/routers.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';


void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  setUpLocator();
  runApp(new MaterialApp(
          

  debugShowCheckedModeBanner: false,// user to remove debug manner
    //theme: ThemeData.dark(),
    home: SplashView(),

    navigatorKey: locator<NavigationService>().navigatorKey,

    onGenerateRoute: Routers.toGenerateRoute,
  ));
}
