
// ignore_for_file: use_build_context_synchronously

import 'package:hiatunisie/services/user_service.dart';
import 'package:hiatunisie/utils/loading_widget.dart';
import 'package:hiatunisie/views/authentication/email.verification.dart';
import 'package:hiatunisie/views/global_components/button_global.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:hiatunisie/widgets/back_row.dart';
import 'package:hiatunisie/widgets/custom_toast.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();
  final UserService _userService = UserService();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SmartScaffold(
     
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 35.0,
                ),
                const BackRow(title: ""),
                const Gap(10),
                Padding(
                  padding:
                    const  EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: SizedBox(
                      width: context.width(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'You forgot your password?',
                            style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold),
                          ),
                          const Gap(10),
                          Text(
                            'Please enter your email address to reset your password.',
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
                          child: SizedBox(
                            height: 60.0,
                            child: TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: kTextStyle.copyWith(
                                  color: kTitleColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              enabled: true,
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        isLoading
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LoadingWidget(
                                    color: kMainColor,
                                    size: 10.0,
                                    spacing: 10.0,
                                  )
                                ],
                              )
                            : ButtonGlobal(
                                    buttonTextColor: Colors.white,

                                buttontext: 'Continue',
                                buttonDecoration: kButtonDecoration.copyWith(
                                    color: kMainColor),
                                onPressed: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  sendOtpToEmail(emailController.text);
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
      
    );
  }

  Future<bool> verifyEmail(String email) async {
    final response = _userService.verifyEmail(email);

    if (await response) {
      return true;
    } else {
      throw Exception('Failed to verify email');
    }
  }

  void sendOtpToEmail(String email) async {
    try {
      bool emailExists = await verifyEmail(email);
      if (emailExists) {
        var response = await _userService.forgetPassword(email);
        if (response['success']) {
          toast(response['message']);
          setState(() {
            isLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmailOtpVerification(
                email: email,
              ),
            ),
          );
        } else {
          toast('Failed to send OTP: ${response['message']}');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        toast('Email does not exist.');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      showCustomToast(context, 'Email does not exist !' , isError: true);
      setState(() {
        isLoading = false;
      });
    }
  }
}
