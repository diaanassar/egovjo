import 'dart:io';

import 'package:intl/intl.dart';
import 'package:complaints_app/models/suggestion.dart';
import 'package:complaints_app/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:complaints_app/firebase/fb_firestore.dart';
import 'package:complaints_app/models/Report.dart';
import 'package:complaints_app/preferences/app_preferences.dart';
import 'package:complaints_app/utils/helpers.dart';
import 'package:complaints_app/utils/size_config.dart';
import 'package:complaints_app/widgets/app_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FillFormPeopleScreen extends StatefulWidget {
  @override
  _FillFormPeopleScreenState createState() => _FillFormPeopleScreenState();
}

class _FillFormPeopleScreenState extends State<FillFormPeopleScreen>
    with Helpers {
  late TextEditingController noteTextController;

  String urlImage1 = '';
  XFile? _pickedFile1;
  ImagePicker imagePicker = ImagePicker();
  int countImage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noteTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    noteTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().designHeight(7).designWidth(4.15).init(context);
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            performSignIn();
          },
          label: Text(
            'Add Request',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(
            Icons.save,
            color: Colors.white,
          ),
          backgroundColor: Colors.green,
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'New Request',
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
              color: Colors.green,
              thickness: 4,
            ),
            Center(
              child: Text(
                'Add a Special Request',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig().scaleTextFont(24),
                    color: Colors.black),
              ),
            ),
            Divider(
              color: Colors.green,
              thickness: 4,
            ),
            SizedBox(
              height: SizeConfig().scaleHeight(10),
            ),
            AppTextField(
              controller: noteTextController,
              hint: 'Write Your Request Here',
              maxLines: 3,
              maxLength: 100000,
            ),
            SizedBox(
              height: SizeConfig().scaleHeight(10),
            ),
            SizedBox(
              height: SizeConfig().scaleHeight(10),
            ),
            Container(
              height: SizeConfig().scaleHeight(50),
              child: ElevatedButton(
                onPressed: () => pickImage(),
                child: Text(
                  '${(countImage != 1) ? 'Add Photo From Camera (Optional)' : 'The photo has been added'}',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    primary: (countImage != 1) ? Colors.green : Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    if (_pickedFile1 == null) {
      _pickedFile1 = await imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 25);
      if (_pickedFile1 != null) {
        countImage += 1;
        setState(() {});
      }
    }
  }

  Future<void> performSignIn() async {
    if (noteTextController.text.isEmpty) {
      showSnackBar(
          context: context,
          content: 'You must write your request',
          error: true);
    } else {
      print('start');
      loadingDialog(true);
      uploadReport();
    }
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

  Future<String> postFile({required File imageFile}) async {
    print('postFile');
    String fileName = '${DateTime.now().toString().replaceAll(' ', '_')}';
    Reference reference =
        FirebaseStorage.instance.ref().child('suggestion').child(fileName);
    print(imageFile);
    TaskSnapshot storageTaskSnapshot = await reference.putFile(imageFile);
    print(storageTaskSnapshot.ref.getDownloadURL());
    String dowUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return dowUrl;
  }

  Future<bool> uploadImage() async {
    print('uploadImage');
    if (_pickedFile1 != null) {
      urlImage1 = await postFile(imageFile: File(_pickedFile1!.path));
    }
    return true;
  }

  Future<void> uploadReport() async {
    bool uImage = await uploadImage();
    if (uImage) {
      print('end upload image');
      bool uploadReport = await FbFireStoreController()
          .createSuggestion(context: context, suggestions: suggestion);
      if (uploadReport) {
        print('end upload all Form');
        loadingDialog(false);
        Navigator.pop(context);
        showSnackBar(context: context, content: 'Done');
      } else {
        loadingDialog(false);
        showSnackBar(
            context: context,
            content:
                'An error occurred while uploading the report, send it again',
            error: true);
      }
    }
  }

  Suggestion get suggestion {
    Suggestion suggestion = Suggestion();
    suggestion.suggestionText = noteTextController.text;
    suggestion.urlImage1 = urlImage1;
    suggestion.date = DateFormat('EEEE, d MMM, yyyy').format(DateTime.now());
    suggestion.senderName = AppPreferences().getUserData.name;
    suggestion.senderEmail = AppPreferences().getUserData.email;
    suggestion.senderMobile = AppPreferences().getUserData.mobile;
    suggestion.isShowSuggestion = true;
    suggestion.voteSum = '0';
    suggestion.replayArray = [];
    suggestion.votePlusEmail = [];
    suggestion.voteMinusEmail = [];
    return suggestion;
  }
}
