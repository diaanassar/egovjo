import 'package:complaints_app/firebase/fb_auth_controller.dart';
import 'package:complaints_app/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with Helpers {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Settings',
          style: TextStyle(
              color: Colors.white, fontSize: 16),
        ),
      ),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          // ListTile(
          //   onTap: () => showLogoutDialog(),
          //   leading: Icon(
          //     Icons.logout,
          //     color: Colors.black,
          //   ),
          //   title: Text('Logout',
          //       style: TextStyle(
          //           color: Colors.black,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 15)),
          // ),
          // Divider(height: 10, color: Colors.grey.shade500),
          ListTile(
            onTap: () =>
                Navigator.pushNamed(context, '/change_password_screen'),
            leading: Icon(
              Icons.vpn_key,
              color: Colors.black,
            ),
            title: Text('Change Password',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ),
        ],
      ),
    );
  }

  void showLogoutDialog() {
    showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.5),
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Logout',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,),
            ),
            content: Text(
              'Do you really want to log out!',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
            ),
            actionsOverflowDirection: VerticalDirection.up,
            actionsOverflowButtonSpacing: 30,
            // actionsPadding: EdgeInsets.only(right: 30),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.green, width: 2),
            ),
            // insetPadding: EdgeInsets.only(left: 40),
            actions: [
              TextButton(
                onPressed: () => signOut(),
                child: Text(
                  'yes',
                  style: TextStyle(
                      color: Colors.green,  fontSize: 12),
                ),
              ),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'No',
                    style: TextStyle(
                        color: Colors.green,  fontSize: 12),
                  )),
            ],
          );
        });
  }


  Future<void> signOut() async {
    await FbAuthController().signOut(context);

  }

}
