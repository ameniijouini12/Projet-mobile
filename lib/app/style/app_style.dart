import 'package:flutter/material.dart';
import 'package:hiatunisie/app/style/app_colors.dart';
import 'package:hiatunisie/app/style/app_fonts.dart';
import 'package:hiatunisie/app/style/font_size.dart';



class AppStyles {
  AppStyles._();

  static final interboldHeadline1 = AppFonts.inter.bold().withSize(FontSizes.headline1).withColor(AppColors.offWhite);
  static final interregularTitle = AppFonts.inter.regular().withSize(FontSizes.title).withColor(AppColors.offWhite);
  static final interSemiBoldTextButton = AppFonts.inter.semiBold().withSize(FontSizes.title).withColor(AppColors.offWhite);
  static final interMediumHeadline6 = AppFonts.inter.medium().withSize(FontSizes.headline6).withColor(AppColors.offWhite);
  static final interboldHeadline5 = AppFonts.inter.bold().withSize(FontSizes.headline5).withColor(AppColors.offWhite);
}

extension TextStyleExt on TextStyle {
  TextStyle thin() => copyWith(fontWeight: FontWeight.w100);
  TextStyle extraLight() => copyWith(fontWeight: FontWeight.w200);
  TextStyle light() => copyWith(fontWeight: FontWeight.w300);
  TextStyle regular() => copyWith(fontWeight: FontWeight.w400);
  TextStyle medium() => copyWith(fontWeight: FontWeight.w500);
  TextStyle semiBold() => copyWith(fontWeight: FontWeight.w600);
  TextStyle bold() => copyWith(fontWeight: FontWeight.w700);
  TextStyle extraBold() => copyWith(fontWeight: FontWeight.w800);
  TextStyle black() => copyWith(fontWeight: FontWeight.w900);

  TextStyle withSize(double fontSize) => copyWith(fontSize: fontSize);
  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle withHeight(double height) => copyWith(height: height);
  TextStyle italic() => copyWith(fontStyle: FontStyle.italic);
}
