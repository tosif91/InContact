import 'package:advancetut/flashchat/models/chat_history.dart';
import 'package:advancetut/flashchat/models/message.dart';
import 'package:advancetut/flashchat/models/user.dart';
import 'package:advancetut/flashchat/view_model/chat_view_model.dart';
import 'package:advancetut/flashchat/widgets/input_bar_widget.dart';
import 'package:advancetut/flashchat/widgets/message_card_reciever.dart';
import 'package:advancetut/flashchat/widgets/message_card_sender.dart';
import 'package:advancetut/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';

class ChatView extends StatefulWidget {
  final dynamic
      userChatHistoryInfo; // this object may be of Friend(FriendListView) or ChatHistory(ChatHistoryView)..
  ChatView({this.userChatHistoryInfo});
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.userChatHistoryInfo.name,
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  FontAwesomeIcons.search,
                  color: Colors.white60,
                  size: 20.0,
                ),
                onPressed: () {}),
          ],
        ),
        body: ChatScreen(userChatHistoryInfo: widget.userChatHistoryInfo));
  }
}

class ChatScreen extends StatelessWidget {
  User _userInfo;
  final dynamic userChatHistoryInfo;
  ChatScreen({this.userChatHistoryInfo});
  ScrollController _controller = ScrollController();
  int i = 0;
  int totalMessages;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatViewModel>.reactive(
      viewModelBuilder: () => locator<ChatViewModel>(),
      onModelReady: (model) async {
        model.listenToMessages(userChatHistoryInfo.groupId);
        _userInfo = model.getUserInfo();
        if (userChatHistoryInfo is ChatHistory) {
          await model.messageSeen(userChatHistoryInfo.groupId);
          if (userChatHistoryInfo.totalUsers != null)
            model.listenToGroupInfo(userChatHistoryInfo.groupId);
        }
        _controller.addListener(()  {
          if (_controller.offset >= _controller.position.maxScrollExtent &&
              !_controller.position.outOfRange) {
            print('reach bottom');
            //TODO:call ten more message request;
            model.isLoading=true;
             model.moreMessageRequest(userChatHistoryInfo.groupId);
            model.isLoading=false;
          }
          if (_controller.offset <= _controller.position.minScrollExtent &&
              !_controller.position.outOfRange) {
            print('reach top');
          }
        });
      },
      builder: (context, model, _) => Column(
        children: <Widget>[
          Expanded(
            child: (model.busy)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : (model.messages?.isEmpty ?? true)
                    ? Center(child: Text('oops no messages'))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Visibility(
                              visible: (model.isLoading) ? true : false,
                              child: Center(
                                widthFactor: 25.0,
                                heightFactor: 25.0,
                                child: CircularProgressIndicator(),
                              )),
                          Expanded(
                            flex: 3,
                            child: ListView.builder(
                                reverse: true,
                                key: PageStorageKey('liskKey'),
                               // shrinkWrap: true,
                                controller: _controller,
                                itemCount: model.messages.length,
                                itemBuilder: (context, index) =>
                                    (model.messages[index].uid == _userInfo.uid)
                                        ? MessageCardSender(
                                            snapShot: model.messages[index],
                                            state: model.messages[index].send)
                                        : MessageCardReciever(
                                            snapShot: model.messages[index],
                                          )),
                          ),
                        ],
                      ),
          ),
          InputBar(
              viewModel: model,
              userData: _userInfo,
              groupInfo: (userChatHistoryInfo is ChatHistory &&
                      userChatHistoryInfo.totalUsers != null)
                  ? model.groupInfo //when its an old history.
                  : userChatHistoryInfo, // this may be Friend/ChatHistory object.,
              scrollFunction:()=> handleScroll()),
        ],
      ),
    );
  }

   handleScroll() {
    print('called handleScroll');
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (_controller.hasClients) {
     
          _controller.animateTo(
            _controller.position.minScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.ease,
          );
      }
    });
  }
}
