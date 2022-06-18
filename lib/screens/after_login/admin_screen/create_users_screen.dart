import 'dart:io';

import 'package:complaints_app/firebase/fb_auth_controller.dart';
import 'package:complaints_app/firebase/fb_firestore.dart';
import 'package:complaints_app/models/users.dart';
import 'package:complaints_app/preferences/app_preferences.dart';
import 'package:complaints_app/utils/helpers.dart';
import 'package:complaints_app/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class CreateUserScreen extends StatefulWidget {
  final Users? userOld;

  CreateUserScreen({this.userOld});

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> with Helpers {
  late TextEditingController _emailTextController;
  late TextEditingController _fullNameTextController;
  late TextEditingController _numberPhoneTextController;
  late TextEditingController _passwordTextController;
  String levelUser = '2';
  bool isSuspend = false;
  late bool isAdmin;
  String pathOld = '';
  String fcm = '';
  bool addInListMinistry = true;
  bool passwordNotWeak = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fullNameTextController =
        TextEditingController(text: widget.userOld?.name ?? '');
    _emailTextController =
        TextEditingController(text: widget.userOld?.email ?? '');
    _passwordTextController =
        TextEditingController(text: widget.userOld?.password ?? '');
    _numberPhoneTextController =
        TextEditingController(text: widget.userOld?.mobile ?? '');
    isAdmin = (widget.userOld?.levelUser == '1') ? true : false;
    levelUser = widget.userOld?.levelUser ?? '2';
    isSuspend = widget.userOld?.isSuspend ?? false;
    pathOld = widget.userOld?.path ?? '';
    fcm = widget.userOld?.fcm ?? '';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _fullNameTextController.dispose();
    _numberPhoneTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.userOld != null ? 'Edit Account' : 'Create Account',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              AppTextField(
                hint: 'Order Name',
                controller: _fullNameTextController,
                maxLength: 30,
                enabled: widget.userOld != null ? false : true,
              ),
              SizedBox(height: 10),
              AppTextField(
                hint: 'Email',
                controller: _emailTextController,
                maxLength: 30,
                enabled: widget.userOld != null ? false : true,
              ),
              SizedBox(height: 10),
              AppTextField(
                hint: 'Password',
                controller: _passwordTextController,
                obscureText: true,
                enabled: widget.userOld != null ? false : true,
              ),
              SizedBox(height: 10),
              AppTextField(
                hint: 'Mobile Number (06/07xxxxxxxx)',
                controller: _numberPhoneTextController,
                maxLength: 10,
              ),
              SizedBox(height: 10),
              SwitchListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text('Make it Admin Account'),
                value: isAdmin,
                onChanged: (bool value) {
                  if (!isAdmin) {
                    isAdmin = true;
                    levelUser = '1';
                    addInListMinistry = false;
                    print(levelUser);
                  } else {
                    isAdmin = false;
                    levelUser = '2';
                    addInListMinistry = true;
                    print(levelUser);
                  }
                  setState(() {});
                },
              ),
              SizedBox(height: 10),
              SwitchListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text('Add in Orders List'),
                value: addInListMinistry,
                onChanged: (bool value) {
                  if (!addInListMinistry) {
                    addInListMinistry = true;
                    levelUser = '2';
                    isAdmin = false;
                  } else {
                    addInListMinistry = false;
                    levelUser = '1';
                    isAdmin = true;
                  }
                  setState(() {});
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {

                  await performCreateAccount();
                },
                child: Text(
                  widget.userOld != null ? 'Edit Account' : 'Create Account',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> performCreateAccount() async {
    if (checkData() && widget.userOld == null) {
      print('create');
      await createAccount();
    } else if (checkData() && widget.userOld != null) {
      print('update');
      await updateAccount();
    }
  }

  bool checkData() {
    if (_fullNameTextController.text.isEmpty) {
      showSnackBar(context: context, content: 'Name is Empty !!', error: true);
      return false;
    } else if (_passwordTextController.text.isEmpty) {
      showSnackBar(context: context, content: 'Password is Empty !!', error: true);
      return false;
    } else if (!validateStructure(_passwordTextController.text)) {
      showSnackBar(context: context, content: 'Password is weak', error: true);
      return false;
    }else if (_emailTextController.text.isEmpty) {
      showSnackBar(context: context, content: 'Email is Empty !!', error: true);
      return false;
    } else if (_numberPhoneTextController.text.isEmpty) {
      showSnackBar(
          context: context, content: 'number Phone is Empty !!', error: true);
      return false;
    } else if (_numberPhoneTextController.text.length < 5) {
      showSnackBar(
          context: context, content: 'wrong phone number!', error: true);
      return false;
    } else {
      return true;
    }
  }

  Future<void> createAccount() async {
    bool statusAuth =
        await FbAuthController().createAccountFromAdmin(context, users: users);

    if (statusAuth) {
      showSnackBar(context: context, content: 'Account created');
      if (addInListMinistry) {
        List<dynamic> addEmployee = <dynamic>[_fullNameTextController.text];
        bool state = await FbFireStoreController().updateArray(
            nameDoc: 'ministryList', nameArray: 'Ministry', data: addEmployee);
      }
      Navigator.pop(context);
    }
    // if (statusFireStore) Navigator.pop(context);
  }

  Future<void> updateAccount() async {
    bool statusAuth =
        await FbFireStoreController().updateUser(users: users, uid: users.path);

    if (statusAuth) {
      if (addInListMinistry) {
        List<dynamic> addEmployee = <dynamic>[_fullNameTextController.text];
        bool state = await FbFireStoreController().updateArray(
            nameDoc: 'ministryList', nameArray: 'Ministry', data: addEmployee);
      }
      if (users.path == AppPreferences().getUserData.path) {
        print('update Preferences');
        await AppPreferences().saveLogin(users: users, path: users.path);
      }
      Navigator.pop(context);
    }
    // if (statusFireStore) Navigator.pop(context);
  }

  Users get users {
    Users users = Users();
    users.path = pathOld;
    users.name = _fullNameTextController.text;
    users.email = _emailTextController.text;
    users.password = _passwordTextController.text;
    users.mobile = _numberPhoneTextController.text;
    users.fcm = fcm;
    users.levelUser =
        levelUser; // 1 ==> admin , 2 ==> distributor , 3 ==> supermarket
    users.isSuspend = isSuspend;
    return users;
  }




  bool validateStructure(String value) {
    // String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    String pattern = r'^(?=.*?[a-zA-Z])(?=.*?[0-9]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    bool state = regExp.hasMatch(value);
    return state;
  }
}
