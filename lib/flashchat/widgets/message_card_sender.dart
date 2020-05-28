import 'package:advancetut/flashchat/models/message.dart';
import 'package:advancetut/flashchat/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageCardSender extends StatelessWidget {
  final Message snapShot;
  final bool state;

  const MessageCardSender({@required this.snapShot, @required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            BaseData.convertTimeStamp(snapShot.time), //used snapshot
            style:
                Theme.of(context).textTheme.bodyText2.apply(color: Colors.blueGrey),
          ),
          SizedBox(width: 15),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .6),
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: const Color(0xff36AF46),
                      borderRadius: BorderRadius.only(
                        //topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          snapShot.message,
                          style: TextStyle(color:Colors.white,fontWeight: FontWeight.w400),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                          Icon((state) ? Icons.check : Icons.access_time,color: Colors.amber,),
                          
                        ]),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
