import 'package:chat_app_flutter/helper/helper_functions.dart';
import 'package:chat_app_flutter/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //login
  Future loginUserWithEmailandPassword(String email, String password) async {
    try {
      User user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      // ignore: unnecessary_null_comparison
      if (user != null) {
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException {
      return 'Lütfen Mail Adresinizi veya Şifrenizi Kontrol Ediniz';
    }
  }

  //register
  Future registerUserWithEmailandPassword(
      String name, String email, String password) async {
    try {
      User user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      DatabaseService(uid: user.uid).savingUserData(name, email);
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //signOut
  Future signOut() async {
    try {
      await HelperFunctions.saveUserEmail("");
      await HelperFunctions.saveUserName("");
      await HelperFunctions.saveUserLoggedInStatus(false);
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
