import 'package:advancetut/flashchat/view_model/search_friend_view_model.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final SearchFriendViewModel model;

   SearchBarWidget({
   this.model
    });

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
   TextEditingController _controller=TextEditingController();
    
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      color: Colors.white,
      margin: EdgeInsets.all(5.0),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.text,
              style:TextStyle(color:Colors.black,fontSize: 20.0,fontWeight: FontWeight.w300),
              decoration: InputDecoration(
                isDense: true,
                hintStyle: TextStyle(color:Colors.blueGrey,fontSize:20.0,),
                border: InputBorder.none,
                hintText: 'search here...',
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Builder(
                          builder:(context)=> 
                          (widget.model.busy)
                          ?Center(child: SizedBox( width:25.0,height:25.0,child: CircularProgressIndicator(backgroundColor: Colors.lightBlue,)))
                          :IconButton(
                            splashColor: Colors.grey,
                          iconSize: 30.0,
                 icon: Icon(Icons.search,color: Colors.blue,),
                 onPressed: ()async{
                  if(_controller.text.trim() != '')
                 {await widget.model.searchFriend(_controller.text.trim().toLowerCase());
                 print(_controller.text.trim().toLowerCase());
                 }
                  else
                   Scaffold.of(context).showSnackBar(
                     SnackBar(content: Text('name is empty.'),)
                   );
                  },
              ),
            ),
          )
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
