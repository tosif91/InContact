import 'package:advancetut/flashchat/view_model/notification_view_model.dart';
import 'package:advancetut/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:stacked/stacked.dart';


class NotificationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Requests'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.volume_up),
            onPressed: () {},
          )
        ],
      ),
      body: ViewModelBuilder<NotificationViewModel>.reactive(
          disposeViewModel: false,
          viewModelBuilder: ()=>locator<NotificationViewModel>(),
          onModelReady: (model) => model.listenToNotificationRealTime(),
          builder: (context, model, _) => (model.busy)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : (model.notificationList ?.isEmpty??true)
                  ? Center(
                      child: Text('oops.. no notification.'),
                    )
                  : AnimationLimiter(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: model.notificationList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 400),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Card(
                                  elevation: 1.0,
                                  color:Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: ListTile(
                                          onTap: () {},
                                          title: Text(model
                                              .notificationList[index].name),
                                          subtitle: Text(model
                                              .notificationList[index].email),
                                          leading: Icon(
                                            Icons.person_pin,
                                            size: 35.0,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(
                                                Icons.check,
                                                color: Colors.green,
                                              ),
                                              onPressed: () {
                                                model.notificationList[index]
                                                        .selected =
                                                    true; //use to differentiate button  clickes
                                                model.requestHandler(
                                                    index, context);
                                              },
                                            ),
                                            IconButton(
                                              color: Colors.redAccent,
                                                icon: Icon(Icons.cancel),
                                                onPressed: () {
                                                  model.requestHandler(
                                                      index, context);
                                                }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )),
    );
  }
}
