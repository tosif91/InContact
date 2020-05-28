import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final _auth = FirebaseAuth.instance;
  static  AuthResult _result;

  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      print('logOut...');
    } catch (e) {
      print(e);
      //handle ui intergration
    }
  }

  Future<FirebaseUser> ifUser() async {
    //  print(_auth.currentUser());
    try {
      return await _auth.currentUser();
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> logInUser(String email, String password) async {
    try {
       _result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _result;
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> registerUser(
      String myname, String myemail, String password) async {
    try {
      _result = await _auth.createUserWithEmailAndPassword(
          email: myemail, password: password);
      return _result;
    } catch (e) {
      return (e);
    }
  }
}
