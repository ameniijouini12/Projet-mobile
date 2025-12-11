// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hiatunisie/constant.dart';
import 'package:hiatunisie/services/user_service.dart';
import 'package:hiatunisie/utils/loading_widget.dart';
import 'package:hiatunisie/views/authentication/sign_in.dart';
import 'package:hiatunisie/views/global_components/button_global.dart';
import 'package:nb_utils/nb_utils.dart';

class ChangePassword extends StatefulWidget {
  final String email;

  const ChangePassword({super.key, required this.email});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final UserService _userService = UserService();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/hiaauthbgg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 10.0, right: 10.0),
                  child: SizedBox(
                      width: context.width(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Change your password now',
                            style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Please enter your new password to reset your password.',
                            style: kTextStyle.copyWith(
                              color: white,
                            ),
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Expanded(
                  child: Container(
                    width: context.width(),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 20.0,
                                    bottom: 20.0),
                                child: AppTextField(
                                  controller: passwordController,
                                  cursorColor: kMainColor,
                                  textFieldType: TextFieldType.PASSWORD,
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                    hintText: 'Password',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              12.0)), // Adjust the radius as needed
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              12.0)), // Ensure the radius matches
                                      borderSide: BorderSide(
                                        color: kSecondaryColor,
                                        width: 2.0,
                                      ),
                                    ),
                                    labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 187, 187, 187),
                                    ),
                                    floatingLabelStyle: TextStyle(
                                      color: kMainColor,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 20.0,
                                    bottom: 20.0),
                                child: AppTextField(
                                  controller: confirmPasswordController,
                                  cursorColor: kMainColor,
                                  textFieldType: TextFieldType.PASSWORD,
                                  decoration: const InputDecoration(
                                    labelText: 'Confirm Password',
                                    hintText: 'Confirm Password',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              12.0)), // Adjust the radius as needed
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              12.0)), // Ensure the radius matches
                                      borderSide: BorderSide(
                                        color: kSecondaryColor,
                                        width: 2.0,
                                      ),
                                    ),
                                    labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 187, 187, 187),
                                    ),
                                    floatingLabelStyle: TextStyle(
                                      color: kMainColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        isLoading
                            ? const LoadingWidget(
                                color: kMainColor,
                                size: 10.0,
                                spacing: 10.0,
                              )
                            : ButtonGlobal(
                                    buttonTextColor: Colors.white,

                                buttontext: 'Continue',
                                buttonDecoration: kButtonDecoration.copyWith(
                                    color: kMainColor),
                                onPressed: () {
                                  changePassword(widget.email,
                                      passwordController.text.toString());
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void changePassword(email, password) async {
    setState(() {
      isLoading = true;
    });
    if (password == confirmPasswordController.text) {
      await _userService.resetPassword(email, password);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const SignIn()));
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password does not match'),
          backgroundColor: kMainColor,
        ),
      );
    }
  }
}
