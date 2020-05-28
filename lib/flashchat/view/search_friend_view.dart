import 'package:advancetut/flashchat/view_model/search_friend_view_model.dart';
import 'package:advancetut/flashchat/widgets/search_bar_widget.dart';
import 'package:advancetut/locator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';


class SearchFriendView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' add friends',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
          child: ViewModelBuilder<SearchFriendViewModel>.reactive(
        viewModelBuilder:()=>locator<SearchFriendViewModel>(),
       //disposeViewModel: false,
        onModelReady: (model) {
          model.listenToRequestRecievedRealtime();
        },
        builder: (context, model, _) => Column(
          children: <Widget>[
           SearchBarWidget(
              model: model,
            ),
            Expanded(
              child: (model.busy)
                  ? Center(child: Text('loading....'))
                  : (model.searchList?.isEmpty??true)
                      ? (model.handlingRequest)
                          ? Center(
                              child: Text('oops. no Result...'),
                            )
                          : Center(
                              child: Text('search someone...'),
                            )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: model.searchList.length,
                          itemBuilder: (context, index) => Card(
                            child: (model.searchList[index].recieved)
                                ? IfRecievedRequestWidget(
                                    model: model, index: index)
                                : IfSendRequestWidget(
                                    model: model,
                                    index: index,
                                  ),
                          ),
                        ),
            )
          ],
        ),
      )),
    );
  }
}

class IfSendRequestWidget extends StatelessWidget {
  final SearchFriendViewModel model;
  final int index;
  const IfSendRequestWidget({this.model, this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${model.searchList[index].name}'),
      subtitle: Text('${model.searchList[index].email}'),
      leading:
          Icon(Icons.person), //fetch url ofr user profile later and show it.
      trailing: IconButton(
        color: (model.searchList[index].selected)
            ? Colors.lightBlue
            : Colors.grey[70],
        icon: (model.searchList[index].isFriend)
            ? Icon(Icons.check)
            : Icon(Icons.person_add),
        onPressed: (model.searchList[index].isFriend)
            ? null
            : () {
                // both add and remove friend will be handle here
                model.requestHandler(index, context);
              },
      ),
    );
  }
}

class IfRecievedRequestWidget extends StatelessWidget {
  final SearchFriendViewModel model;
  final int index;

  const IfRecievedRequestWidget({this.model, this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: ListTile(
            onTap: () {},
            title: Text(model.searchList[index].name),
            subtitle: Text(model.searchList[index].email),
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
                  color: Colors.white,
                ),
                onPressed: () {
                  model.searchList[index].selected = true;
                  model.requestHandler(index, context);
                },
              ),
              IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    model.searchList[index].selected = false;
                    model.requestHandler(index, context);
                  }),
            ],
          ),
        ),
      ],
    );
  }
}
