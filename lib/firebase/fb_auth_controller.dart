import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:complaints_app/models/users.dart';
import 'package:complaints_app/preferences/app_preferences.dart';
import 'package:complaints_app/utils/helpers.dart';
import 'fb_firestore.dart';

class FbAuthController with Helpers {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> createAccountFromAdmin(BuildContext context,
      {required Users users}) async {
    try {
      loadingDialog(context, true);
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: users.email, password: users.password);
      print('create done');
      await FbFireStoreController()
          .createUserFromAdmin(users: users, uid: userCredential.user!.uid);
      loadingDialog(context, false);
      return true;
    } on FirebaseAuthException catch (e) {
      _controlErrorCodes(context, e);
    } catch (e) {
      showSnackBar(
          context: context, content: 'There is a problem with the internet', error: true);
      print('Exception: $e');
    }
    return false;
  }

  Future<bool> createAccount(BuildContext context,
      {required Users users}) async {
    try {
      UserCredential userCredential =
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: users.email, password: users.password);
      // await _controlEmailValidation(context,
      //     crede ntial: userCredential, users: null);
      await FbFireStoreController().createUser(
          context: context, users: users, uid: userCredential.user!.uid);
      return true;
    } on FirebaseAuthException catch (e) {
      _controlErrorCodes(context, e);
    } catch (e) {
      showSnackBar(
          context: context, content: 'There is a problem with the internet', error: true);
      print('Exception: $e');
    }
    return false;
  }

  Future<bool> signIn(BuildContext context,
      {required String email, required String password}) async {
    try {
      loadingDialog(context, true);
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      Users dataUserLogin = await FbFireStoreController()
          .getUserData(uid: userCredential.user!.uid);

      if (dataUserLogin.isSuspend) {
        loadingDialog(context, false);
        FocusScope.of(context).requestFocus(FocusNode());
        await _firebaseAuth.signOut();
        showSnackBar(
            context: context,
            content: 'Your account has been suspended',
            error: true);
        return false;
      }
      await AppPreferences()
          .saveLogin(users: dataUserLogin, path: userCredential.user!.uid);

      goToScreen(context, dataUserLogin);
      return true;
    } on FirebaseAuthException catch (e) {
      _controlErrorCodes(context, e);
    } catch (e) {
      showSnackBar(
          context: context, content: 'There is a problem with the internet', error: true);
      print('Exception: $e');
    }
    return false;
  }

  User get user => _firebaseAuth.currentUser!;

  Future<bool> updatePassword(BuildContext context, {String? password}) async {
    try {
      await _firebaseAuth.currentUser!.updatePassword(password!);
      AppPreferences().saveAndChangePassword(password: password);
      FbFireStoreController().updateUser(
          uid: AppPreferences().getUserData.path,
          users: AppPreferences().getUserData);
      return true;
    } on FirebaseAuthException catch (e) {
      _controlErrorCodes(context, e);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> signOut(BuildContext context) async {
    await AppPreferences().logout();
    await _firebaseAuth.signOut();
    // Navigator.of(context).popUntil(ModalRoute.withName('/login_screen'));
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/login_screen', (Route<dynamic> route) => false);
  }

  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  void _controlErrorCodes(
      BuildContext context, FirebaseAuthException authException) {
    loadingDialog(context, false);
    FocusScope.of(context).requestFocus(FocusNode());
    print(authException.code);
    switch (authException.code) {
      case 'email-already-in-use':
        showSnackBar(
            context: context, content: 'This email already exists', error: true);
        break;

      case 'invalid-email':
        showSnackBar(context: context, content: 'Enter a valid email', error: true);
        break;

      case 'operation-not-allowed':
        break;

      case 'weak-password':
        showSnackBar(
            context: context,
            content: 'password used is weak ',
            error: true);

        break;

      case 'user-not-found':
        showSnackBar(
            context: context,
            content: 'Incorrect email or password',
            error: true);

        break;

      case 'requires-recent-login':
        break;

      case 'wrong-password':
        showSnackBar(
            context: context,
            content: 'Incorrect email or password',
            error: true);
        break;

      case 'too-many-requests':
        showSnackBar(
            context: context,
            content: 'Activate your account first via email',
            error: true);
        break;
    }
  }

  Future<bool> forgetPassword(BuildContext context,
      {required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      _controlErrorCodes(context, e);
    } catch (e) {
      print(e);
    }
    return false;
  }

  void goToScreen(BuildContext context, Users data) {
    if (data.levelUser == '1') {
      loadingDialog(context, false);
      Navigator.pushReplacementNamed(context, '/admin_home_screen');
    } else if (data.levelUser == '2') {
      loadingDialog(context, false);
      Navigator.pushReplacementNamed(context, '/ministry_home_screen');
    } else if (data.levelUser == '3') {
      loadingDialog(context, false);
      Navigator.pushReplacementNamed(context, '/people_home_screen');
    }
  }

  void loadingDialog(BuildContext context, bool run) {
    if (run)
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
    else {
      Navigator.pop(context);
    }
  }
}
