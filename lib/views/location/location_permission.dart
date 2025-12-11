import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hiatunisie/services/user_service.dart';
import 'package:hiatunisie/utils/loading_widget.dart';
import 'package:hiatunisie/viewmodels/user_viewmodel.dart';
import 'package:hiatunisie/views/foodPreference/food_preferences_screen.dart';
import 'package:hiatunisie/views/global_components/button_global.dart';
import 'package:hiatunisie/constant.dart';
import 'package:hiatunisie/views/location/bottom_location_sheet.dart';
import 'package:hiatunisie/widgets/custom_toast.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../widgets/smart_scaffold.dart';

class LocationPermission extends StatefulWidget {
  const LocationPermission({super.key});

  @override
  _LocationPermissionState createState() => _LocationPermissionState();
}

class _LocationPermissionState extends State<LocationPermission> {
  final UserService userService = UserService();
  bool isLoading = false;
  String selectedOption = '';
  bool isPermissionGranted = false;

  String? userId;
  Position? position = Position(
    latitude: 36.068298,
    longitude: 10.3381,
    timestamp: DateTime.now(),
    accuracy: 1.0,
    altitude: 1.0,
    heading: 1.0,
    speed: 1.0,
    speedAccuracy: 1.0,
    altitudeAccuracy: 1.0,
    headingAccuracy: 1.0,
  );
  Future<void> validateLocationAccess() async {
    // Step 1: Check if GPS service is ON
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Veuillez activer le GPS pour continuer"),
        ));
        return;
      }
    }

    // Step 2: Check Permission
    PermissionStatus status = await Permission.location.status;

    if (status.isDenied) {
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      openAppSettings();
      return;
    }

    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Permission localisation refusée"),
      ));
      return;
    }

    setState(() {
      isPermissionGranted = true;
    });

    // ✅ Now you can show the option modal safely
    showLocationOptions(context);
  }

  @override
  void initState() {
    super.initState();
  }
  Future<void> checkPermissionStatus() async {
    var status = await Permission.location.status;
    setState(() {
      isPermissionGranted = status.isGranted;
    });
  }
  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      await Permission.location.request();
    }

  }

  Future<void> saveUserLocation() async {
    setState(() {
      isLoading = true;
    });
    try {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      userViewModel.initSession();

      if (selectedOption == 'current') {
        position = await userViewModel.determinePosition();
        String? address = await userViewModel.getAddressFromCoordinates(
            position!.latitude, position!.longitude);

        userService.updateUserLocation(userViewModel.userId!, address!,
            position!.longitude, position!.latitude);
      } else if (selectedOption == 'manual' && position != null) {
        // Handle manual location input
        String? address = await userViewModel.getAddressFromCoordinates(
            position!.latitude, position!.longitude);

        userService.updateUserLocation(userViewModel.userId!, address!,
            position!.longitude, position!.latitude);
      }

      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FoodPreferencePage()),
      );

      const CustomToastWidget(
        isError: false,
        message: 'Location updated successfully',
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update location: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {

    return SmartScaffold(
      resizeToAvoidBottomInset: false,
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
              const SizedBox(
                height: 60.0,
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
                        height: 40.0,
                      ),
                      Image.asset('images/mapsmall.png'),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Text(
                          "Trouver des établissements à proximité",
                          textAlign: TextAlign.center,
                          style: kTextStyle.copyWith(
                            color: kTitleColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Pour trouver des établissements à proximité, nous avons besoin de votre emplacement.",
                          textAlign: TextAlign.center,
                          style: kTextStyle.copyWith(
                            color: kGreyTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      isLoading
                          ? const LoadingWidget(
                              color: kMainColor,
                              spacing: 10.0,
                            )
                          : ButtonGlobal (
                              buttonTextColor: Colors.white,
                              buttontext: 'Votre emplacement',
                              buttonDecoration: kButtonDecoration.copyWith(
                                 color: kMainColor,
                              ),
                              onPressed: () {
                                 validateLocationAccess();
                              },
                            ),
                      /*Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            validateLocationAccess();
                          },
                          child: Text(
                            'Je préfère entrer manuellement mon emplacement',
                            textAlign: TextAlign.center,
                            style: kTextStyle.copyWith(
                              color: kGreyTextColor,
                            ),
                          ),
                        ),
                      ),*/
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
}
