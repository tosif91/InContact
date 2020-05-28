import 'package:advancetut/flashchat/services/alert_service.dart';
import 'package:advancetut/flashchat/services/authentication_service.dart';
import 'package:advancetut/flashchat/services/cloud_storage_service.dart';
import 'package:advancetut/flashchat/services/database_service.dart';
import 'package:advancetut/flashchat/services/file_handler_service.dart';
import 'package:advancetut/flashchat/services/local_storage_service.dart';
import 'package:advancetut/flashchat/view_model/chat_history_view_model.dart';
import 'package:advancetut/flashchat/view_model/chat_view_model.dart';
import 'package:advancetut/flashchat/view_model/create_group_view_model.dart';
import 'package:advancetut/flashchat/view_model/friend_list_view_model.dart';
import 'package:advancetut/flashchat/view_model/notification_view_model.dart';
import 'package:advancetut/flashchat/view_model/search_friend_view_model.dart';
import 'package:advancetut/flashchat/widgets/search_bar_widget.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';


GetIt locator=GetIt.instance;

setUpLocator(){
  //stacked service..
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
//......
  locator.registerFactory(()=>ChatViewModel());
  locator.registerLazySingleton(()=>CreateGroupViewModel());
  locator.registerFactory(()=>ChatHistoryViewModel());
  locator.registerLazySingleton(()=>SearchFriendViewModel());
  locator.registerLazySingleton(()=>NotificationViewModel());
  //locator.registerLazySingleton(()=>ChatViewModel());
  locator.registerLazySingleton(()=>FriendListViewModel());
  
  //services here................... 
  locator.registerLazySingleton(() => CloudStorageService());
  locator.registerLazySingleton(()=>AlertService());
  locator.registerLazySingleton(()=>AuthenticationService()); 
  locator.registerLazySingleton(()=>DatabaseService());
  locator.registerLazySingleton(()=>LocalStorageService());
  locator.registerLazySingleton(() => FileHandlerService());
}
