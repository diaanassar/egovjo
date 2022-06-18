import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints_app/firebase/fb_auth_controller.dart';
import 'package:complaints_app/firebase/fb_firestore.dart';
import 'package:complaints_app/firebase/fb_httpNotification.dart';
import 'package:complaints_app/models/users.dart';
import 'package:complaints_app/preferences/app_preferences.dart';
import 'package:complaints_app/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'create_users_screen.dart';

class ManagementUsersScreen extends StatefulWidget {
  const ManagementUsersScreen({Key? key}) : super(key: key);

  @override
  _ManagementUsersScreenState createState() => _ManagementUsersScreenState();
}

class _ManagementUsersScreenState extends State<ManagementUsersScreen>
    with Helpers {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'User Management',
          style:
              TextStyle(color: Colors.white, fontSize: 16,),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateUserScreen())),
            icon: Icon(Icons.person_add),
          ),
        ],
      ),
      // body: reBuildWidget()
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: StreamBuilder<QuerySnapshot>(
          stream: FbFireStoreController().read(
              nameCollection: 'users', orderBy: 'levelUser', descending: false),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              List<QueryDocumentSnapshot> data = snapshot.data!.docs;
              return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      Icons.person,
                      size: 24,
                      color: colorUserIcon(data[index].get('levelUser')),
                    ),
                    title: Text(
                      '${data[index].get('name')} ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Mobile No. ${data[index].get('mobile')} '),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateUserScreen(
                            userOld: getUser(data[index]),
                          ),
                        ),
                      );
                    },
                    onLongPress: () =>
                        launch("tel://${data[index].get('mobile')}"),
                    trailing: IconButton(
                      icon: iconUser(data[index].get('isSuspend')),
                      onPressed: () {
                        if (data[index].get('levelUser') != '1') {
                          if (data[index].get('isSuspend')) {
                            Map<String, bool>? map = {"isSuspend": false};
                            changeToSuspend(
                                path: data[index].id,
                                data: map,
                                isSuspend: false);
                          } else {
                            Map<String, bool>? map = {"isSuspend": true};
                            changeToSuspend(
                                path: data[index].id,
                                data: map,
                                isSuspend: true);
                            List<String> fcm = [data[index].get('fcm')];
                            // send notifications here
                          }
                        } else {
                          showSnackBar(
                              context: context,
                              content:
                                  'Oh really !! Want to stop the admin account?',
                              error: true);
                        }
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(color: Colors.grey.shade500);
                },
                itemCount: data.length,
              );
            } else {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning, size: 85, color: Colors.grey.shade500),
                    Text(
                      'NO DATA',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void changeToSuspend(
      {required String path,
      required Map<String, bool>? data,
      required bool isSuspend}) {
    FbFireStoreController()
        .updateState(uid: path, collectionName: 'users', data: data);
  }

  Widget iconUser(bool isSuspend) {
    if (isSuspend == true) {
      return Icon(
        Icons.cancel,
        color: Colors.red,
      );
    } else {
      return Icon(
        Icons.verified_user,
        color: Colors.green,
      );
    }
  }

  Color colorUserIcon(String type) {
    if (type == '1') {
      return Colors.redAccent;
    } else if (type == '2') {
      return Colors.indigo;
    } else if (type == '3') {
      return Colors.black;
    } else if (type == '4') {
      return Colors.orangeAccent;
    }
    return Colors.black;
  }

  Users getUser(QueryDocumentSnapshot snapshot) {
    Users user = Users();
    user.path = snapshot.id;
    user.name = snapshot.get('name');
    user.email = snapshot.get('email');
    user.password = snapshot.get('password');
    user.mobile = snapshot.get('mobile');
    user.levelUser = snapshot.get('levelUser');
    user.isSuspend = snapshot.get('isSuspend');
    user.fcm = snapshot.get('fcm');
    return user;
  }
}
