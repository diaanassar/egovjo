import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints_app/models/Report.dart';
import 'package:complaints_app/models/suggestion.dart';
import 'package:flutter/cupertino.dart';
import 'package:complaints_app/models/users.dart';
import 'package:complaints_app/utils/helpers.dart';

class FbFireStoreController with Helpers {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> read(
      {required String nameCollection,
      required String orderBy,
      required bool descending}) async* {
    yield* _firebaseFirestore
        .collection(nameCollection)
        .orderBy(orderBy, descending: descending)
        .snapshots();
  }

  Future<Users> getUserData({required String uid}) async {
    Users users = Users();
    final DocumentReference document =
        _firebaseFirestore.collection("users").doc(uid);
    await document.get().then<Users>((DocumentSnapshot snapshot) async {
      users.name = snapshot.get('name');
      users.email = snapshot.get('email');
      users.password = snapshot.get('password');
      users.levelUser = snapshot.get('levelUser');
      users.mobile = snapshot.get('mobile');
      users.fcm = snapshot.get('fcm');
      users.isSuspend = snapshot.get('isSuspend');
      return users;
    });
    return users;
  }

  Future<bool> createUser(
      {required BuildContext context,
      required Users users,
      required String uid}) async {
    return await _firebaseFirestore
        .collection('users')
        .doc(uid)
        .set(users.toMap())
        .then((value) {
      showSnackBar(
          context: context,
          content: 'The account has been created successfully.');
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Future<Users> getUserFcm({required String uid}) async {
    Users users = Users();
    final DocumentReference document =
        _firebaseFirestore.collection('users').doc(uid);
    await document.get().then<Users>((DocumentSnapshot snapshot) async {
      users.fcm = snapshot.get('fcm');
      return users;
    });
    return users;
  }

  Future<List<dynamic>> getArray(
      {required String uid, required String nameArray}) async {
    List<dynamic> array = <dynamic>[];
    final DocumentReference document =
        _firebaseFirestore.collection('arrays').doc(uid);
    await document.get().then<List<dynamic>>((DocumentSnapshot snapshot) async {
      List.from(snapshot.get(nameArray)).forEach((element) {
        String data = (element);
        array.add(data);
      });
      return array;
    });
    return array;
  }

  Future<bool> updateArray(
      {required String nameDoc,
      required String nameArray,
      required List<dynamic> data}) async {
    return await _firebaseFirestore
        .collection('arrays')
        .doc(nameDoc)
        .update({nameArray: FieldValue.arrayUnion(data)})
        .then((value) => true)
        .catchError((error) => false);
  }


  Future<bool> updateArray2(
      {required String nameCollection,
        required String nameDoc,
        required String nameArray,
        required List<dynamic> data}) async {
    return await _firebaseFirestore
        .collection(nameCollection)
        .doc(nameDoc)
        .update({nameArray: FieldValue.arrayUnion(data)})
        .then((value) => true)
        .catchError((error) {
      print(error);
      return false;
    });
  }

  Future<bool> deleteFromArray(
      {required String nameDoc,
      required String nameArray,
      required List<dynamic> data}) async {
    return await _firebaseFirestore
        .collection('arrays')
        .doc(nameDoc)
        .update({nameArray: FieldValue.arrayRemove(data)})
        .then((value) => true)
        .catchError((error) => false);
  }
  Future<bool> deleteFromArray2(
      {required String nameCollection,
        required String nameDoc,
        required String nameArray,
        required List<dynamic> data}) async {
    return await _firebaseFirestore
        .collection(nameCollection)
        .doc(nameDoc)
        .update({nameArray: FieldValue.arrayRemove(data)})
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> createUserFromAdmin(
      {required Users users, required String uid}) async {
    return await _firebaseFirestore
        .collection('users')
        .doc(uid)
        .set(users.toMap())
        .then((value) {
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Future<bool> updateUser({required String uid, required Users users}) async {
    return await _firebaseFirestore
        .collection('users')
        .doc(uid)
        .update(users.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> updateFcm(
      {required String uid, required Map<String, String>? data}) async {
    return await _firebaseFirestore
        .collection('users')
        .doc(uid)
        .update(data!)
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> updateUserIsSuspend(
      {required String uid, required Map<String, bool>? data}) async {
    return _firebaseFirestore
        .collection('users')
        .doc(uid)
        .update(data!)
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> updateAllUsersPassword(
      {required String uid, required Map<String, String>? data}) async {
    return await _firebaseFirestore
        .collection('users')
        .doc(uid)
        .update(data!)
        .then((value) => true)
        .catchError((error) => false);
  }

  //
  Future<bool> createReport(
      {required BuildContext context, required Report reports}) async {
    return await _firebaseFirestore
        .collection('Reports')
        .doc()
        .set(reports.toMap())
        .then((value) {
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }
  //
  Future<bool> updateReport(
      {required BuildContext context,
      required String uid,
      required Report reports}) async {
    return await _firebaseFirestore
        .collection('Reports')
        .doc(uid)
        .update(reports.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> createSuggestion(
      {required BuildContext context, required Suggestion suggestions}) async {
    return await _firebaseFirestore
        .collection('suggestion')
        .doc()
        .set(suggestions.toMap())
        .then((value) {
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Future<bool> updateState(
      {required String uid,
      required String collectionName,
      required Map<String, dynamic>? data}) async {
    return await _firebaseFirestore
        .collection(collectionName)
        .doc(uid)
        .update(data!)
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> createNotification(
      {required BuildContext context,
      required Map<String, dynamic>? data}) async {
    return await _firebaseFirestore
        .collection('Notifications')
        .doc()
        .set(data!)
        .then((value) {
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Future<bool> updateNotification(
      {required String uid, required Map<String, String>? data}) async {
    return await _firebaseFirestore
        .collection('Notifications')
        .doc(uid)
        .update(data!)
        .then((value) => true)
        .catchError((error) => false);
  }
}
