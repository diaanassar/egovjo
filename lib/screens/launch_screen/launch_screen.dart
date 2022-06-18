import 'package:complaints_app/preferences/app_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LaunchScreen extends StatefulWidget {
  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      checkIsLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              child: Image.asset('images/logo.png'),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              height: 0,
              width: 0,
              child: Image.asset('images/bg3.jpg'),
            ),
          ),
        ],
      ),
    );
  }

  void checkIsLogin() async {
    await AppPreferences().initPreferences();
    await Firebase.initializeApp();
    Future.delayed(Duration(seconds: 1), () {
      if (AppPreferences().loggedIn) {
        if (AppPreferences().getUserData.levelUser == '1') {
          Navigator.pushReplacementNamed(context, '/admin_home_screen');
        } else if (AppPreferences().getUserData.levelUser == '2') {
          Navigator.pushReplacementNamed(context, '/ministry_home_screen');
        } else {
          Navigator.pushReplacementNamed(context, '/people_home_screen');
        }
      } else {
        Navigator.pushReplacementNamed(context, '/login_screen');
      }
    });
  }
}
