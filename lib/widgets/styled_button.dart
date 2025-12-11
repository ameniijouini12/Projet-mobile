// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:hiatunisie/app/style/app_colors.dart';
import 'package:hiatunisie/app/style/app_style.dart';
import 'package:hiatunisie/app/style/font_size.dart';
import 'package:hiatunisie/app/style/widget_modifier.dart';
import 'package:hiatunisie/constant.dart';
import 'package:hiatunisie/widgets/activity_indicator.dart';


class StyledButton extends StatelessWidget {
  const StyledButton({
    super.key,
    this.reversed = false,
    required this.style,
    required this.title,
    this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.isSocial = false,
    this.isFromRecipe = false,
    this.isStep = false,
  });

  final bool reversed;
  final ButtonStyles style;
  final String title;
  final Widget? icon;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final bool isSocial;
  final bool isFromRecipe;
  final bool isStep;

  @override
  Widget build(BuildContext context) {
    final _icon = icon?.visibleWhen(!isLoading) ?? const SizedBox.shrink();
    final _label = isLoading
        ? ActivityIndicator(
            backgroundColor: style.borderColor,
            color: AppColors.accent,
          ).squared(side: 18)
        : Text(title,
            style: isFromRecipe
                ? AppStyles.interboldHeadline1.withSize(FontSizes.headline5)
                : isStep
                    ? AppStyles.interSemiBoldTextButton.withSize(FontSizes.headline6).withColor(style.textColor).medium()
                    : isSocial
                        ? AppStyles.interregularTitle.withSize(FontSizes.headline6).withColor(style.textColor).medium()
                        : AppStyles.interSemiBoldTextButton.withSize(FontSizes.headline4).withColor(style.textColor));
    final side = WidgetStateProperty.resolveWith<BorderSide?>((states) {
      if (isFromRecipe) {
        return const BorderSide(
          color: AppColors.offBlack,
          width: 2.0,
        );
      } else if (style.borderWidth > 0) {
        return BorderSide(
          color: style.borderColor,
          width: style.borderWidth,
        );
      }
      return BorderSide.none;
    });

    final shadowColor = WidgetStateProperty.resolveWith<Color>((states) {
      if (isFromRecipe) {
        return Colors.black;
      }
      return style.borderColor;
    });

    return Container(
      padding: const EdgeInsets.only(bottom: 4,),
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              overlayColor: WidgetStateProperty.all(AppColors.overlayColor),
              backgroundColor: WidgetStateProperty.all(!isDisabled ? style.backgroundColor : AppColors.inactive),
              foregroundColor: WidgetStateProperty.all(style.textColor),
              elevation: !isFromRecipe ? WidgetStateProperty.all(1) : WidgetStateProperty.all(4),
              shadowColor: shadowColor,
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  side: BorderSide(width: style.borderWidth, color: style.borderColor),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
              ),
              side: side,
            ),
        icon: reversed ? _label.customPadding(left: 16) : _icon,
        label: reversed ? _icon : _label,
      ).visibleWhen(true),
    );
  }
}

enum ButtonStyles {
  primary(
    textColor: kMainColor,
    backgroundColor: AppColors.primary,
    borderColor: AppColors.inputColor,
    borderWidth: 0,
  ),
  secondary(
    textColor: AppColors.secondary,
    backgroundColor: AppColors.scaffold,
    borderColor: AppColors.secondary,
    borderWidth: 2,
  ),
  tetiary(
    textColor: AppColors.remove,
    backgroundColor: AppColors.scaffold,
    borderColor: AppColors.remove,
    borderWidth: 1.5,
  ),

  inactif(
    textColor: AppColors.inputColor,
    backgroundColor: AppColors.inactive,
    borderColor: AppColors.inactive,
    borderWidth: 0,
  ),

  social(
    textColor: AppColors.blackTitleButton,
    backgroundColor: Colors.white,
    borderColor: AppColors.blackTitleButton,
    borderWidth: 1.5,
  ),

  issue(
    textColor: AppColors.primary,
    backgroundColor: AppColors.inputColor,
    borderColor: AppColors.inputColor,
    borderWidth: 0,
  ),
  shop(
    textColor: AppColors.offBlack,
    backgroundColor: AppColors.sea,
    borderColor: AppColors.inputColor,
    borderWidth: 0,
  ),

  ingredient(
    // textColor: Colors.white,
    // backgroundColor: Colors.black,
    // borderColor: Colors.black,
    textColor: AppColors.offWhite,
    backgroundColor: AppColors.inputColor,
    borderColor: AppColors.inputColor,
    borderWidth: 1,
  );

  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;

  const ButtonStyles({
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
  });
}
