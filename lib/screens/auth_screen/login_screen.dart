import 'package:complaints_app/firebase/fb_auth_controller.dart';
import 'package:complaints_app/utils/helpers.dart';
import 'package:complaints_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:complaints_app/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Helpers {
  late TextEditingController emailTextController;
  late TextEditingController passwordTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().designHeight(7).designWidth(4.15).init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/bg3.jpg'), fit: BoxFit.cover),
          ),
          child: Stack(
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black, width: 2)),
                  height: 320,
                  width: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome',
                        style: TextStyle(
                            fontSize: SizeConfig().scaleTextFont(35),
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: SizeConfig().scaleHeight(20),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: AppTextField(
                          controller: emailTextController,
                          hint: 'Email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig().scaleHeight(10),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: AppTextField(
                          controller: passwordTextController,
                          hint: 'Password',
                          obscureText: true,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig().scaleHeight(20),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            performSignIn();
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig().scaleTextFont(25),
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 30),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/create_account_screen');
                              },
                              child: const Text('Create Account' , style: TextStyle(color: Colors.black),)),
                          const Text(' | '),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/forget_password_screen');
                              },
                              child: const Text('Reset Password' , style: TextStyle(color: Colors.red),)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> performSignIn() async {
    print('performSignIn');
    if (emailTextController.text.isNotEmpty &&
        passwordTextController.text.isNotEmpty) {
      await signIn();
      // print('2');
    } else {
      showSnackBar(
          context: context,
          content: 'Please Enter Email And Password',
          error: true);
    }
  }

  Future<void> signIn() async {
    await FbAuthController().signIn(context,
        email: emailTextController.text.trim(),
        password: passwordTextController.text);
  }
//
// void loadingDialog(bool run) {
//   // loadingDialog(context ,false);
//   if (run) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         });
//   } else {
//     Navigator.pop(context);
//   }
// }
}
