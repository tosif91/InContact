import 'package:advancetut/flashchat/models/user.dart';
import 'package:advancetut/flashchat/view_model/chat_view_model.dart';
import 'package:flutter/material.dart';

class InputBar extends StatefulWidget {
  final ChatViewModel viewModel;
    final User userData;
     VoidCallback scrollFunction;
   dynamic groupInfo;  //this may be ChatHistory or Friend.
  InputBar({@required this.viewModel,@required this.userData,@required this.groupInfo, this.scrollFunction});
@override
  _InputBarState createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
final    TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Container(
        //   margin: EdgeInsets.all(15.0),
        //height: 61,
        child: Column(
          children: <Widget>[
            
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35.0),
                      boxShadow: [
                        const BoxShadow(
                            offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)
                      ],
                    ),
                    child: Padding(
                        
                        padding: const EdgeInsets.fromLTRB(3.0, 0.0, 0.0, 0.0),
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                              hintText: '  type here...',             //TODO: add margin here
                              border: InputBorder.none,
                              hintStyle:
                                  const TextStyle(color: Colors.blueGrey)),
                          style: const TextStyle(
                              color: Colors.blueGrey,
                              decoration: TextDecoration.none),
                        ),
                      ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.blue, shape: BoxShape.circle),
                  child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: ()async {     //function to handle message send
                        if(_controller.text.trim() != '')
                        {
                          
                        var msg=_controller.text;
                       _controller.clear();
                       await widget.viewModel.sendMessage(msg, widget.userData,widget.groupInfo);
                       widget.scrollFunction.call();
                        }
                        else{
                          print('empty message');// handle on empty state..
                        }
                      }),
                ),
              ],
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


