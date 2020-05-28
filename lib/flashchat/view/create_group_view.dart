import 'package:advancetut/flashchat/utilities/constants.dart';
import 'package:advancetut/flashchat/view_model/create_group_view_model.dart';
import 'package:advancetut/flashchat/widgets/app_title.dart';
import 'package:advancetut/flashchat/widgets/show_friends_widget.dart';
import 'package:advancetut/locator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';


class CreateGroupView extends StatefulWidget {
  @override
  _CreateGroupViewState createState() => _CreateGroupViewState();
}

class _CreateGroupViewState extends State<CreateGroupView> {
  
  final TextEditingController _controller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppTitle(),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.person_add,
                color: Colors.white,
                size: 25.0,
              ),
              onPressed: (){
                 Navigator.pushNamed(context, search_friend_screen);
              },),
        ],
      ),
      body: ViewModelBuilder<CreateGroupViewModel>.reactive(
        onModelReady: (model) {
          model.fetchFriendsList();
        },
        disposeViewModel: false,
        viewModelBuilder: ()=>locator<CreateGroupViewModel>(),
        builder: (context, model, _) => Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: _controller,
                  enabled: (model.busy)?false:true,
                  textAlign: TextAlign.justify,
                  decoration: InputDecoration(
                    hintText: 'group subject',
                    contentPadding: EdgeInsets.fromLTRB(5.0,0.0,0.0,0.0),
                    )),
            ),
            //widget to show list of all ther friends of the user
            Expanded(
                child: ShowFriendWidget()),//its an view model widget
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(
                builder: (context) => Opacity(
                  opacity: (model.busy || model.friendList == null) ? 0.0 : 1,
                  child: IconButton(
                    color: Colors.blue,
                    icon: Icon(
                      Icons.check_circle,
                      size: 45.0,
                    ),
                    onPressed: () {
                      // create group
                      (_controller.text.trim() != '')
                          ? (model.totalSelection != 0)
                              ? model.createGroup(_controller.text.trim().toLowerCase(), context)
                              : Scaffold.of(context).showSnackBar(SnackBar(
                                  content:
                                      Text('Select more then One friend.')))
                          : Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Group title is Empty.')));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
