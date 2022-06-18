import 'package:cloud_firestore/cloud_firestore.dart';

class Suggestion {
  late String path;
  late String suggestionText;
  late String urlImage1;
  late String date;
  late String senderName;
  late String senderEmail;
  late String senderMobile;
  late bool   isShowSuggestion;
  late String voteSum;
  late List<dynamic> replayArrayPlus;
  late List<dynamic> replayArray;
  late List<dynamic> votePlusEmail;
  late List<dynamic> voteMinusEmail;

  Suggestion();

  Suggestion.fromMap(Map<String, dynamic> map) {
    suggestionText = map['suggestionText'];
    urlImage1 = map['urlImage1'];
    date = map['date'];
    senderName = map['senderName'];
    senderEmail = map['senderEmail'];
    senderMobile = map['senderMobile'];
    isShowSuggestion = map['isShowSuggestion'];
    voteSum = map['voteSum'];
    replayArray = map['replayArray'];
    voteMinusEmail = map['voteMinusEmail'];
    votePlusEmail = map['votePlusEmail'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['suggestionText'] = suggestionText;
    map['urlImage1'] = urlImage1;
    map['date'] = date;
    map['senderName'] = senderName;
    map['senderEmail'] = senderEmail;
    map['senderMobile'] = senderMobile;
    map['isShowSuggestion'] = isShowSuggestion;
    map['voteSum'] = voteSum;
    map['replayArray'] = replayArray;
    map['voteMinusEmail'] = voteMinusEmail;
    map['votePlusEmail'] = votePlusEmail;
    return map;
  }
}
