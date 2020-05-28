
import 'package:intl/intl.dart';

const login_screen = '/login';
const welcome_screen = '/welcome';
const registration_screen = '/registration';
const chat_screen = '/chat';
const splash_screen='/splash';
const friend_search_screen='/search';
const chat_history_screen='/history';
const search_friend_screen='/searchfriend';
const create_group_screen='/creategroup';
const notification_screen='/notification';
const friend_list_screen='/myfriends';

class BaseData{

static List<String> menuChoice=<String>[
  'Profile',
  'Favourite messages',
  'Settings',
  'LogOut',
];

static String convertTimeStamp(String time) {
  return DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(int.parse(time))).toString();
  }
}