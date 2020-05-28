import 'package:advancetut/flashchat/utilities/handle_orientation.dart';
import 'package:advancetut/flashchat/view_model/splash_view_model.dart';
import 'package:advancetut/flashchat/widgets/app_title.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SplashViewModel _viewModel = SplashViewModel();

  @override
  Widget build(BuildContext context) {
    //my orientatino handling for all pages starts here
    //   HandleOrientation.potrait();

    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: AppTitle(),
    );
  }

  @override
  void initState() {
    super.initState();
Future.delayed(  
        Duration(
          milliseconds: 375,
        ), () async {
          print('called hadleUser');
      await _viewModel.handleUser(context);
    });
  }
}
