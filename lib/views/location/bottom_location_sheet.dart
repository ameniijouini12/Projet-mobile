import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiatunisie/app/style/app_fonts.dart';
import 'package:hiatunisie/app/style/font_size.dart';
import 'package:hiatunisie/app/style/widget_modifier.dart';
import 'package:hiatunisie/services/user_service.dart';
import 'package:hiatunisie/utils/loading_widget.dart';
import 'package:hiatunisie/views/foodPreference/food_preferences_screen.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:hiatunisie/views/location/map_picker_bottom_sheet.dart';
import 'package:hiatunisie/widgets/custom_toast.dart';
import 'package:hiatunisie/widgets/styled_button.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:map_location_picker/map_location_picker.dart';

Future<void> showLocationOptions(BuildContext context) async {
  showModalBottomSheet(
    backgroundColor: kMainColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    context: context,
    builder: (context) {
      String selectedOption = 'manual'; // Initial selected option
      bool isLoadingPosition = false;
      Position? position;
      final UserService userService = UserService();

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          Future<void> saveUserLocation() async {
            setState(() {
              isLoadingPosition = true;
            });
            try {
              final userViewModel = Provider.of<UserViewModel>(context, listen: false);
              userViewModel.initSession();
              position = await userViewModel.determinePosition();
              String? address = await userViewModel.getAddressFromCoordinates(
                  position!.latitude, position!.longitude);
              await userService.updateUserLocation(
                  userViewModel.userId!, address!, position!.longitude, position!.latitude);
              setState(() {
                isLoadingPosition = false;
              });
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const FoodPreferencePage()),
              );
              showCustomToast(context, 'Location updated successfully');

            } catch (e) {
              setState(() {
                isLoadingPosition = false;
              });
              showCustomToast(context, 'Failed to update location', isError: true);
            }
          }

          return SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Option de localisation",
                  style: TextStyle (
                    fontFamily: AppFonts.neurialGroteskBoldT2,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: FontSizes.headline6,
                  )
                ).align(alignment: Alignment.topLeft),
                Gap(26.h),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedOption = 'manual';
                    });
                  },
                  child: Row(
                    spacing: 5,
                    children: [
                      Icon(
                        Icons.map, // Use an appropriate icon
                        color: selectedOption == 'manual'
                            ? Colors.white // Highlighted color
                            : Colors.white.withOpacity(0.5), // Non-highlighted color
                      ),

                      Text(
                        "Visualiser la carte",
                        style:  TextStyle(
                          fontFamily: AppFonts.neurialGroteskRegularRegularT8,
                          color: selectedOption == 'manual'
                              ? Colors.white // Highlighted color
                              : Colors.white.withOpacity(0.5), // Non-highlighted color
                          fontWeight: FontWeight.w600,
                          fontSize: FontSizes.title,
                        )
                      ),
                    ],
                  ),
                ),
                Gap(10.h),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedOption = 'current';
                    });
                  },
                  child: Row(
                    spacing: 5,
                    children: [
                      Icon(
                        Icons.my_location, // Use an appropriate icon
                        color: selectedOption == 'current'
                            ? Colors.white // Highlighted color
                            : Colors.white.withOpacity(0.5), // Non-highlighted color
                      ),
                      Text(
                        "Votre position actuelle",
                        style:  TextStyle(
                          fontFamily: AppFonts.neurialGroteskRegularRegularT8,
                          color: selectedOption == 'current'
                              ? Colors.white // Highlighted color
                              : Colors.white.withOpacity(0.5), // Non-highlighted color
                          fontWeight: FontWeight.w600,
                          fontSize: FontSizes.title,
                        )
                      ),
                    ],
                  ),
                ),
                Gap(20.h),
                isLoadingPosition
                    ? const LoadingWidget()
                    : StyledButton(
                        title: 'Valider',
                        onPressed: () async {
                          if (selectedOption == 'current') {
                            await saveUserLocation();
                          } else if (selectedOption == 'manual') {
                            showMapBottomSheet(context);
                          }
                        },
                        isLoading: isLoadingPosition,
                    style: ButtonStyles.primary,

                      ),
              ],
            ),
          ).customPadding(
            right: 24.w,
            left: 24.w,
            top: 60.h,
            bottom: 14.h,
          );
        },
      );
    },
  );
}

void showMapBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return MapPickerBottomSheet(
        onLocationPicked: (latLng.LatLng position) {
          print('Picked position: ${position.latitude}, ${position.longitude}');
        },
        initialLocation: const latLng.LatLng(0.0, 0.0),
      );
    },
  );
}
