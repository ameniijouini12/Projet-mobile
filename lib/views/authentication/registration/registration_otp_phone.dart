// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hiatunisie/constant.dart';
import 'package:hiatunisie/services/user_service.dart';
import 'package:hiatunisie/views/authentication/sign_in.dart';
import 'package:hiatunisie/views/global_components/button_global.dart';
import 'package:hiatunisie/widgets/custom_toast.dart';
import 'package:nb_utils/nb_utils.dart';

import '../widgets/phone_inoput_field.dart';




class SignUpPhoneOtp extends StatefulWidget {
  final String email;
  const SignUpPhoneOtp({super.key, required this.email});

  @override
  State<SignUpPhoneOtp> createState() => _SignUpPhoneOtpState();
}

class _SignUpPhoneOtpState extends State<SignUpPhoneOtp> {
  final TextEditingController phoneController = TextEditingController();
  final UserService _userService = UserService();

  String fullPhone = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const SizedBox(height: 50.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ajouter votre numéro de téléphone',
                        style: kTextStyle.copyWith(
                          color: kTitleColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Nous vous enverrons un code de vérification',
                        style: kTextStyle.copyWith(color: white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 25.0),
                      PhoneInputField(
                        controller: phoneController,
                        onChanged: (phone) {
                          setState(() => fullPhone = phone);
                        },
                      ),
                      const SizedBox(height: 20.0),
                      ButtonGlobal(
                        buttonTextColor: Colors.white,
                        buttontext: isLoading ? 'En cours...' : 'Continuer',
                        buttonDecoration: kButtonDecoration.copyWith(
                          color: isLoading ? Colors.grey : kMainColor,
                        ),
                        onPressed: () {
                          if (isLoading) return;

                          setState(() => isLoading = true);

                          final cleanNumber = phoneController.text.replaceAll(' ', '');
                          if (cleanNumber.isEmpty || cleanNumber.length < 8) {
                            showCustomToast(
                              context,
                              'Veuillez entrer un numéro de téléphone valide',
                              isError: true,
                            );
                            setState(() => isLoading = false);
                            return;
                          }

                          sendOtpToPhone(fullPhone, widget.email);
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

  void sendOtpToPhone(String phone, String email) async {
    showCustomToast(
      context,
      'Votre compte a été créé avec succès. Veuillez vous connecter.',
      isError: false,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignIn()),
    );

    /* try {
      var response = await _userService.sendPhoneOtp(phone, email);
      if (response['success']) {
        toast(response['message']);
        setState(() => isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhoneVerification(phone: phone),
          ),
        );
      } else {
        showCustomToast(context, response['message'], isError: true);
        setState(() => isLoading = false);
      }
    } catch (error) {
      toast('Failed to send OTP. Please try again later.');
    } */
  }
}
