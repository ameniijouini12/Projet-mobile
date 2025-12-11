import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hiatunisie/app/style/app_style.dart';
import 'package:hiatunisie/app/style/font_size.dart';
import 'package:hiatunisie/app/style/widget_modifier.dart';
import 'package:hiatunisie/services/user_service.dart';

import '../home/exports/export_homescreen.dart';

class ProfileBottomSheet extends StatefulWidget {
  const ProfileBottomSheet({
    super.key,
    this.imageExist = true,
  });

  final bool imageExist;

  @override
  _ProfileBottomSheetState createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends State<ProfileBottomSheet> {
  bool _isUploading = false; // Track the upload state

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add profile picture",
                style: AppStyles.interSemiBoldTextButton
                    .withColor(Colors.white)
                    .withSize(FontSizes.headline5),
              ).align(alignment: Alignment.topLeft),
              Gap(10.h),
              // Gap(10.h),
              InkWell(
                onTap: () async {
                  setState(() {
                    _isUploading = true; // Set uploading to true when user starts uploading
                  });

                  String? imageUrl = await UserService().uploadProfileImage(context);

                  if (imageUrl != null) {
                    Navigator.pop(context);

                    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
                    userViewModel.updateProfileImage(imageUrl);
                  }

                  setState(() {
                    _isUploading = false; // Set uploading to false once upload is complete
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      "images/editpicicon.png",
                      height: 25.r,
                      width: 25.r,
                    ),
                    Gap(10.w),
                    Text(
                      _isUploading ? "Uploading..." : "Upload from phone", // Change text when uploading
                      style: AppStyles.interSemiBoldTextButton
                          .medium()
                          .withColor(Colors.white)
                          .withSize(FontSizes.title),
                    ),
                  ],
                ),
              ),
              Gap(10.h),
            ],
          ),
        ).customPadding(
          right: 24.w,
          left: 24.w,
          top: 40.h,
          bottom: 20.h,
        ),

        // Show overlay with blur effect and loading indicator while uploading
        if (_isUploading)
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.5), // Semi-transparent overlay
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Blur effect behind the loading indicator
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        color: Colors.white.withOpacity(0.4), // Transparent blur effect
                      ),
                    ),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kMainColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
