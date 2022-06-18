import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  late String path;
  late String problemText;
  late String address;
  late String senderName;
  late String senderEmail;
  late String senderMobile;
  late String ministryName;
  late String ministryReplay;
  late String adminReplay;
  late bool isDoneFromAdmin;
  late bool isDoneFromMinistry;
  late bool isBackToMinistry;
  late String countImageUpload;
  late String urlImage1;
  late String urlImage2;
  late String urlImage3;
  late String urlImage4;
  late String urlImage5;
  late String urlImage6;
  late String urlImage7;
  late String urlImage8;
  late String urlImage9;
  late String urlImage10;
  late String day;
  late String date;
  late DateTime timeReport;

  Report();

  Report.fromMap(Map<String, dynamic> map) {
    problemText = map['problemText'];
    address = map['address'];
    senderName = map['senderName'];
    senderEmail = map['senderEmail'];
    senderMobile = map['senderMobile'];
    ministryName = map['ministryName'];
    ministryReplay = map['ministryReplay'];
    adminReplay = map['adminReplay'];
    isDoneFromAdmin = map['isDoneFromAdmin'];
    isDoneFromMinistry = map['isDoneFromMinistry'];
    isBackToMinistry = map['isBackToMinistry'];
    countImageUpload = map['countImageUpload'];
    urlImage1 = map['urlImage1'];
    urlImage2 = map['urlImage2'];
    urlImage3 = map['urlImage3'];
    urlImage4 = map['urlImage4'];
    urlImage5 = map['urlImage5'];
    urlImage6 = map['urlImage6'];
    urlImage7 = map['urlImage7'];
    urlImage8 = map['urlImage8'];
    urlImage9 = map['urlImage9'];
    urlImage10 = map['urlImage10'];
    day = map['day'];
    date = map['date'];
    timeReport = map['timeReport'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['problemText'] = problemText;
    map['address'] = address;
    map['senderName'] = senderName;
    map['senderEmail'] = senderEmail;
    map['senderMobile'] = senderMobile;
    map['ministryName'] = ministryName;
    map['ministryReplay'] = ministryReplay;
    map['adminReplay'] = adminReplay;
    map['isDoneFromAdmin'] = isDoneFromAdmin;
    map['isDoneFromMinistry'] = isDoneFromMinistry;
    map['isBackToMinistry'] = isBackToMinistry;
    map['countImageUpload'] = countImageUpload;
    map['urlImage1'] = urlImage1;
    map['urlImage2'] = urlImage2;
    map['urlImage3'] = urlImage3;
    map['urlImage4'] = urlImage4;
    map['urlImage5'] = urlImage5;
    map['urlImage6'] = urlImage6;
    map['urlImage7'] = urlImage7;
    map['urlImage8'] = urlImage8;
    map['urlImage9'] = urlImage9;
    map['urlImage10'] = urlImage10;
    map['day'] = day;
    map['date'] = date;
    map['timeReport'] = timeReport;
    return map;
  }
}
