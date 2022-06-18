import 'package:flutter/material.dart';

mixin Helpers {
  void showSnackBar(
      {required BuildContext context,
      required String content,
      bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content , style: TextStyle(fontSize: 12 , fontWeight: FontWeight.bold),),
        behavior: SnackBarBehavior.floating,
        duration:  Duration(seconds: 2),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }
}
