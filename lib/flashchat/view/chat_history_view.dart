import 'package:advancetut/flashchat/models/chat_history.dart';
import 'package:advancetut/flashchat/utilities/constants.dart';
import 'package:advancetut/flashchat/view_model/chat_history_view_model.dart';
import 'package:advancetut/flashchat/widgets/app_title.dart';
import 'package:advancetut/flashchat/widgets/pop_main_menu_widget.dart';
import 'package:advancetut/locator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:stacked/stacked.dart';

class ChatHistoryView extends StatelessWidget {
  ChatHistoryView({Key key}) : super(key: key);
  bool connected;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatHistoryViewModel>.reactive(
      viewModelBuilder: () => locator<ChatHistoryViewModel>(),
      //disposeViewModel: false,
      onModelReady: (model) async {
       // model.makeMeOnline(); 
        model.listenToChatHistoryRealTime();
        model.listenToNotificationRealtime();
      },
      builder: (context, model, _) => Scaffold(
        appBar: AppBar(
          title: AppTitle(),
          actions: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                      (model.notificationList?.isEmpty ?? true)
                          ? Icons.notifications
                          : Icons.notifications_active,
                      color: (model.notificationList?.isEmpty ?? true)
                          ? Colors.white
                          : Colors.red),
                  onPressed: () {
                    //handle notification screen
                    model.handleAppbarActions(context, 1);
                  },
                  iconSize: 25.0,
                ),
                Positioned(
                  child: Visibility(
                    visible: (model.notificationList?.isNotEmpty ?? true)
                        ? true
                        : false,
                    child: Container(
                        padding: EdgeInsets.all(2.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.teal,
                        ),
                        child: Text(
                          (model.notificationList?.isNotEmpty ?? true)
                              ? (model.notificationList.length < 9)
                                  ? '${model.notificationList.length}'
                                  : '9+'
                              : '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                  top: 1,
                  right: 1,
                ),
              ],
            ),
            IconButton(
                icon: Icon(
                  FontAwesomeIcons.search,
                  color: Colors.white,
                  size: 20.0,
                ),
                onPressed: () {
                  model.handleAppbarActions(context, 2);
                }),
            PopMainMenu(
              model: model,
              context: context,
            ),
          ],
        ),
        body: (model.busy)
            ? Center(child: CircularProgressIndicator())
            : (model.historyList?.isEmpty ?? true)
                ? Center(
                    child: Text(
                      'oops.. no Chats',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal),
                    ),
                  )
                : ListView.builder(
                    itemCount: model.historyList.length,
                    itemBuilder: (context, index) =>
                        (model.historyList[index].totalUsers == null)
                            ? HistoryFriendWidget(
                                snapShot: model.historyList[index],
                                model: model)
                            : HistoryGroupWidget(
                                snapShot: model.historyList[index],
                                model: model)),
        floatingActionButton: SpeedDial(
            marginRight: 18,
            marginBottom: 20,
            child: Icon(Icons.message, size: 35.0, color: Colors.white),
            // this is ignored if animatedIcon is non null
            // child: Icon(Icons.add),
            visible: true,
            // If true user is forced to close dial manually
            // by tapping main button and overlay is not rendered.
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Color.fromARGB(0, 0, 0, 0),
            overlayOpacity: 0.5,
            onOpen: () => print('OPENING DIAL'),
            onClose: () => print('DIAL CLOSED'),
            tooltip: 'Speed Dial',
            heroTag: 'speed-dial-hero-tag',
            backgroundColor: Colors.lightBlueAccent,
            // elevation: 8.0,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                child: Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.red,
                onTap: () =>
                    ChatHistoryViewModel().handleFloatingAction(1, context),
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.message,
                  color: Colors.white,
                ),
                backgroundColor: Colors.blue,
                onTap: () =>
                    ChatHistoryViewModel().handleFloatingAction(2, context),
              ),
            ]),
      ),
    );
  }
}

class HistoryFriendWidget extends StatelessWidget {
  const HistoryFriendWidget(
      {Key key, @required this.snapShot, @required this.model})
      : super(key: key);
  final ChatHistory snapShot;
  final ChatHistoryViewModel model;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      child: ListTile(
        isThreeLine: true,
        //  contentPadding: EdgeInsets.all(3.0),
        dense: true,
        leading: Icon(
          Icons.person_pin,
          size: 45.0,
        ),
        title: Text(
          snapShot.name,
          style: TextStyle(
              color: Colors.black, fontSize: 23.0, fontWeight: FontWeight.w300),
        ),
        subtitle: Text(
          (snapShot.lastMessage?.isEmpty ?? true)
          ?'-: no message'
          :'-: ${snapShot.lastMessage}',
          style: TextStyle(
              color: Colors.blue, fontSize: 15.0, fontWeight: FontWeight.w400),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Text(
                '${BaseData.convertTimeStamp(snapShot.lastAction)} ago',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w100),
              ),
            ),
            Expanded(
              child: Visibility(
                visible: snapShot.totalUnseen == 0 ? false : true,
                child: Container(
                  alignment: Alignment.center,
                  height: 20,
                  width: 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple,
                  ),
                  child: Text(
                    (snapShot.totalUnseen > 9)
                        ? '9+'
                        : '${snapShot.totalUnseen}',
                    style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
        onTap: () => model.showMessages(snapShot),
      ),
    );
  }
}

class HistoryGroupWidget extends StatelessWidget {
  const HistoryGroupWidget({
    Key key,
    @required this.model,
    @required this.snapShot,
  }) : super(key: key);
  final ChatHistory snapShot;
  final ChatHistoryViewModel model;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      child: Column(
        children: <Widget>[
          ListTile(
            isThreeLine: true,
            //  contentPadding: EdgeInsets.all(3.0),
            dense: true,
            title: Text(
              snapShot.name,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.0,
                  fontWeight: FontWeight.w300),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
            ),
            subtitle: Text(
               (snapShot.lastMessage?.isEmpty ?? true)
               ?'-: no message'
              :'-: ${snapShot.lastMessage}',
              maxLines: 1,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '${BaseData.convertTimeStamp(snapShot.lastAction)} ago',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w100),
                  ),
                ),
                Expanded(
                  child: Visibility(
                    visible: snapShot.totalUnseen == 0 ? false : true,
                    child: Container(
                      alignment: Alignment.center,
                      height: 20,
                      width: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.deepOrange,
                      ),
                      child: Text(
                        (snapShot.totalUnseen > 9)
                            ? '9+'
                            : '${snapShot.totalUnseen}',
                        style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            leading: Icon(
              Icons.person_pin,
              size: 45.0,
              color: Colors.blueGrey,
            ),
            onTap: () => model.showMessages(snapShot),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: RichText(
                  textAlign: TextAlign.end,
                  text: TextSpan(
                    text: 'totalusers : ',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: int.parse(snapShot.totalUsers) > 9
                              ? '9+'
                              : snapShot.totalUsers,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber)),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
