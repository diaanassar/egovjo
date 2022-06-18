import 'package:complaints_app/firebase/fb_auth_controller.dart';
import 'package:complaints_app/utils/helpers.dart';
import 'package:complaints_app/utils/size_config.dart';
import 'package:complaints_app/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({Key? key}) : super(key: key);
  bool isReset = false;
  String appBarNameRCpass = 'nulll';
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with Helpers {
  late TextEditingController _emailTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().designHeight(7).designWidth(4.15).init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        title: Text(
          'Reset Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig().scaleTextFont(24),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig().scaleWidth(30),
            vertical: SizeConfig().scaleWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reset Password',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig().scaleTextFont(32),
              ),
            ),
            Text(
              'Enter Your Email Account',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: SizeConfig().scaleTextFont(21),
              ),
            ),
            SizedBox(height: SizeConfig().scaleHeight(20)),
            AppTextField(
              hint: 'Email',
              controller: _emailTextController,
              maxLength: 30,
            ),
            SizedBox(height: SizeConfig().scaleHeight(20)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                minimumSize: Size(double.infinity, SizeConfig().scaleHeight(60)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                loadingDialog(context ,true);
                await performForgetPassword();
              },
              child: Text(
                'Send',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> performForgetPassword() async {
    if (checkData()) {
      await forgetPassword();
    }
  }

  bool checkData() {
    if (_emailTextController.text.isNotEmpty) {
      return true;
    }
    loadingDialog(context ,false);
    showSnackBar(context: context, content: 'Enter Required Data' , error: true);
    return false;
  }

  Future<void> forgetPassword() async {
    bool status = await FbAuthController()
        .forgetPassword(context, email: _emailTextController.text);
    if (status) {
      loadingDialog(context ,false);
      showSnackBar(
          context: context,
          content: 'An email has been sent to you to change your password');
      Navigator.pop(context);
    } else{
      loadingDialog(context ,false);
    }
  }

  void loadingDialog(BuildContext context, bool run) {
    // loadingDialog(context ,false);
    if (run)
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(child: CircularProgressIndicator(),);
          });
    else {
      Navigator.pop(context);
    }
  }
}
