// ignore_for_file: use_build_context_synchronously

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:hiatunisie/constant.dart';
import 'package:hiatunisie/services/user_service.dart';
import 'package:hiatunisie/views/authentication/phone_verification.dart';
import 'package:hiatunisie/views/global_components/button_global.dart';
import 'package:hiatunisie/widgets/custom_toast.dart';
import 'package:nb_utils/nb_utils.dart';



class PhoneAuth extends StatefulWidget {
  final String email;

  const PhoneAuth({super.key, required this.email});

  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  TextEditingController phoneController = TextEditingController();
  final UserService _userService = UserService();
  String countryCode = '+216';
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
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    Icons.arrow_back,
                    color: kTitleColor,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 10.0, right: 10.0),
                  child: SizedBox(
                      width: context.width(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'What’s your Phone Number',
                            style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'We’ll check if you have an account',
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
                            child: AppTextField(
                              textFieldType: TextFieldType.PHONE,
                              controller: phoneController,
                              enabled: true,
                              onChanged: (value) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                hintText: '00 123 456 789',
                                border: const OutlineInputBorder(),
                                prefix: CountryCodePicker(
                                  padding: EdgeInsets.zero,
                                  onChanged: (value) {
                                    countryCode = value.dialCode!;
                                  },
                                  initialSelection: 'BD',
                                  showFlag: true,
                                  showDropDownButton: true,
                                  alignLeft: false,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ButtonGlobal(
                                buttonTextColor: Colors.white,

                          buttontext: 'Continue',
                          buttonDecoration:
                              kButtonDecoration.copyWith(color: kMainColor),
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            sendOtpToPhone(phoneController.text,widget.email);
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

  void sendOtpToPhone(String phone,String email) async {
    try {
      var response = await _userService.sendPhoneOtp(phone,email);
      print(response);
      if (response['success']) {
        toast(response['message']);
        setState(() {
          isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhoneVerification(
              phone: phoneController.text,
            ),
          ),
        );
      } else if  (response['code'] == 409) {
         showCustomToast(context, "Votre numéro de téléphone existe déjà", isError: true);
      }

      else {
        toast('Failed to send OTP: ${response['message']}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      toast('Failed to send OTP. Please try again later.');
    }
  }
}
