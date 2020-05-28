import 'package:advancetut/flashchat/utilities/constants.dart';
import 'package:advancetut/flashchat/view_model/chat_history_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PopMainMenu extends StatelessWidget {
  PopMainMenu({@required this.context, @required this.model});
  final ChatHistoryViewModel model;
  final BuildContext context;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Colors.white,
      itemBuilder: (context) =>
          List.generate(BaseData.menuChoice.length, (index) {
        return PopupMenuItem(
          child: Text(BaseData.menuChoice[index],
              style: TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.w600)),
          value: index,
        );
      }),
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        //handle menuclicks on bhalf of vluae 0,1,2,3
        if (value == 3) {
          Alert(
              style: const AlertStyle(
                  isCloseButton: false,
                  isOverlayTapDismiss: false,
                  backgroundColor: Colors.white,
                  titleStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  )),
              context: context,
              title: 'LogOut',
              //desc: 'you want to LogOut?',
              buttons: <DialogButton>[
                DialogButton(
                  child: const Text(
                    'ok',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () async {
                    await model.handleSignOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, login_screen, (Route<dynamic> route) => false);
                  },
                  color: Colors.lightBlue,
                  width: 50.0,
                ),
                DialogButton(
                  child: const Text(
                    'cancel',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.red,
                  width: 50.0,
                )
              ]).show();
        }
      },
    );
  }
}
