import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AlertService{

var alertStyle =  AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.0),
        side: BorderSide(
          color: Colors.blueAccent,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.red,
      ),
      //constraints: BoxConstraints.ti(width: 200)
    );

  showAlert(BuildContext context,dynamic data){
     Alert(
      context: context,
      style: alertStyle,
      type: AlertType.none,
      title: "Error",
      desc: '$data',
      buttons: [
        DialogButton(width: 100.0,
          child: Text(
            "ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          
          onPressed: ()=>Navigator.pop(context),
          
          color: Colors.blueAccent,
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
 
  }

}