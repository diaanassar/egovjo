import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints_app/firebase/fb_firestore.dart';
import 'package:complaints_app/models/suggestion.dart';
import 'package:complaints_app/preferences/app_preferences.dart';
import 'package:complaints_app/screens/after_login/admin_screen/drawer_admin_widget.dart';
import 'package:complaints_app/screens/after_login/ministry_screen/drawer_ministry_widget.dart';
import 'package:complaints_app/screens/after_login/people_screen/drawer_user_widget.dart';
import 'package:complaints_app/utils/size_config.dart';
import 'package:flutter/material.dart';

import 'fill_form_discussions_screen.dart';

class DiscussionsScreen extends StatefulWidget {
  const DiscussionsScreen({Key? key}) : super(key: key);

  @override
  _DiscussionsScreenState createState() => _DiscussionsScreenState();
}

class _DiscussionsScreenState extends State<DiscussionsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getArrayMinistry();
  }

  Widget build(BuildContext context) {
    SizeConfig().designHeight(7).designWidth(4.15).init(context);

    double hight = MediaQuery.of(context).size.height ;
    return Scaffold(
      drawer: (AppPreferences().getUserData.levelUser == '1')
          ? DrawerAdminWidget()
          : (AppPreferences().getUserData.levelUser == '2')
          ? DrawerMinistryWidget()
          : DrawerPeopleWidget(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Special Requests',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        actions: [
          Visibility(
            visible: AppPreferences().getUserData.levelUser == '3',
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FillFormPeopleScreen()));
                },
                icon: Icon(Icons.add)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: StreamBuilder<QuerySnapshot>(
            stream: FbFireStoreController().read(
                nameCollection: 'suggestion',
                orderBy: 'voteSum',
                descending: true),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData &&
                  snapshot.data!.docs.isNotEmpty) {
                List<QueryDocumentSnapshot> data = snapshot.data!.docs;
                List<Suggestion> allDataAvailable = listData(data: data);
                if (allDataAvailable.length == 0) {
                  return Center(
                    child: Column(
                      children: [
                        Icon(Icons.warning,
                            size: SizeConfig().scaleHeight(85),
                            color: Colors.grey.shade500),
                        Text(
                          'There are no discussions',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: SizeConfig().scaleTextFont(21),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: FullWidget(
                        suggestion: allDataAvailable[index],
                      ),
                    );
                  },
                  itemCount: allDataAvailable.length,
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.warning,
                            size: SizeConfig().scaleHeight(85),
                            color: Colors.grey.shade500),
                        Text(
                          'There are no Special Requests posted',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: SizeConfig().scaleTextFont(21),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void getArrayMinistry() async {
    List arrayMinistry = await FbFireStoreController()
        .getArray(uid: 'ministryList', nameArray: 'Ministry');
    var arrayMinistryString = arrayMinistry.cast<String>().toList();
    AppPreferences().saveArrayMinistry(ministryList: arrayMinistryString);
  }

  List<Suggestion> listData({required List<QueryDocumentSnapshot> data}) {
    List<Suggestion> backdata = [];
    for (int i = 0; i < data.length; i++) {
      Suggestion d = Suggestion();
      d.path = data[i].id;
      d.suggestionText = data[i].get('suggestionText');
      d.urlImage1 = data[i].get('urlImage1');
      d.date = data[i].get('date');
      d.senderName = data[i].get('senderName');
      d.senderEmail = data[i].get('senderEmail');
      d.senderMobile = data[i].get('senderMobile');
      d.isShowSuggestion = data[i].get('isShowSuggestion');
      d.voteSum = data[i].get('voteSum');
      d.replayArray = data[i].get('replayArray');
      d.voteMinusEmail = data[i].get('voteMinusEmail');
      d.votePlusEmail = data[i].get('votePlusEmail');

      backdata.add(d);
    }
    return backdata;
  }
}

class FullWidget extends StatefulWidget {
  Suggestion suggestion;

  FullWidget({required this.suggestion});

  @override
  _FullWidgetState createState() => _FullWidgetState();
}

class _FullWidgetState extends State<FullWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: (AppPreferences().getUserData.levelUser != 1 &&
                    AppPreferences().getUserData.email !=
                        widget.suggestion.senderEmail &&
                    !widget.suggestion.votePlusEmail
                        .contains(AppPreferences().getUserData.email)),
                child: IconButton(
                  onPressed: () async {
                    int add = int.parse(widget.suggestion.voteSum) + 1;
                    List<String> list = [AppPreferences().getUserData.email];
                    if (widget.suggestion.voteMinusEmail.contains(
                        AppPreferences().getUserData.email)) {
                      await FbFireStoreController().deleteFromArray2(
                          nameCollection: 'suggestion',
                          nameDoc: widget.suggestion.path,
                          nameArray: 'voteMinusEmail',
                          data: list);
                      await FbFireStoreController().updateState(
                          uid: widget.suggestion.path,
                          collectionName: 'suggestion',
                          data: {'voteSum': add.toString()});
                    } else {
                      await FbFireStoreController().updateArray2(
                          nameCollection: 'suggestion',
                          nameDoc: widget.suggestion.path,
                          nameArray: 'votePlusEmail',
                          data: list);
                      await FbFireStoreController().updateState(
                          uid: widget.suggestion.path,
                          collectionName: 'suggestion',
                          data: {'voteSum': add.toString()});
                    }
                  },
                  icon: Icon(Icons.arrow_circle_up_sharp, color: Colors.green,),
                ),
              ),
              Text(
                '${widget.suggestion.voteSum}',
                style: TextStyle(
                    fontSize: SizeConfig().scaleTextFont(20),
                    fontWeight: FontWeight.bold , color: (int.parse(widget.suggestion.voteSum) > 0) ? Colors.green : (int.parse(widget.suggestion.voteSum) < 0) ? Colors.red :Colors.black ),
              ),
              Visibility(
                visible: (AppPreferences().getUserData.levelUser != '1' &&
                    AppPreferences().getUserData.email !=
                        widget.suggestion.senderEmail &&
                    !widget.suggestion.voteMinusEmail
                        .contains(AppPreferences().getUserData.email)),
                child: IconButton(
                    onPressed: () async {
                      int minus = int.parse(widget.suggestion.voteSum) - 1;
                      List<String> list = [AppPreferences().getUserData.email];
                      if (widget.suggestion.votePlusEmail.contains(
                          AppPreferences().getUserData.email)) {
                        await FbFireStoreController().deleteFromArray2(
                            nameCollection: 'suggestion',
                            nameDoc: widget.suggestion.path,
                            nameArray: 'votePlusEmail',
                            data: list);
                        await FbFireStoreController().updateState(
                            uid: widget.suggestion.path,
                            collectionName: 'suggestion',
                            data: {'voteSum': minus.toString()});
                      } else {
                        await FbFireStoreController().updateArray2(
                            nameCollection: 'suggestion',
                            nameDoc: widget.suggestion.path,
                            nameArray: 'voteMinusEmail',
                            data: list);
                        await FbFireStoreController().updateState(
                            uid: widget.suggestion.path,
                            collectionName: 'suggestion',
                            data: {'voteSum': minus.toString()});

                      }
                      // int sum = int.parse(widget.suggestion.voteSum) - 1;
                      // List<String> list = [AppPreferences().getUserData.email];
                      // await FbFireStoreController().updateArray2(
                      //     nameCollection: 'suggestion',
                      //     nameDoc: widget.suggestion.path,
                      //     nameArray: 'voteEmail',
                      //     data: list);
                      // await FbFireStoreController().updateState(
                      //     uid: widget.suggestion.path,
                      //     collectionName: 'suggestion',
                      //     data: {'voteSum': sum.toString()});
                    },
                    icon: Icon(Icons.arrow_circle_down_sharp), color: Colors.red,),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 8,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  // height: double.infinity ,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(25)),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                margin: EdgeInsets.only(top: 15, left: 15),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.account_circle,
                                  size: 40,
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 15.0, left: 10.0),
                                child: Text(
                                  widget.suggestion.senderName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                  widget.suggestion.date,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible:
                            AppPreferences().getUserData.levelUser != '3',
                            child: Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                    onPressed: () {
                                      ShowInfromation(context: context);
                                    },
                                    icon: Icon(
                                      Icons.assignment_late_outlined,
                                      color: Colors.grey.shade400,
                                      size: 18,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 30, right: 30, bottom: 20),
                        child: Text(
                          widget.suggestion.suggestionText,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Visibility(
                        visible: widget.suggestion.urlImage1.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 5),
                          child: Image.network(widget.suggestion.urlImage1),
                        ),
                      ),
                      Visibility(
                        visible: widget.suggestion.replayArray.length > 0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${widget.suggestion.replayArray
                                    .length} Comments',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          height: 2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showReplay(
                              context: context,
                              replayList: widget.suggestion.replayArray);
                          print('asdasda');
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 7, left: 30, right: 30),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.message,
                                size: 18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Comment',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 7),
                        child: Divider(
                          height: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  void showReplay(
      {required BuildContext context, required List<dynamic> replayList}) {
    TextEditingController textController = TextEditingController();
    showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.5),
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Comments',
              style: TextStyle(fontSize: 16),
            ),
            content: setupAlertDialoadContainer(replayList),
            actions: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: SizeConfig().scaleHeight(30),
                      width: SizeConfig().scaleWidth(30),
                      // margin: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.account_circle,
                        size: SizeConfig().scaleHeight(30),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Container(
                        height: SizeConfig().scaleHeight(30),
                        child: TextFormField(
                          maxLines: 1,
                          controller: textController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 5, left: 5),
                            hintStyle: TextStyle(fontSize: SizeConfig().scaleTextFont(15)),
                            fillColor: Colors.grey.shade300,
                            filled: true,
                            hintText: 'Write a Comment...',
                            counterText: '',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: IconButton(
                        onPressed: () {
                          List<String> data = <String>[
                            'n@me:${AppPreferences().getUserData
                                .name},c0mment:${textController
                                .text},TypeAccount:${AppPreferences()
                                .getUserData.levelUser}'
                          ];

                          FbFireStoreController().updateArray2(
                              nameCollection: 'suggestion',
                              nameDoc: widget.suggestion.path,
                              nameArray: 'replayArray',
                              data: data);

                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.send),
                      ))
                ],
              ),
            ],
            actionsOverflowDirection: VerticalDirection.up,
            actionsOverflowButtonSpacing: 30,
            // actionsPadding: EdgeInsets.only(right: 30),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.green, width: 2),
            ),
            // insetPadding: EdgeInsets.only(left: 40),
          );
        });
  }

  Widget setupAlertDialoadContainer(List replay) {
    print(replay.length);
    return Container(
      height: SizeConfig().scaleHeight(300), // Change as per your requirement
      width: SizeConfig().scaleWidth(300), // Change as per your requirement
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: replay.length,
          itemBuilder: (context, index) {
            String name = replay[index].toString().substring(
                replay[index].toString().indexOf('n@me:') + 5,
                replay[index].toString().indexOf(',c0mment:'));
            String comment = replay[index].toString().substring(
                replay[index].toString().indexOf('c0mment:') + 8,
                replay[index].toString().indexOf(',TypeAccount:'));
            String type = replay[index].toString().substring(
                replay[index].toString().indexOf(',TypeAccount:') + 13);
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: SizeConfig().scaleHeight(30),
                      width: SizeConfig().scaleWidth(30),
                      margin: EdgeInsets.only(top: SizeConfig().scaleHeight(15), left: SizeConfig().scaleWidth(15)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.account_circle,
                        size: SizeConfig().scaleHeight(30),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0, left: 10.0),
                          child: Row(
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: SizeConfig().scaleTextFont(16)),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Visibility(
                                  visible: type == '2',
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.blue,
                                    size: SizeConfig().scaleHeight(13),
                                  ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            width: SizeConfig().scaleWidth(210),
                            child: Text(
                              '$comment',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: SizeConfig().scaleTextFont(19)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Divider(
                    height: SizeConfig().scaleHeight(2),
                  ),
                )
              ],
            );
          }),
    );
  }

  void ShowInfromation({required BuildContext context}) {
    showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.5),
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text(
              '${widget.suggestion.senderName}',
              style: TextStyle(fontSize: 16),
            ),
            content: Text(
                'email : ${widget.suggestion.senderEmail} \nmobile : ${widget
                    .suggestion.senderMobile}'),

            actionsOverflowDirection: VerticalDirection.up,
            actionsOverflowButtonSpacing: 30,
            // actionsPadding: EdgeInsets.only(right: 30),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.green, width: 2),
            ),
            // insetPadding: EdgeInsets.only(left: 40),
          );
        });
  }
}
