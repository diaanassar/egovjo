import 'package:complaints_app/firebase/fb_auth_controller.dart';
import 'package:complaints_app/screens/after_login/discussions_screen/discussions_screen.dart';
import 'package:complaints_app/screens/after_login/people_screen/all_complaint_screen.dart';
import 'package:complaints_app/screens/after_login/people_screen/send_complaint_screen.dart';
import 'package:flutter/material.dart';

import 'ministry_home_screen.dart';

class DrawerMinistryWidget extends StatelessWidget {
  const DrawerMinistryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/jordan.png'), fit: BoxFit.cover),
              // color: Colors.blue,
            ),
            child: Text(''),
          ),

          ListTile(
            title: const Text('All Orders'),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => AllComplaintScreen()), (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            title: const Text('Special Orders'),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => DiscussionsScreen()), (Route<dynamic> route) => false);
            },
          ),
          // ListTile(
          //   title: const Text('Discussions'),
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => DiscussionsScreen()));
          //   },
          // ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //     '/settings_screen', (Route<dynamic> route) => false);
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/settings_screen');
            },
          ),
          ListTile(
            title: const Text('LogOut'),
            onTap: () {
              Navigator.of(context).pop();
              showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
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
                onPressed: () => signOut(context),
                child: Text(
                  'Yes',
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


  Future<void> signOut(BuildContext context) async {
    await FbAuthController().signOut(context);

  }
}
