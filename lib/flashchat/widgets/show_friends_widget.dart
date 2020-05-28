import 'package:advancetut/flashchat/view_model/create_group_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ShowFriendWidget extends ViewModelWidget<CreateGroupViewModel> {

  @override
  Widget build(BuildContext context, CreateGroupViewModel model) {
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Expanded(flex: 1, child: Text('Friend Lists')),
              Expanded(
                flex: 1,
                child: IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      //refresh list of the friends
                      model.fetchFriendsList();
                    }),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'totalSelection :',
                    ),
                    Text('${model.totalSelection}')
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        (model.busy)
            ? Expanded(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : (model.friendList?.isEmpty ?? true)
                ? Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'no friend search now. ',
                            style: TextStyle(color: Colors.black87),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.group_add,
                              size: 30.0,
                              color: Colors.amber,
                            ),
                            onPressed: () => model.searchFriend(),
                          )
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: model.friendList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 2.0,
                          color: (model.friendList[index].selected)
                              ? Colors.lightBlue
                              : Colors.white,
                          child: ListTile(
                            onTap: () {
                              (!model.friendList[index].selected)
                                  ? model.selectItem(index)
                                  : model.unselectItem(index);
                            },
                            title: Text(
                              model.friendList[index].name,
                              style: TextStyle(
                                color: (model.friendList[index].selected)
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                            ),
                            subtitle: Text(model.friendList[index].email, style: TextStyle(
                                color: (model.friendList[index].selected)
                                    ? Colors.white
                                    : Colors.black54,
                              ),),
                            leading: Icon(
                              Icons.person_pin,
                              color: (model.friendList[index].selected)
                                    ? Colors.white
                                    : Colors.black54,
                              size: 35.0,
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                  (model.friendList[index].selected)
                                      ? Icons.cancel
                                      : Icons.add_circle,
                                  color: (model.friendList[index].selected)
                                      ? Colors.amber
                                      : Colors.white,
                                  size: 30.0),
                              onPressed: () {
                                (!model.friendList[index].selected)
                                    ? model.selectItem(index)
                                    : model.unselectItem(index);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ],
    );
  }
}
