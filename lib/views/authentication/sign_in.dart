
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hiatunisie/constant.dart';
import 'package:hiatunisie/services/user_service.dart';
import 'package:hiatunisie/utils/loading_widget.dart';
import 'package:hiatunisie/viewmodels/user_viewmodel.dart';
import 'package:hiatunisie/views/authentication/forget_password_screen.dart';
import 'package:hiatunisie/views/authentication/registration/sign_up.dart';
import 'package:hiatunisie/views/global_components/button_global.dart';
import 'package:hiatunisie/views/location/location_permission.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserService userService = UserService();

  //userview model
  final UserViewModel userViewModel = UserViewModel(); 
  

  String? emailError;
  String? passwordError;
  bool isLoading = false;

  void showSuccessAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.done,
              color: Colors.green,
            ),
            SizedBox(width: 8),
            Text('Success'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(kMainColor),
            ),
            child:  const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
      return Scaffold(
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/hiaauthbgg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 35.0),
                 Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[ 
                      SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Image.asset(
                        'images/h_logo_white.png',
                        height: 50.0,
                        width: 50.0,
                      ),
                    ),
                   
                    ]
                  ),
                const Gap(13),
                    const Text(
                      'Bienvenue! Connectez-vous',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 25.0),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width ,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        color: Colors.white,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Lottie.asset(
                                  'images/lottie.json',
                                  height: 250,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                     const SizedBox(height: 8.0),
                                  _buildEmailField(userViewModel),
                                  const SizedBox(height: 20.0),
                                  _buildPasswordField(userViewModel),
                                  const SizedBox(height: 10.0),
                                  _buildForgotPasswordRow(context),
                                  const SizedBox(height: 10.0),
                                  _buildLoginButton(context,userViewModel),
                                  const SizedBox(height: 10.0),
                                  _buildSignUpRow(context),
                                  const SizedBox(height: 10.0),
                                  _buildOrDivider(),
                                  const SizedBox(height: 10.0),
                                 // _buildFacebookButton(),
                                  const SizedBox(height: 10.0),
                                  _buildTermsAndPrivacyText(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
        
      }
    );
  }

  Widget _buildEmailField(UserViewModel userViewModel) {
    return AppTextField(
      controller: emailController,
      cursorColor: kMainColor,
      textFieldType: TextFieldType.EMAIL,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Email',
        errorText: userViewModel.emailError,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(
            color: kSecondaryColor,
            width: 2.0,
          ),
        ),
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 187, 187, 187),
        ),
        floatingLabelStyle: const TextStyle(
          color: kMainColor,
        ),
      ),
    );
  }

  Widget _buildPasswordField(UserViewModel userViewModel) {
    return AppTextField(
      controller: passwordController,
      cursorColor: kMainColor,
      textFieldType: TextFieldType.PASSWORD,
    
      decoration: InputDecoration(
        labelText: 'Mot de passe',
        hintText: 'Mot de passe',
        errorText: userViewModel.passwordError,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(
            color: kSecondaryColor,
            width: 2.0,
          ),
        ),
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 187, 187, 187),
        ),
        floatingLabelStyle: const TextStyle(
          color: kMainColor,
        ),
      ),
    );
  }

  Widget _buildForgotPasswordRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Vous avez oublié votre mot de passe? ',
            style: TextStyle(
              fontSize: 13.0,
              color: kTitleColor,
            ),
            textAlign: TextAlign.center,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForgetPassword()),
              );
            },
            child: const Text(
              'ici',
              style: TextStyle(
                fontSize: 15.0,
                color: kSecondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context , UserViewModel userViewModel) {
  return Consumer<UserViewModel>(
    builder: (context, authViewModel, child) {
      return authViewModel.isLoading
          ? const LoadingWidget(color: kMainColor,)
          : ButtonGlobal(
              buttonTextColor: Colors.white,
              buttontext: 'Connexion',
              buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
              onPressed: () async {
                try {
                  bool hasTimedOut = false;
                  
                  // Start a timer for 15 seconds
                  Future.delayed(const Duration(seconds: 15)).then((_) {
                    if (authViewModel.isLoading) {
                      hasTimedOut = true;
                      authViewModel.cancelLogin();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('La connexion a pris trop de temps. Veuillez réessayer.'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  });

                  // Attempt login
                  await authViewModel.login(
                    emailController.text,
                    passwordController.text,
                  );

                  // Only proceed if we haven't timed out
                  if (!hasTimedOut && authViewModel.isAuthenticated()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LocationPermission(),
                      ),
                    );
                  }
                } catch (e) {
                  // Handle any other errors
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Une erreur est survenue. Veuillez réessayer.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            );
    },
  );
}


  Widget _buildSignUpRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Vous n\'avez pas de compte? ',
            style: TextStyle(
              fontSize: 15.0,
              color: kTitleColor,
            ),
            textAlign: TextAlign.center,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUp()),
              );
            },
            child: const Text(
              'Inscrivez-vous',
              style: TextStyle(
                fontSize: 15.0,
                color: kSecondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            thickness: 1.0,
            color: kGreyTextColor.withOpacity(0.3),
          ),
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'or',
            style: kTextStyle.copyWith(color: kGreyTextColor),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            thickness: 1.0,
            color: kGreyTextColor.withOpacity(0.3),
          ),
        )),
      ],
    );
  }


  Widget _buildTermsAndPrivacyText() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'En continuant, vous acceptez nos ',
          style: kTextStyle.copyWith(color: kTitleColor),
          children: <TextSpan>[
            TextSpan(
                text: 'Conditions d\'utilisation',
                style: kTextStyle.copyWith(
                    fontWeight: FontWeight.bold, color: kSecondaryColor)),
            TextSpan(
              text: '  et ',
              style: kTextStyle.copyWith(color: kTitleColor),
            ),
            TextSpan(
                text: 'Politique de confidentialité',
                style: kTextStyle.copyWith(
                    fontWeight: FontWeight.bold, color: kSecondaryColor)),
          ],
        ),
      ),
    );
  }

  
}
