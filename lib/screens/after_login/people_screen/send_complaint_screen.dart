import 'dart:io';
import 'package:complaints_app/preferences/app_preferences.dart';
import 'package:intl/intl.dart';
import 'package:complaints_app/firebase/fb_firestore.dart';
import 'package:complaints_app/models/Report.dart';
import 'package:complaints_app/utils/helpers.dart';
import 'package:complaints_app/utils/size_config.dart';
import 'package:complaints_app/widgets/app_text_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'all_complaint_screen.dart';
import 'drawer_user_widget.dart';

class SendComplaintScreen extends StatefulWidget {
  const SendComplaintScreen({Key? key}) : super(key: key);

  @override
  _SendComplaintScreenState createState() => _SendComplaintScreenState();
}

class _SendComplaintScreenState extends State<SendComplaintScreen>
    with Helpers {
  late TextEditingController problemTextController;
  late TextEditingController addressTextController;

  String urlImage1 = '';
  String urlImage2 = '';
  String urlImage3 = '';
  String urlImage4 = '';
  String urlImage5 = '';
  String urlImage6 = '';
  String urlImage7 = '';
  String urlImage8 = '';
  String urlImage9 = '';
  String urlImage10 = '';
  XFile? _pickedFile1;
  XFile? _pickedFile2;
  XFile? _pickedFile3;
  XFile? _pickedFile4;
  XFile? _pickedFile5;
  XFile? _pickedFile6;
  XFile? _pickedFile7;
  XFile? _pickedFile8;
  XFile? _pickedFile9;
  XFile? _pickedFile10;
  ImagePicker imagePicker = ImagePicker();
  int countImage = 0;
  var selectMinistryName ;
  List<String> ministryList = AppPreferences().getArrayMinistry;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    problemTextController = TextEditingController();
    addressTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    problemTextController.dispose();
    addressTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().designHeight(7).designWidth(4.15).init(context);
    return Scaffold(
      drawer: DrawerPeopleWidget(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Submit an Order',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => pickImage(),
            icon: Stack(
              children: [
                Center(
                  child: Icon(Icons.add_a_photo_outlined),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: SizeConfig().scaleHeight(18),
                    width: SizeConfig().scaleWidth(18),
                    decoration: BoxDecoration(
                        color: (countImage < 10)
                            ? Color(0xffc5a657)
                            : Colors.greenAccent,
                        borderRadius: BorderRadius.circular(50)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Center(
                        child: Text(
                          '$countImage',
                          style: TextStyle(
                              color: (countImage < 10)
                                  ? Colors.black
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig().scaleTextFont(18)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: Colors.green,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            performSignIn();
          },
          label: Text('Submit' , style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.add_task , color: Colors.white,),
          backgroundColor: Colors.green,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          children: [
            Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.black, width: SizeConfig().scaleWidth(1)),
                  borderRadius: BorderRadius.circular(
                    SizeConfig().scaleWidth(10),
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig().scaleWidth(10),
                vertical: SizeConfig().scaleWidth(15),
              ),
              child: DropdownButton(
                underline: SizedBox(),
                autofocus: true,
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.black,
                ),
                iconSize: SizeConfig().scaleWidth(28),
                isExpanded: true,
                hint: Text('Choose Order'),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: SizeConfig().scaleTextFont(20),
                  fontWeight: FontWeight.w500,
                ),
                elevation: 3,
                dropdownColor: Colors.white,
                value: selectMinistryName,
                onChanged: (newValue) {
                  setState(() {
                    selectMinistryName = newValue.toString();
                  });
                },
                items: ministryList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: SizeConfig().scaleHeight(10),
            ),
            AppTextField(
              controller: addressTextController,
              hint: 'City & Neighborhood (e.g. Amman - Khalda)',
              maxLines: 1,
              maxLength: 1000,
            ),
            SizedBox(
              height: SizeConfig().scaleHeight(10),
            ),
            AppTextField(
              controller: problemTextController,
              hint: 'Give details of your request here',
              maxLines: 3,
              maxLength: 100000,
            ),

            SizedBox(
              height: SizeConfig().scaleHeight(10),
            ),
            Text('The number of photos added so far is : $countImage'),
            Text(
              'Minimum of one photo and maximum of 10 photos',
              style: TextStyle(
                  color: Colors.red, fontSize: SizeConfig().scaleTextFont(15)),
            ),
            SizedBox(
              height: SizeConfig().scaleHeight(20),
            ),
            Container(
              height: SizeConfig().scaleHeight(50),
              child: ElevatedButton(
                onPressed: () => pickImage(),
                child: Text(
                    '${(countImage != 10) ? 'Click to add a photo from the camera': 'You cannot add more than 10 photos'}' , style: TextStyle(color: Colors.white),) ,
                style: ElevatedButton.styleFrom(
                    primary:
                        (countImage != 10) ? Colors.green : Colors.black),
              ),
            ),
            SizedBox(
              height: SizeConfig().scaleHeight(10),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    if (_pickedFile1 == null) {
      print('_pickedFile1');
      _pickedFile1 = await imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 25);
      if (_pickedFile1 != null) {
        countImage += 1;
        setState(() {});
      }
    } else if (_pickedFile2 == null) {
      print('_pickedFile2');
      _pickedFile2 = await imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 25);
      if (_pickedFile2 != null) {
        countImage += 1;
        setState(() {});
      }
    } else if (_pickedFile3 == null) {
      print('_pickedFile3');
      _pickedFile3 = await imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 25);
      if (_pickedFile3 != null) {
        countImage += 1;
        setState(() {});
      }
    } else if (_pickedFile4 == null) {
      print('_pickedFile4');
      _pickedFile4 = await imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 25);
      if (_pickedFile4 != null) {
        countImage += 1;
        setState(() {});
      }
    } else if (_pickedFile5 == null) {
      print('_pickedFile5');
      _pickedFile5 = await imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 25);
      if (_pickedFile5 != null) {
        countImage += 1;
        setState(() {});
      }
    } else if (_pickedFile6 == null) {
      print('_pickedFile6');
      _pickedFile6 = await imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 25);
      if (_pickedFile6 != null) {
        countImage += 1;
        setState(() {});
      }
    } else if (_pickedFile7 == null) {
      print('_pickedFile7');
      _pickedFile7 = await imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 25);
      if (_pickedFile7 != null) {
        countImage += 1;
        setState(() {});
      }
    } else if (_pickedFile8 == null) {
      print('_pickedFile8');
      _pickedFile8 = await imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 25);
      if (_pickedFile8 != null) {
        countImage += 1;
        setState(() {});
      }
    } else if (_pickedFile9 == null) {
      print('_pickedFile9');
      _pickedFile9 = await imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 25);
      if (_pickedFile9 != null) {
        countImage += 1;
        setState(() {});
      }
    } else if (_pickedFile10 == null) {
      print('_pickedFile10');
      _pickedFile10 = await imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 25);
      if (_pickedFile10 != null) {
        countImage += 1;
        setState(() {});
      }
    } else {
      showSnackBar(
          context: context,
          content: 'You have reached the maximum number of images available',
          error: true);
    }
  }

  Future<void> performSignIn() async {
    print('dsa');
    if (_pickedFile1 == null) {
      showSnackBar(
          context: context,
          content: 'A minimum of one image must be included.',
          error: true);
    } else if (selectMinistryName.isEmpty) {
      showSnackBar(
          context: context,
          content: 'select Ministry before Send',
          error: true);
    } else if (addressTextController.text.isEmpty) {
      showSnackBar(
          context: context,
          content: 'The address must be written',
          error: true);
    }else if (problemTextController.text.isEmpty) {
      showSnackBar(
          context: context,
          content: 'The problem must be written',
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
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    print(imageFile);
    TaskSnapshot storageTaskSnapshot = await reference.putFile(imageFile);
    print(storageTaskSnapshot.ref.getDownloadURL());
    String dowUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return dowUrl;
  }

  Future<bool> uploadImage() async {
    print('uploadImage');
    for (int i = 1; i < 11; i++) {
      if (i == 1) {
        if (_pickedFile1 != null) {
          urlImage1 = await postFile(imageFile: File(_pickedFile1!.path));
        } else {
          break;
        }
      } else if (i == 2) {
        if (_pickedFile2 != null) {
          urlImage2 = await postFile(imageFile: File(_pickedFile2!.path));
        } else {
          break;
        }
      } else if (i == 3) {
        if (_pickedFile3 != null) {
          urlImage3 = await postFile(imageFile: File(_pickedFile3!.path));
        } else {
          break;
        }
      } else if (i == 4) {
        if (_pickedFile4 != null) {
          urlImage4 = await postFile(imageFile: File(_pickedFile4!.path));
        } else {
          break;
        }
      } else if (i == 5) {
        if (_pickedFile5 != null) {
          urlImage5 = await postFile(imageFile: File(_pickedFile5!.path));
        } else {
          break;
        }
      } else if (i == 6) {
        if (_pickedFile6 != null) {
          urlImage6 = await postFile(imageFile: File(_pickedFile6!.path));
        } else {
          break;
        }
      } else if (i == 7) {
        if (_pickedFile7 != null) {
          urlImage7 = await postFile(imageFile: File(_pickedFile7!.path));
        } else {
          break;
        }
      } else if (i == 8) {
        if (_pickedFile8 != null) {
          urlImage8 = await postFile(imageFile: File(_pickedFile8!.path));
        } else {
          break;
        }
      } else if (i == 9) {
        if (_pickedFile9 != null) {
          urlImage9 = await postFile(imageFile: File(_pickedFile9!.path));
        } else {
          break;
        }
      } else if (i == 10) {
        if (_pickedFile10 != null) {
          urlImage10 = await postFile(imageFile: File(_pickedFile10!.path));
        } else {
          break;
        }
      }
    }
    return true;
  }

  Future<void> uploadReport() async {
    bool uImage = await uploadImage();
    if (uImage) {
      print('end upload image');
      bool uploadReport = await FbFireStoreController()
          .createReport(context: context, reports: reports);
      if (uploadReport) {
        print('end upload all Form');
        loadingDialog(false);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => AllComplaintScreen()), (Route<dynamic> route) => false);
        showSnackBar(context: context, content: 'Report sent successfully');
      } else {
        loadingDialog(false);
        showSnackBar(
            context: context,
            content: 'An error occurred while uploading the report, send it again',
            error: true);
      }
    }
  }

  Report get reports {
    Report reports = Report();
    reports.senderName = AppPreferences().getUserData.name;
    reports.senderEmail = AppPreferences().getUserData.email;
    reports.senderMobile = AppPreferences().getUserData.mobile;
    reports.problemText = problemTextController.text;
    reports.address = addressTextController.text;
    reports.ministryName = selectMinistryName;
    reports.ministryReplay = '';
    reports.adminReplay = '';
    reports.isDoneFromAdmin = false;
    reports.isDoneFromMinistry = false;
    reports.isBackToMinistry = false;
    reports.countImageUpload = countImage.toString();
    reports.urlImage1 = urlImage1;
    reports.urlImage2 = urlImage2;
    reports.urlImage3 = urlImage3;
    reports.urlImage4 = urlImage4;
    reports.urlImage5 = urlImage5;
    reports.urlImage6 = urlImage6;
    reports.urlImage7 = urlImage7;
    reports.urlImage8 = urlImage8;
    reports.urlImage9 = urlImage9;
    reports.urlImage10 = urlImage10;
    reports.date = DateTime.now().day.toString() + "/" + DateTime.now().month.toString() + "/" + DateTime.now().year.toString();
    reports.day = DateFormat('EEEE').format(DateTime.now());
    reports.timeReport = DateTime.now();
    return reports;
  }
}
