import 'package:complaints_app/screens/after_login/discussions_screen/discussions_screen.dart';
import 'package:complaints_app/screens/auth_screen/create_account_screen.dart';
import 'package:flutter/material.dart';
import 'screens/after_login/ministry_screen/ministry_home_screen.dart';
import 'screens/after_login/people_screen/all_complaint_screen.dart';
import 'screens/auth_screen/change_password_screen.dart';
import 'screens/auth_screen/forget_password_screen.dart';
import 'screens/auth_screen/settings_screen.dart';
import 'screens/launch_screen/launch_screen.dart';
import 'screens/auth_screen/login_screen.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/launch_screen',
      routes: {
        '/launch_screen': (context) => LaunchScreen(),
        '/login_screen': (context) => LoginScreen(),
        '/create_account_screen': (context) => CreateAccountScreen(),
        '/forget_password_screen': (context) => ForgetPasswordScreen(),
        '/change_password_screen': (context) => ChangePasswordScreen(),
        '/settings_screen': (context) => SettingsScreen(),
        '/admin_home_screen': (context) => AllComplaintScreen(),
        '/ministry_home_screen': (context) => AllComplaintScreen(),
        '/people_home_screen': (context) => DiscussionsScreen(),
      },
    );
  }
}
