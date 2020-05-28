import 'package:advancetut/flashchat/models/user.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class LocalStorageService{
 
 static  String _userBox='userinfo';
 
 
 Future<dynamic>saveUserInfo(User user)async{
   var userInfo=Hive.box(_userBox);
   try{
   await userInfo.putAll(user.toMap());
   print('${userInfo.get('name')}saving user data');
      return true;
   }
   catch(e){
     return false;
   }
 }
 
 User getUserInfo(){
   var userInfo=Hive.box(_userBox);
   return User(name: userInfo.get('name'),email: userInfo.get('email'),uid: userInfo.get('uid'));
 }
 
 bool checkState(){
   //this function provide state of box is present or not.
   var userInfo=Hive.box(_userBox);
   return userInfo.containsKey('uid');
 }
 
static Future<bool>  openBoxUserInfo()async{
   final getappDocumentDirectory =
        //get path for hive
        await path_provider.getApplicationDocumentsDirectory();
    //intiliase hive.
    Hive.init(getappDocumentDirectory.path);
    return await Hive.openBox('userinfo').then(
      (value) => value.isOpen?true:false,
    );
}
}