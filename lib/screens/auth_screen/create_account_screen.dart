import 'package:complaints_app/firebase/fb_auth_controller.dart';
import 'package:complaints_app/firebase/fb_firestore.dart';
import 'package:complaints_app/models/users.dart';
import 'package:complaints_app/utils/helpers.dart';
import 'package:complaints_app/utils/size_config.dart';
import 'package:complaints_app/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

String nameArea = ' ';

class _CreateAccountScreenState extends State<CreateAccountScreen>
    with Helpers {
  late TextEditingController _emailTextController;
  late TextEditingController _fullNameTextController;
  late TextEditingController _numberPhoneTextController;
  late TextEditingController _passwordTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _fullNameTextController = TextEditingController();
    _numberPhoneTextController = TextEditingController();

    nameArea = '';
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
    SizeConfig().designHeight(7).designWidth(4.15).init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: SizeConfig().scaleHeight(3),
        backgroundColor: Colors.green,
        title: Text(
          'Create New Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig().scaleTextFont(24),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig().scaleWidth(30),
              vertical: SizeConfig().scaleWidth(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create New Account',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig().scaleTextFont(32),
                ),
              ),

              SizedBox(height: SizeConfig().scaleHeight(20)),
              AppTextField(
                hint: 'Full Name',
                controller: _fullNameTextController,
              ),
              SizedBox(height: SizeConfig().scaleHeight(11)),
              AppTextField(
                hint: 'Email',
                controller: _emailTextController,
              ),
              SizedBox(height: SizeConfig().scaleHeight(11)),
              AppTextField(
                hint: 'Password',
                controller: _passwordTextController,
                obscureText: true,
              ),
              SizedBox(height: SizeConfig().scaleHeight(11)),
              AppTextField(
                hint: 'Mobile No.',
                controller: _numberPhoneTextController,
                maxLength: 10,
              ),
              SizedBox(
                height: SizeConfig().scaleHeight(11),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  minimumSize:
                      Size(double.infinity, SizeConfig().scaleHeight(55)),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(SizeConfig().scaleHeight(11)),
                  ),
                ),
                onPressed: () async {
                  await performCreateAccount();
                },
                child: const Text(
                  'Create',
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
    if (checkData()) {
      loadingDialog(context, true);
      await createAccount();
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
        await FbAuthController().createAccount(context, users: users);

    if (statusAuth) {
      loadingDialog(context, false);
      Navigator.pop(context);
    } else {
      loadingDialog(context, false);
    }
  }

  Users get users {
    Users users = Users();
    users.name = _fullNameTextController.text;
    users.email = _emailTextController.text.trim();
    users.password = _passwordTextController.text;
    users.mobile = _numberPhoneTextController.text;
    users.isSuspend = false;
    users.levelUser = '3'; // 1 ==> admin , 2 ==> ministry , 3 ==> people
    users.fcm = '';

    return users;
  }

  void loadingDialog(BuildContext context, bool run) {
    // loadingDialog(context ,false);
    if (run) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
    } else {
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
