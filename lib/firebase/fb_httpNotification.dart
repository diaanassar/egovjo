import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class FbHttpNotificationRequest {
  // List<String> listName = [
  //   "dDfXBJzNQXOkzOSi6RKgOe:APA91bHq6s1qMcqpwTF6itdksh15bzRauL6JosN5QxVc-ECdYuwCHp6NJD1G99EVN76OVIqph0P9w3hRy10yuLr2AoEJHO47Fb1VTdNaAk5ix_xZrSBllJjITyEqR9AzHuWiOJ7kn_MA",
  //   "dDfXBJzNQXOkzOSi6RKgOe:APA91bHq6s1qMcqpwTF6itdksh15bzRauL6JosN5QxVc-ECdYuwCHp6NJD1G99EVN76OVIqph0P9w3hRy10yuLr2AoEJHO47Fb1VTdNaAk5ix_xZrSBllJjITyEqR9AzHuWiOJ7kn_MA"
  // ];

  void sendNotification(String title , String body , List<dynamic> listName) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAs-dHrFg:APA91bGUg5wHIqe18L0ix5y-zmOKd44AxYnrOqxTnnul79Na5xIjgFlhGy_W86FfzkzsZKsEskQ1F32f0QJWFy-21Xkmz8G-6pE8xsU4gLcvEbQLU-tDUPle8AjpXAfDLjbgN04XDhl7'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "notification": {
        "title": title,
        "body": body,
        // "click_action": Navigator.pushNamed(context, '/login_screen'),
      },
      "data": {"keyname": "any value "},
      "registration_ids": listName
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
