import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hiatunisie/app/style/app_colors.dart';
import 'package:hiatunisie/app/style/app_style.dart';
import 'package:hiatunisie/app/style/font_size.dart';
import 'package:hiatunisie/constant.dart';
import 'package:hiatunisie/utils/connectivity_manager.dart';
import 'package:hiatunisie/widgets/custom_toast.dart';
import 'package:hiatunisie/widgets/styled_button.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart'; 

class DisconnectedWidget extends StatelessWidget {
  const DisconnectedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityManager>(
      builder: (context, connectivityManager, child) {
        bool isConnected = connectivityManager.isConnected;

        return Scaffold(
          backgroundColor: kMainColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/offline_icon.png",
                width: 110.w,
                height: 110.h,
              ),
              Gap(35.h),
              Text(
                isConnected ? 'Connected to the internet.' : 'No internet connection.',
                textAlign: TextAlign.center,
                style: AppStyles.interregularTitle.withColor(AppColors.lightGrey).withSize(FontSizes.headline6),
              ),
              Gap(30.h),
              StyledButton(
                style: ButtonStyles.primary,
                title: 'Try again',
                onPressed: ()async {
                   connectivityManager.checkInitialConnectivity(); 
                  if (!connectivityManager.isConnected) {
                     showCustomToast(context,"No internet connection !", isError: true);
                  }
                },
                reversed: true,
                icon: Image.asset(
                  "images/refresh_icon.png",
                  width: 17.w,
                  height: 19.h,
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 40).center(),
        );
      },
    );
  }
}
