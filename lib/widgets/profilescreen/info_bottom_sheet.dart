import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiatunisie/constant.dart';
import 'package:hiatunisie/widgets/calculate_width_height.dart';
import 'package:provider/provider.dart';

import '../../app/style/app_fonts.dart';
import '../../viewmodels/user_viewmodel.dart';
import '../../views/authentication/sign_in.dart';


Widget infoBottomSheet() {
  return SafeArea(
      top: false,
      child: DraggableScrollableSheet(
          expand: false,
          // if true it will be a white space around the bottomSheet given from the show method
          initialChildSize: 257 / 812,
          minChildSize: 257 / 812,
          maxChildSize: 257 / 812,
          snap: false,
          // if true it will be disable to scroll the bottom sheet as want
          builder: (context, controller) {
            return ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Scaffold(
                  backgroundColor: Colors.white,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: calculateSize("h", 8)),
                      Container(
                        width: 56,
                        height: 4,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                      SizedBox(height: calculateSize("h", 20)),
                      const Text(
                        "Voulez-vous vraiment vous déconnecter ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kGreyTextColor,
                          fontSize: 14,
                          fontFamily: AppFonts.neurialGroteskBolderMeduimT4,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: calculateSize("h", 16)),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.blueGrey,
                      ),
                      SizedBox(height: calculateSize("h", 16)),
                      SizedBox(height: calculateSize("h", 8)),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: calculateSize("w", 20)),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: calculateSize("h", 14)),
                                child: const Text(
                                  "Annuler",
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 12,
                                      fontFamily:AppFonts.neurialGroteskBolderMeduimT4,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: calculateSize("h", 20)),
                      InkWell(
                        onTap: () {
                          final userViewModel = Provider.of<UserViewModel>(
                              context,
                              listen: false);
                          userViewModel.logout();
                          Get.offAll(() => const SignIn());
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: calculateSize("w", 20)),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: calculateSize("h", 14)),
                                child: const Text(
                                  "Déconnecter",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily:AppFonts.neurialGroteskBolderMeduimT4,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            );
          }));
}
