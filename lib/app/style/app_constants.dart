import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';


class AppConstants {
  AppConstants._();

  //$ Default api url
  static const String baseUrl = 'https://hiabackend-production-7f3a.up.railway.app';
  //static const String baseUrl = 'http://10.0.2.2:3030';

  //$ Default Elevation
  static double defaultElevation = 8.r;

  static double defaultRadius = 3.r;

  //$ Home Container's Radius
  static double homeRadius = 24.r;

  static final inputs = _Inputs._();
  static final buttons = _Buttons._();
  static final bottomBar = _BottomBar._();
  static final gradientBottomBar = _GradientBottomBar._();
  static final recipe = _Recipe._();
  static final settings = _Settings._();
  static final popup = PopUpCard._();


  static double logoHorizontalPadding = 64.w;

  static double dropdownSymmetricHorizontalPadding = 16.w;

  static double heightOfInputBox = dropDownHeight.h;

  //? Scaffold

  static double bodyTopPadding = 5.h;
  static double minBodyTopPadding = 5.h;
  static double maxBodyTopPadding = 100.h;
  static double bodyMinSymetricHorizontalPadding = 24.w;
  static double bodyMaxSymetricHorizontalPadding = 34.w;
  static double bodyMinBottomPadding = 20.h;
  static double bodyMaxBottomPadding = 120.h;
  static double bodyBottomPadding = 50.h;
  static double verticalSpacing = 10.h;

  //? Spacings
  static double minSpacing = 10;
  static double normalSpacing = 20;
  static double maxSpacing = 30.r;

  //? TabBar
  static double tabBarHeight = 50.h;

  //$ Elevation concerned widgets
  static bool applyElevationToAppBar = defaultElevation != 0 && true;
  static bool applyElevationToBottomNavBar = defaultElevation != 0 && false;

  static bool get elevationAppliedToAppBar => applyElevationToAppBar;

  // //? AppBar
  static double appBarHeight = 130.h;
  static double appBarTopPaddingToSafeArea = 12.h;
  static double searchAppBarHeight = 80.h;
  static double appBarSymetricHorizontalPadding = bodyMaxSymetricHorizontalPadding;
  static double appBarButtonsBorderRadius = 8.r;
  static double appBarButtonHeight = 40.h + defaultElevation;
  static double appBarButtonWidth = appBarButtonHeight + 20.w;
  static double appBarButtonIconSize = 20.r;
  static double appBarButtonsElevation = applyElevationToAppBar ? defaultElevation : 0;
  static double appBarRadius = 28.r;
  static double appBarElevation = applyElevationToAppBar ? defaultElevation : 0;
  static double searchAppBatTitleSpacing = 20;

  //? AutoComplete Inputs
  static double autoCompleteInputSuggestionsBoxElevation = defaultElevation + 2;
  static const double autoCompleteInputSuggestionsSymetricHorizontalPadding = 10;

  static const double autoCompleteInputSuggestionsSymetricVerticalPadding = 5;
  static const int autoCompleteInputDebounceDuration = 600;

  //? Cards
  //$ MVP VERSION
  //static const double cardRadius = 16;
  static double cardHeight = 143.h;
  static double cardWidth = 175.w;
  static double cardBlur = 16.r;
  static double shoppingCardWidth = 161.w;
  static double shoppingCardHeight = 260.h;
  static double productImageWidth = 102.w;
  static double productImageHeight = 115.h;

  //? list Tiles
  static double listTileRadius = defaultRadius;

  //? Progress Indicators
  static double circularProgressIndicatorStrokeWidth = 2.w;
  static double linearProgressIndicatorMinHeight = 4.h;
  static const double downloadCircularProgressIndicatorColorSize = 45;

  //? Tab bar
  static double tabBarRadius = 24.r;
  static double authTabBarRadius = 30.r;

  //? Dropdow
  static double dropDownHeight = 37.h;
  static double minimalDropDownWidth = 48.w;
  static double minimalDropDownHeight = 31.h;
  static double dropDownListItemHeight = 48.h;

  //? WebView
  static double webViewElevation = defaultElevation + 2.r;

  //? Logo
  static double logoSize = 75.r;

  //? Scaffold Divider
  static double scaffoldDividerWidth = 300.w;
  static double scaffoldDividerThickness = 1.r;
  static double dividerThickness = 1.r;

  //? Underlines
  static double underlineHeight = 3.h;
  static double underlineRadius = 32.r;

  //? Page Control
  static double pageControlDotSize = 6.r;

  //? Alert Buttons
  static double alertButtonHeight = 40.h;
  static double alertButtonWidth = 140.w;
  static double alertButtonRadius = defaultRadius;

  //? Scanner
  static double scannerHeight = 370.h;
  static double scannerWidth = 350.w;

  //? File Picking
  static const int pickedFileSizeLimit = 5;
  static const int pickedFileSizeLimitInBytes = pickedFileSizeLimit * 1024 * 1024;
  static const int pickedImageQuality = 60;
  static const List<String> pickableFilesExtensions = ['jpeg', 'jpg', 'png', 'pdf'];

  //? Api Error Widget
  static double apiErrorWidgetImageSize = 100.r;

  // //? Radio Button

  //? Shop
  static double gapElements = 8.r;
  static double betweenElements = 20.r;
  static double machinePageHeight = 30.h;
  static double heightPromoCode = 54.h;

  //? EditProfile
  static double gapEmptyCard = 36.r;

  //! BETA VERSION
  static double cardRadius = 15.r;
  static double imageRadius = 37.5.r;
  static double historyCardRadius = 16.r;
  static double orderImageRadius = 10.r;
  static double orderImageSize = 50;
  static double userProfileRadius = 36.dm;
}

//? Inputs
class _Buttons {
  _Buttons._();

  //final double radius = 16;

  final elevated = _ElevatedButtons._();
  final text = _TextButtons._();
  final back = _SmallButtons._();
  final floating = _FloatingActionButtons._();
  final oval = _OvalButtons();
  final icon = _IconButtons._();
  final allergies = _AllergiesButtons._();

//! BETA VERSION
  final double radius = 40.r;
  final double radiusShop = 40.r;
}

class _OvalButtons {
  final double width = 100.w;
  final double height = 37.h;
  final double radius = 46.r;
  final double iconSize = 24.r;
}

class _ElevatedButtons {
  _ElevatedButtons._();
  static const _applyElevation = false;
  final double elevation = _applyElevation ? AppConstants.defaultElevation : 0;
  final double height = 54.h;
}

class _TextButtons {
  _TextButtons._();
  final double height = 20.h;
}

class _IconButtons {
  _IconButtons._();

  final double size = 36.r;
  final double iconSize = 20.r;
  final double cartWidth = 24.w;
  final double cartHeight = 21.h;
}

class _SmallButtons {
  _SmallButtons._();
  final double size = 54.r;
  final double radius = 12.r;
  final double iconSize = 23.r;
  final double scanningIconSize = 19.r;
  final double scanningButtonSize = 41.r;
}

class _FloatingActionButtons {
  _FloatingActionButtons._();

  final double size = 48.r;
  final double iconSize = 28.r;
  final double radius = 8.r;
}

class _AllergiesButtons {
  _AllergiesButtons._();
//! BETA VERSION
  final double height = 30.h;
  final double radius = 50.r;

//$ MVP VERSION
  // final double width = 65;
  // final double radius = 20;
}

//? Inputs
class _Inputs {
  _Inputs._();

  final AutovalidateMode inputsAutovalidationMode = AutovalidateMode.disabled;
  // final double radius = 12;
  final double radius = 40.r;
  final double height = 54.h;
  final double descriptionHeight = 140.h;
  final double width = 366.w;
  final double iconSize = 20.r;
  final double horizontalContentPadding = AppConstants.bodyMinSymetricHorizontalPadding;
  final double verticalContentPadding = 15.h;
  final double borderWidth = 1.5.w;
}

//? Bottom Bar
class _BottomBar {
  _BottomBar._();

  final double bottomRadius = 50.r;

  final double height = 65.h +  AppConstants.defaultElevation;

  final double mainButtonSize = 78.r;
  final double secondaryButtonSize = 32.r;
}

//? Recipe Page
class _Recipe {
  _Recipe._();
  final double interactiveIconSize = 16.dm;
  final double mediumIconSize = 20.dm;
  final double iconSize = 28.dm;
}

class _Settings {
  _Settings._();
  final double iconSize = 28.r;
  final double arrowSize = 15.dm;
  final double popUpRadius = 12.r;
  final double supportImgSize = 150.dm;
  final double supportIconSize = 28.dm;
}

//? Gradient Bottom Bar
class _GradientBottomBar {
  _GradientBottomBar._();

  final double gradientBottomBarHeight = 64.h;
  final double gradientBottomBarWeight = 365.7.h;
  final double radius = 10.r;
  final double iconSize = 42.r;
}

//? Pop up Card
class PopUpCard {
  PopUpCard._();

  final double radius = 30.r;
  final double iconSize = 53.r;
}
