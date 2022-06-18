import 'dart:io';

import 'package:complaints_app/firebase/fb_firestore.dart';
import 'package:complaints_app/models/Report.dart';
import 'package:complaints_app/preferences/app_preferences.dart';
import 'package:complaints_app/utils/helpers.dart';
import 'package:complaints_app/utils/size_config.dart';
import 'package:complaints_app/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class ReadComplaintScreen extends StatefulWidget {
  Report report;

  ReadComplaintScreen({required this.report});

  @override
  _ReadComplaintScreenState createState() => _ReadComplaintScreenState();
}

class _ReadComplaintScreenState extends State<ReadComplaintScreen>
    with Helpers {
  late TextEditingController _replayTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _replayTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _replayTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().designHeight(7).designWidth(4.15).init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Order Reports',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          children: [
            Divider(
              color: Color(0xffc5a657),
              thickness: SizeConfig().scaleHeight(4),
            ),
            Center(
              child: Text(
                'Information Sender',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig().scaleTextFont(24),
                    color: Color(0xff1a6738)),
              ),
            ),
            Divider(
              color: Color(0xffc5a657),
              thickness: SizeConfig().scaleHeight(4),
            ),
            Row(
              children: [
                Text(
                  'Sender Name : ',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: SizeConfig().scaleTextFont(24)),
                ),
                Text(
                  '${widget.report.senderName}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig().scaleTextFont(24)),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig().scaleHeight(10),
            ),
            Row(
              children: [
                Text(
                  'Sender Email : ',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: SizeConfig().scaleTextFont(24)),
                ),
                Text(
                  '${widget.report.senderEmail}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig().scaleTextFont(24)),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig().scaleHeight(10),
            ),
            Row(
              children: [
                Text(
                  'Sender Phone : ',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: SizeConfig().scaleTextFont(24)),
                ),
                Text(
                  '${widget.report.senderMobile}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig().scaleTextFont(24)),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig().scaleHeight(10),
            ),
            Row(
              children: [
                Text(
                  'Sender Address : ',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: SizeConfig().scaleTextFont(24)),
                ),
                Flexible(
                  child: Text(
                    '${widget.report.address}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig().scaleTextFont(24)),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig().scaleHeight(10),
            ),
            Divider(
              color: Color(0xffc5a657),
              thickness: SizeConfig().scaleHeight(4),
            ),
            Center(
              child: Text(
                'Order Details',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig().scaleTextFont(24),
                    color: Color(0xff1a6738)),
              ),
            ),
            Divider(
              color: Color(0xffc5a657),
              thickness: SizeConfig().scaleHeight(4),
            ),
            Row(
              children: [
                Text(
                  'Order Category : ',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: SizeConfig().scaleTextFont(24)),
                ),
                Text(
                  '${widget.report.ministryName}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig().scaleTextFont(24)),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig().scaleHeight(10),
            ),
            Text(
              'Order Body : ',
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: SizeConfig().scaleTextFont(24)),
            ),
            SizedBox(
              height: SizeConfig().scaleHeight(10),
            ),
            Text(
              '${widget.report.problemText}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig().scaleTextFont(24)),
            ),
            SizedBox(
              height: SizeConfig().scaleHeight(10),
            ),
            Divider(
              color: Color(0xffc5a657),
              thickness: SizeConfig().scaleHeight(4),
            ),
            Center(
              child: Text(
                'Attached images (${widget.report.countImageUpload})',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig().scaleTextFont(24),
                    color: Color(0xff1a6738)),
              ),
            ),
            Divider(
              color: Color(0xffc5a657),
              thickness: SizeConfig().scaleHeight(4),
            ),
            SizedBox(
              height: 10,
            ),
            chackAllImages(),
            chackReplay(),
            SizedBox(
              height: SizeConfig().scaleHeight(10),
            ),
          ],
        ),
      ),
    );
  }

  Widget chackReplay() {
    if (widget.report.isDoneFromAdmin) {
      return Column(
        children: [
          Divider(
            color: Color(0xffc5a657),
            thickness: SizeConfig().scaleHeight(4),
          ),
          Center(
            child: Text(
              'reply',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig().scaleTextFont(24),
                  color: Color(0xff1a6738)),
            ),
          ),
          Divider(
            color: Color(0xffc5a657),
            thickness: SizeConfig().scaleHeight(4),
          ),
          Container(
            width: double.infinity,
            child: Text(
              'Order Replay : ',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: SizeConfig().scaleTextFont(24)),
            ),
          ),
          Container(
            width: double.infinity,
            child: Text(
              '${(widget.report.ministryReplay.isEmpty) ? 'Done' : '${widget.report.ministryReplay}'}',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig().scaleTextFont(24)),
            ),
          ),
        ],
      );
    } else if (AppPreferences().getUserData.levelUser != '3') {
      if (AppPreferences().getUserData.levelUser == '1' &&
          widget.report.isDoneFromMinistry) {
        return Column(
          children: [
            Divider(
              color: Color(0xffc5a657),
              thickness: SizeConfig().scaleHeight(4),
            ),
            Center(
              child: Text(
                'reply',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig().scaleTextFont(24),
                    color: Color(0xff1a6738)),
              ),
            ),
            Divider(
              color: Color(0xffc5a657),
              thickness: SizeConfig().scaleHeight(4),
            ),
            Container(
              width: double.infinity,
              child: Text(
                'Order Replay : ',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: SizeConfig().scaleTextFont(24)),
              ),
            ),
            Container(
              width: double.infinity,
              child: Text(
                '${(widget.report.ministryReplay.isEmpty) ? 'No reply has been added' : '${widget.report.ministryReplay}'}',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig().scaleTextFont(24)),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Map<String, dynamic>? map = {
                        "isDoneFromAdmin": true,
                      };
                      changeState(path: widget.report.path, data: map);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Done',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.add_task,
                          color: Colors.black,
                        )
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      elevation: 0,
                      side: BorderSide(color: Colors.black, width: 1),
                      minimumSize: Size(
                        0,
                        SizeConfig().scaleHeight(40),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      rejectAdminToMinistry();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Reject',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.cancel,
                          color: Colors.white,
                        )
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      elevation: 0,
                      side: BorderSide(color: Colors.black, width: 1),
                      minimumSize: Size(
                        0,
                        SizeConfig().scaleHeight(40),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      } else if (AppPreferences().getUserData.levelUser == '2') {
        if (widget.report.isBackToMinistry) {
          return Column(
            children: [
              Divider(
                color: Color(0xffc5a657),
                thickness: SizeConfig().scaleHeight(4),
              ),
              Center(
                child: Text(
                  'Reference',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig().scaleTextFont(24),
                      color: Color(0xff1a6738)),
                ),
              ),
              Divider(
                color: Color(0xffc5a657),
                thickness: SizeConfig().scaleHeight(4),
              ),
              Container(
                width: double.infinity,
                child: Text(
                  'Reason for return : ',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: SizeConfig().scaleTextFont(24)),
                ),
              ),
              Container(
                width: double.infinity,
                child: Text(
                  '${(widget.report.adminReplay.isEmpty) ? 'The reason is not mentioned' : '${widget.report.adminReplay}'}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig().scaleTextFont(24)),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        DoneFromMinistry();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Problem solved again',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.add_task,
                            color: Colors.black,
                          )
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        elevation: 0,
                        side: BorderSide(color: Colors.black, width: 1),
                        minimumSize: Size(
                          0,
                          SizeConfig().scaleHeight(40),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        } else if (widget.report.isDoneFromMinistry) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Waiting for admin review',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.access_time_rounded,
                            color: Colors.black,
                          )
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey.shade400,
                        elevation: 0,
                        side: BorderSide(color: Colors.black, width: 1),
                        minimumSize: Size(
                          0,
                          SizeConfig().scaleHeight(40),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        } else {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        DoneFromMinistry();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'The problem has been resolved',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.add_task,
                            color: Colors.black,
                          )
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        elevation: 0,
                        side: BorderSide(color: Colors.black, width: 1),
                        minimumSize: Size(
                          0,
                          SizeConfig().scaleHeight(40),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        }
      } else {
        return Text('');
      }
    } else {
      return SizedBox();
    }
  }

  Widget chackAllImages() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => showBigImageDialog(url: widget.report.urlImage1),
            child: Container(
              height: SizeConfig().scaleHeight(100),
              width: SizeConfig().scaleWidth(120),
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 2,
                child: FadeInImage(
                  image: NetworkImage(widget.report.urlImage1),
                  placeholder: AssetImage("images/logo.png"),
                  fit: BoxFit.fill,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Stack(
                      children: [
                        Center(
                          child:
                              Image.asset('images/logo.png', fit: BoxFit.fill),
                        ),
                        Center(child: CircularProgressIndicator()),
                      ],
                    );
                  },
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          if (!widget.report.urlImage2.isEmpty)
            GestureDetector(
              onTap: () => showBigImageDialog(url: widget.report.urlImage2),
              child: Container(
                height: SizeConfig().scaleHeight(100),
                width: SizeConfig().scaleWidth(120),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  child: FadeInImage(
                    image: NetworkImage(widget.report.urlImage2),
                    placeholder: AssetImage("images/logo.png"),
                    fit: BoxFit.fill,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Stack(
                        children: [
                          Center(
                            child: Image.asset('images/logo.png',
                                fit: BoxFit.fill),
                          ),
                          Center(child: CircularProgressIndicator()),
                        ],
                      );
                    },
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          if (!widget.report.urlImage3.isEmpty)
            GestureDetector(
              onTap: () => showBigImageDialog(url: widget.report.urlImage3),
              child: Container(
                height: SizeConfig().scaleHeight(100),
                width: SizeConfig().scaleWidth(120),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  child: FadeInImage(
                    image: NetworkImage(widget.report.urlImage3),
                    placeholder: AssetImage("images/logo.png"),
                    fit: BoxFit.fill,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Stack(
                        children: [
                          Center(
                            child: Image.asset('images/logo.png',
                                fit: BoxFit.fill),
                          ),
                          Center(child: CircularProgressIndicator()),
                        ],
                      );
                    },
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          if (!widget.report.urlImage4.isEmpty)
            GestureDetector(
              onTap: () => showBigImageDialog(url: widget.report.urlImage4),
              child: Container(
                height: SizeConfig().scaleHeight(100),
                width: SizeConfig().scaleWidth(120),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  child: FadeInImage(
                    image: NetworkImage(widget.report.urlImage4),
                    placeholder: AssetImage("images/logo.png"),
                    fit: BoxFit.fill,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Stack(
                        children: [
                          Center(
                            child: Image.asset('images/logo.png',
                                fit: BoxFit.fill),
                          ),
                          Center(child: CircularProgressIndicator()),
                        ],
                      );
                    },
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          if (!widget.report.urlImage5.isEmpty)
            GestureDetector(
              onTap: () => showBigImageDialog(url: widget.report.urlImage5),
              child: Container(
                height: SizeConfig().scaleHeight(100),
                width: SizeConfig().scaleWidth(120),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  child: FadeInImage(
                    image: NetworkImage(widget.report.urlImage5),
                    placeholder: AssetImage("images/logo.png"),
                    fit: BoxFit.fill,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Stack(
                        children: [
                          Center(
                            child: Image.asset('images/logo.png',
                                fit: BoxFit.fill),
                          ),
                          Center(child: CircularProgressIndicator()),
                        ],
                      );
                    },
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          if (!widget.report.urlImage6.isEmpty)
            GestureDetector(
              onTap: () => showBigImageDialog(url: widget.report.urlImage6),
              child: Container(
                height: SizeConfig().scaleHeight(100),
                width: SizeConfig().scaleWidth(120),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  child: FadeInImage(
                    image: NetworkImage(widget.report.urlImage6),
                    placeholder: AssetImage("images/logo.png"),
                    fit: BoxFit.fill,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Stack(
                        children: [
                          Center(
                            child: Image.asset('images/logo.png',
                                fit: BoxFit.fill),
                          ),
                          Center(child: CircularProgressIndicator()),
                        ],
                      );
                    },
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          if (!widget.report.urlImage7.isEmpty)
            GestureDetector(
              onTap: () => showBigImageDialog(url: widget.report.urlImage7),
              child: Container(
                height: SizeConfig().scaleHeight(100),
                width: SizeConfig().scaleWidth(120),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  child: FadeInImage(
                    image: NetworkImage(widget.report.urlImage7),
                    placeholder: AssetImage("images/logo.png"),
                    fit: BoxFit.fill,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Stack(
                        children: [
                          Center(
                            child: Image.asset('images/logo.png',
                                fit: BoxFit.fill),
                          ),
                          Center(child: CircularProgressIndicator()),
                        ],
                      );
                    },
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          if (!widget.report.urlImage8.isEmpty)
            GestureDetector(
              onTap: () => showBigImageDialog(url: widget.report.urlImage8),
              child: Container(
                height: SizeConfig().scaleHeight(100),
                width: SizeConfig().scaleWidth(120),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  child: FadeInImage(
                    image: NetworkImage(widget.report.urlImage8),
                    placeholder: AssetImage("images/logo.png"),
                    fit: BoxFit.fill,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Stack(
                        children: [
                          Center(
                            child: Image.asset('images/logo.png',
                                fit: BoxFit.fill),
                          ),
                          Center(child: CircularProgressIndicator()),
                        ],
                      );
                    },
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          if (!widget.report.urlImage9.isEmpty)
            GestureDetector(
              onTap: () => showBigImageDialog(url: widget.report.urlImage9),
              child: Container(
                height: SizeConfig().scaleHeight(100),
                width: SizeConfig().scaleWidth(120),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  child: FadeInImage(
                    image: NetworkImage(widget.report.urlImage9),
                    placeholder: AssetImage("images/logo.png"),
                    fit: BoxFit.fill,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Stack(
                        children: [
                          Center(
                            child: Image.asset('images/logo.png',
                                fit: BoxFit.fill),
                          ),
                          Center(child: CircularProgressIndicator()),
                        ],
                      );
                    },
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          if (!widget.report.urlImage10.isEmpty)
            GestureDetector(
              onTap: () => showBigImageDialog(url: widget.report.urlImage10),
              child: Container(
                height: SizeConfig().scaleHeight(100),
                width: SizeConfig().scaleWidth(120),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  child: FadeInImage(
                    image: NetworkImage(widget.report.urlImage10),
                    placeholder: AssetImage("images/logo.png"),
                    fit: BoxFit.fill,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Stack(
                        children: [
                          Center(
                            child: Image.asset('images/logo.png',
                                fit: BoxFit.fill),
                          ),
                          Center(child: CircularProgressIndicator()),
                        ],
                      );
                    },
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void loadingDialog(bool run) {
    // loadingDialog(context ,false);
    if (run)
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
    else {
      Navigator.pop(context);
    }
  }

  void changeState(
      {required String path, required Map<String, dynamic>? data}) async {
    loadingDialog(true);
    bool state = await FbFireStoreController()
        .updateState(uid: path, collectionName: 'Reports', data: data);
    if (state) {
      loadingDialog(false);
      showSnackBar(context: context, content: 'The conversion succeeded');
      Navigator.pop(context);
    } else {
      loadingDialog(false);
      showSnackBar(context: context, content: 'Transfer Failed', error: true);
    }
  }

  void showBigImageDialog({required String url}) {
    // loadingDialog(context ,false);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            clipBehavior: Clip.antiAlias,
            contentPadding: EdgeInsets.zero,
            content: Image.network(
              url,
              fit: BoxFit.fill,
            ),
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConfig().scaleWidth(20)),
              side: BorderSide(
                  color: Colors.green, width: SizeConfig().scaleWidth(2)),
            ),
          );
        });
  }

  void rejectAdminToMinistry() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Write the reason for rejection',
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: AppTextField(
            hint: '',
            controller: _replayTextController,
            maxLength: 200000,
            maxLines: 2,
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
              onPressed: () {
                Navigator.pop(context);
                Map<String, dynamic>? map = {
                  "isDoneFromMinistry": false,
                  "isBackToMinistry": true,
                  "ministryReplay": '',
                  "adminReplay": _replayTextController.text
                };
                changeState(path: widget.report.path, data: map);
              },
              child: Text(
                'Reject',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'back',
                  style: TextStyle(color: Colors.black),
                )),
          ],
        );
      },
    );
  }

  void DoneFromMinistry() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Indicate the details of the solution to be approved',
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: AppTextField(
            hint: '',
            controller: _replayTextController,
            maxLength: 200000,
            maxLines: 2,
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
              onPressed: () {
                Navigator.pop(context);
                Map<String, dynamic>? map = {
                  "isDoneFromMinistry": true,
                  "isBackToMinistry": false,
                  "ministryReplay": _replayTextController.text
                };
                changeState(path: widget.report.path, data: map);
              },
              child: Text(
                'Send',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'back',
                  style: TextStyle(color: Colors.black),
                )),
          ],
        );
      },
    );
  }
}
