import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

//! BETA VERSION 01
  static const Color scaffold = Color(0xFF00002D);
  static const Color background = Color(0xFF00643c); 
  static const secondaryBackground = Color.fromARGB(255, 2, 138, 83);
  static const selectTabColor = Color.fromARGB(255, 7, 189, 116);

  static const Color primary = Color(0xFF00FFC5);
  static const Color secondary = Color(0xFF4932D9);
  static const Color accent = Color(0xFFEAA677);
  static const Color greenDark = Color(0xFF005950);

  static const Color grey = Color(0xFFA7AFB7);
  static const Color greyRegular = Color(0xC0A7AfB7);

  static const Color inactive = Color(0x9900FFC5);

  static const Color inputColor = Color(0xFF1B2D51);
  static const Color blackTitleButton = Color(0xFF1B232A);

  static const Color red = Color(0xFFFF6156);
  static const Color orange = Color(0xFFFF6D00);
  static const Color sea = Color(0xFF00FFC5);

  static const Color offBlack = Color(0xFF00002d);
  static const Color offWhite = Color(0xFFF6F3F4);
  static const Color whiteProfile = Color(0xFFF8F8F8);

  static const Color unselectedItemShadow = Color(0x4000ffc5);

  static const Color yellow = Color(0xFFfabf35);

  static const Color bluredBackground = Color(0xB3344054);

  static LinearGradient gradientScaffold = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      scaffold.withOpacity(1),
      const Color(0xFF1B2D51).withOpacity(0),
    ],
  );

  static LinearGradient settingsGradientClr = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFF222222).withOpacity(0.08),
      const Color(0xff0f0f0f).withOpacity(0.22),
    ],
  );

  static LinearGradient settingsBorderClr = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFFffffff).withOpacity(1),
      const Color(0xFFffffff).withOpacity(0),
      const Color(0xFFffffff).withOpacity(1),
    ],
  );

  static LinearGradient accountGradientClr = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFF222222).withOpacity(0.08),
      const Color(0xFF0E0E0E).withOpacity(0.22),
    ],
  );

  static LinearGradient accountBorderClr = LinearGradient(
    begin: const Alignment(-0.06, -0.17),
    end: const Alignment(0.66, 2.38),
    colors: [
      Colors.white.withOpacity(0.3), // Opaque white (start point)
      Colors.white.withOpacity(0), // Fully transparent white (mid-point)
      Colors.white.withOpacity(1), // Opaque white (end point)
    ],
  );

  static LinearGradient editGradientClr = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.white.withOpacity(1),
      Colors.white.withOpacity(0),
      // Opaque white (end point)
    ],
  );

  //$ MVP VERSION
  //static const Color primary = Color(0xFF0A1B3D);
  //static const Color secondary = Color(0xFF34D945);
  //static const Color accent = Color(0xFF27A042);
  //static const Color greenDark = Color(0xFF2D8F4A);
  static const Color greenLight = Color(0xFFCBEDB8);
  static const Color greenLighter = Color(0xFFD3F5BD);

  static const Color lightGrey = Color(0xFFECECEC);

  static const Color greyDarker = Color(0xFF51545B);
  static const Color greyDark = Color(0xFF9EA0A5);
  //static const Color grey = Color(0xFFA7AFB7);
  //static const Color greyRegular = Color(0xFFBDBDBD);
  static const Color greyLight = Color(0xFFc2c4cb);
  static const Color greyLighter = Color(0xFFD9D9D9);
  static const Color greyBackground = Color(0xFFF3F5F7);
  static const Color blueDark = Color(0xFF0E2C3D);
  static const Color purple = Color(0xFF4932D9);
  //static const Color inputColor = Color(0xFF1B2D51);
  static const Color inputBorder = Color(0xFF98C4DE);

  //static const Color offBlack = Color(0xFF1D1D1F);
  //static const Color offWhite = Color(0xFFFAFAFC);
  //static const Color blackTitleButton = Color(0xFF1B232A);
  static const Color darkBackIcon = Color(0xFF1E232C);
  static const Color orangeColor = Color(0xFFff6b00);

  static const Color neutralLinkDotsColor = Color(0xFF92B6D9);

  static const Color blueDot = Color(0xFF3291D9);

  static const Color moreOptions = Color(0xFF2cad5e);

  static const Color blurColor = Color.fromRGBO(41, 39, 130, 0.1);

  static const Color settingsBottomSheet = Color(0xFF1E1E3A);

  static const Color shoppingBottomSheet = Color(0xFF7c7c7c);

  static const Color gradientBarBorderClr = Color(0xFF98F9FF);

  static const shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );

  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment(-0.0777, 0.0),
    end: Alignment(1.265, 0.0),
    colors: [
      Color(0xFF34D945),
      Color.fromRGBO(52, 217, 69, 0.27),
    ],
    stops: [-0.0777, 1.265],
  );
  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment(-0.0777, 0.0),
    end: Alignment(1.265, 0.0),
    colors: [
      Color.fromRGBO(146, 182, 217, 0.50),
      Color(0xFF171C22),
    ],
    stops: [-0.0777, 1.265],
  );
  static const LinearGradient plusMinusButtonBorderGradient = LinearGradient(
    begin: Alignment(-7.77, 0.0),
    end: Alignment(1.265, 0.0),
    colors: [
      Color.fromRGBO(85, 85, 85, 0.08),
      Color.fromRGBO(15, 15, 15, 0.22),
    ],
  );
  static const LinearGradient backButtonBorderGradient = LinearGradient(
    begin: Alignment(-30.29, 0.0),
    end: Alignment(1.4492, 0.0),
    colors: [
      Color.fromRGBO(255, 255, 255, 0.03),
      Color.fromRGBO(255, 255, 255, 0.00),
    ],
  );
  static const RadialGradient thirdRadialGradient = RadialGradient(
    center: Alignment(15.32, 21.04),
    radius: 1.5192,
    colors: [
      Color.fromRGBO(165, 239, 255, 0.20),
      Color.fromRGBO(110, 191, 244, 0.04),
      Color.fromRGBO(70, 144, 212, 0.00),
    ],
    stops: [0.0, 0.7708, 1.0],
  );
  static const LinearGradient scanningOptionsGradientBox = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(165, 239, 255, 0.20),
      Color.fromRGBO(110, 191, 244, 0.04),
      Color.fromRGBO(70, 144, 212, 0.00),
    ],
    stops: [0.0, 0.7708, 1.0],
  );

  static const LinearGradient greyGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0x55555566),
      Color(0x0F0F0F6B),
    ],
  );

  static const LinearGradient spirulinaConsumedBG = LinearGradient(
    begin: Alignment(0.946, 0.154),
    end: Alignment(0.094, 0.953),
    colors: [
      Color.fromRGBO(34, 34, 34, 0.08),
      Color.fromRGBO(15, 15, 15, 0.22),
    ],
  );

  static LinearGradient productGradientBackground = const LinearGradient(
    begin: Alignment(-1.0, -7.77),
    end: Alignment(0.0, 1.265),
    colors: [
      Color.fromRGBO(246, 243, 244, 0.8),
      Color.fromRGBO(15, 15, 15, 0.22),
    ],
    stops: [0.0, 1.0],
  );

  static LinearGradient productGradientBorder = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      offWhite.withOpacity(0.29),
      const Color(0x4affffff).withOpacity(0.5),
    ],
  );

  static const LinearGradient darkGreyGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0x55555566),
      Color(0x0F0F0F38),
    ],
  );
  static const LinearGradient growthGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF2E8F4A),
      Color(0x00DB74CC),
      Color(0x99D3F5BD),
      Color(0xFFD3F5BD),
    ],
  );
  static const LinearGradient dailyPercentageBorderGradient = LinearGradient(
    begin: Alignment(0.27, 0.0),
    end: Alignment(1.0, 0.0),
    colors: [
      Color.fromRGBO(34, 34, 34, 0.08),
      Color.fromRGBO(15, 15, 15, 0.22),
    ],
    stops: [0.0461, 0.9539],
  );
  static const LinearGradient customLinearGradient = LinearGradient(
    begin: Alignment(-0.0777, 0.0),
    end: Alignment(1.265, 0.0),
    colors: [
      Color.fromRGBO(255, 255, 255, 0.26),
      Color.fromRGBO(255, 255, 255, 0.09),
    ],
    stops: [-0.0777, 1.265],
  );

  static LinearGradient incompletedDoseCardGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(146, 182, 217, 0.5),
      Color.fromRGBO(23, 28, 34, 1),
    ],
  );
  static LinearGradient incompletedDoseCardBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFF555555).withOpacity(0.5),
      const Color((0xFF555555)).withOpacity(0.5),
    ],
  );

  static LinearGradient completedDoseCard = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(52, 217, 69, 1),
      Color.fromRGBO(52, 217, 69, 0.27),
    ],
  );

  static const LinearGradient bottomBarGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(22, 28, 34, 0.00),
      inputColor,
    ],
  );

  static LinearGradient categoriesBarGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(27, 45, 81, 0.00),
      inputColor,
    ],
    stops: [0.2083, 1.0],
  );

  static LinearGradient dozesIconGradientColor = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color.fromRGBO(85, 85, 85, 0.40),
      Color.fromRGBO(15, 15, 15, 0.42),
    ],
    stops: [-0.0777, 1.265],
    transform: GradientRotation(100 * (3.1415926535 / 180)),
  );

  static const LinearGradient bottomBarColor = bottomBarGradient;

  static LinearGradient recipeDetailsGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color.fromRGBO(9, 21, 72, 0.199), Color.fromRGBO(134, 254, 236, 0.000)],
  );

  static const LinearGradient recipeDetailsGradientBorder = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(255, 255, 255, 0.900),
      inputColor,
    ],
  );

  static const Color activeToggleButton = Color(0xFF31B947);
  static const Color inactiveToggleButtonColor = Color(0xFFE5E5E5);
  static const Color hint = Color(0xFFF5F5F5);
  static const Color label = grey;
  static const Color boxShadow = Color.fromRGBO(84, 84, 84, 0.21);
  static const Color greenBoxShadow = Color.fromRGBO(52, 217, 69, 0.45);
  static const Color overlayColor = Color(0x0D063048);

  static const Color remove = Color(0xFFFF3B30);

  static const Color transparent = Colors.transparent;

  static const Color transparentBlue = Color.fromRGBO(4, 11, 24, 0.39);
  static const Color transparentGreen = Color.fromRGBO(52, 217, 69, 0.1);
}
