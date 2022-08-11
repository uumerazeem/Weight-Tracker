import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:interview_test/providers/auth_provider.dart';
import 'package:interview_test/utils/app_colors.dart';
import 'package:interview_test/utils/shared_preference.dart';
import 'package:interview_test/views/home_screen.dart';
import 'package:interview_test/widgets/single_action_button.dart';
import 'package:interview_test/widgets/text_box.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  PreferenceService prefs = PreferenceService();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<AuthProvider>(builder: (context, authProvider, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //             Navigator.pushReplacement(
                // context,
                // MaterialPageRoute(
                //     builder: (context) =>
                //         ConfirmationScreen()))
                // SvgPicture.asset(Images.logo),
                Text(authProvider.screenState ? "SignUp" : "SignIn",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextBoxAccounts(
                              boxHint: "Email",
                              obsecure: false,
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Color(0xffFF9898),
                              ),
                              validate: (value) {
                                if (EmailValidator.validate(value)) {
                                } else {
                                  return "Enter Valid Email";
                                }
                                return null;
                              }),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          TextBoxAccounts(
                            boxHint: "Password",
                            obsecure: true,
                            controller: password,
                            prefixIcon: const Icon(
                              Icons.lock_open_rounded,
                              color: Color(0xffFF9898),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            validate: (value) {
                              if (value!.isEmpty || value.length < 6) {
                                return 'Password must have 6 characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          authProvider.loading == true
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.primaryColor,
                                  ),
                                )
                              : SingleActionButton(
                                  buttonName: authProvider.screenState
                                      ? "Sign Up"
                                      : "Sign In",
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) {
                                      Fluttertoast.showToast(
                                          msg: "Please Enter valid form");
                                    } else {
                                      authProvider.setLoading(true);

                                      if (authProvider.screenState == true) {
                                        await auth
                                            .createUserWithEmailAndPassword(
                                                email: email.text,
                                                password: password.text)
                                            .then((value) {
                                          prefs.addEmail(email.text);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreen()));
                                        }).catchError((onError) {
                                          Fluttertoast.showToast(
                                              msg: onError.toString().substring(
                                                  onError
                                                          .toString()
                                                          .lastIndexOf("]") +
                                                      1));
                                        });
                                      } else {
                                        await auth
                                            .signInWithEmailAndPassword(
                                                email: email.text,
                                                password: password.text)
                                            .then((value) {
                                          prefs.addEmail(email.text);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreen()));
                                        }).catchError((onError) {
                                          Fluttertoast.showToast(
                                              msg: onError.toString().substring(
                                                  onError
                                                          .toString()
                                                          .lastIndexOf("]") +
                                                      1));
                                        });
                                      }
                                      authProvider.setLoading(false);
                                    }
                                  },
                                )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const RequestScreen()));
                    print("hello");
                    authProvider.setScreenState(!authProvider.screenState);
                  },
                  child: SizedBox(
                    child: Text(
                      authProvider.screenState == true
                          ? "Not have and account? SignUp"
                          : "Already have an account? SignIn",
                      style: TextStyle(color: AppColor.primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
