import 'package:advancetut/flashchat/models/message.dart';
import 'package:advancetut/flashchat/utilities/constants.dart';
import 'package:flutter/material.dart';

class MessageCardReciever extends StatelessWidget {
  final Message snapShot;

  const MessageCardReciever({@required this.snapShot});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    snapShot.sender, //user name
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .7),
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Color(0xffF0F0F0),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Column( mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        snapShot.message, //used snapshot
                        style: TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 15),
          Text(
            BaseData.convertTimeStamp(snapShot.time),
            style:
                Theme.of(context).textTheme.bodyText2.apply(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
