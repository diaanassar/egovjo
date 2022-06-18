import 'package:complaints_app/preferences/app_preferences.dart';
import 'package:flutter/material.dart';

import 'drawer_ministry_widget.dart';

class MinistryHomeScreen extends StatefulWidget {
  const MinistryHomeScreen({Key? key}) : super(key: key);

  @override
  _MinistryHomeScreenState createState() => _MinistryHomeScreenState();
}

class _MinistryHomeScreenState extends State<MinistryHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMinistryWidget(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Ministry Screen' , style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,

      ),body: Center(child: Text('Welecome back ${AppPreferences().getUserData.name}'),),
    );
  }
}
