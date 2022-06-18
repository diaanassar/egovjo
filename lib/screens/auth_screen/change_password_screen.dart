
import 'package:complaints_app/firebase/fb_auth_controller.dart';
import 'package:complaints_app/firebase/fb_firestore.dart';
import 'package:complaints_app/preferences/app_preferences.dart';
import 'package:complaints_app/utils/helpers.dart';
import 'package:complaints_app/utils/size_config.dart';
import 'package:complaints_app/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with Helpers {
  late TextEditingController _oldpasswordTextController;
  late TextEditingController _passwordTextController;
  late TextEditingController _passwordConfirmTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _oldpasswordTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _passwordConfirmTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _oldpasswordTextController.dispose();
    _passwordTextController.dispose();
    _passwordConfirmTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().designHeight(7).designWidth(4.15).init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
        backgroundColor: Colors.green,
        title: Text(
          'Change Password',
          style: TextStyle(
              color: Colors.white, fontSize: SizeConfig().scaleTextFont(20)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kindly, fill in the following fields:',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig().scaleTextFont(25),
                ),
              ),
              SizedBox(height: SizeConfig().scaleHeight(22)),
              AppTextField(
                hint: 'Your Old Password',
                keyboardType: TextInputType.text,
                controller: _oldpasswordTextController,
                obscureText: true,
                maxLength: 30,
              ),
              SizedBox(height: SizeConfig().scaleHeight(10)),
              AppTextField(
                hint: 'Your New Password',
                controller: _passwordTextController,
                keyboardType: TextInputType.text,
                obscureText: true,
              ),
              SizedBox(height: SizeConfig().scaleHeight(10)),
              AppTextField(
                hint: 'Confirm Your New Password',
                controller: _passwordConfirmTextController,
                keyboardType: TextInputType.text,
                obscureText: true,
              ),
              SizedBox(height: SizeConfig().scaleHeight(20)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  await performSignIn();
                },
                child: Text(
                  'Change Password',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig().scaleTextFont(20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> performSignIn() async {
    if (checkData()) {
      await changePassword();
    }
  }

  bool checkData() {
    if (_oldpasswordTextController.text.isEmpty ||
        _passwordTextController.text.isEmpty ||
        _passwordConfirmTextController.text.isEmpty) {
      showSnackBar(context: context, content: 'Enter All fields', error: true);
      return false;
    } else if (_oldpasswordTextController.text != AppPreferences().getUserData.password) {
      print(AppPreferences().getUserData.password);
      print(_oldpasswordTextController.text);
      showSnackBar(
          context: context,
          content: 'Your old password is inccorect',
          error: true);
      return false;
    } else if (_passwordTextController.text !=
        _passwordConfirmTextController.text) {
      showSnackBar(
          context: context,
          content: 'Your new password does not match',
          error: true);
      return false;
    }else if (!validateStructure(_passwordTextController.text)) {
      showSnackBar(context: context, content: 'Password is weak', error: true);
      return false;
    }
    return true;
  }

  Future<void> changePassword() async {
    loadingDialog(context, true);
    bool statusChange = await FbAuthController()
        .updatePassword(context, password: _passwordTextController.text);
    if (statusChange) {
      await FbFireStoreController().updateState(
          uid: AppPreferences().getUserData.path,
          collectionName: 'users',
          data: {'password': _passwordTextController.text});
      await AppPreferences().saveAndChangePassword(password: _passwordTextController.text);
      loadingDialog(context, false);
      showSnackBar(context: context, content: 'The password has been changed successfully');
      Navigator.pop(context);
    } else {
      loadingDialog(context, false);
      showSnackBar(
          context: context,
          content: 'Failure while trying to change the password, try again later',
          error: true);
    }
  }

  void loadingDialog(BuildContext context, bool run) {
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
  bool validateStructure(String value) {
    // String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    String pattern = r'^(?=.*?[a-zA-Z])(?=.*?[0-9]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }
}