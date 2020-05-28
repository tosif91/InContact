import 'package:advancetut/flashchat/view_model/friend_list_view_model.dart';
import 'package:advancetut/locator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';


class FriendListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
      ),
      body: ViewModelBuilder<FriendListViewModel>.reactive(
        viewModelBuilder: ()=>locator<FriendListViewModel>(),
        onModelReady: (model) => model.fetchFriend(),
        disposeViewModel: false,
        builder: (context, model, _) => (model.busy)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ( model.friendList?.isEmpty ?? true)
                ? Center(child: Text('ooPs.. you dont have any friend'))
                : ListView.builder(
                    itemCount: model.friendList.length,
                    itemBuilder: (context, index) => Card(
                          elevation: 2.0,
                          margin: EdgeInsets.all(2.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                                              child: ListTile(
                                  leading: Icon(Icons.person),
                                  title: Text(model.friendList[index].name),
                                  subtitle: Text(model.friendList[index].email),
                                  dense: true,
                                  onTap: () => model.sendMessage(model.friendList[index]),
                                 // trailing:IconButton(icon: Icon(Icons.cancel), onPressed: model.unfriend(model.friendList[index],index)),
                                ),
                              ),
                              IconButton(color: Colors.red,  icon: Icon(Icons.cancel), onPressed: ()=>model.unfriend(model.friendList[index], index)),
                            ],
                          ),
                        )),
      ),
    );
  }
}
