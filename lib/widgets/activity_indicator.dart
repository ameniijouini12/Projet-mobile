
import 'package:flutter/material.dart';
import 'package:hiatunisie/app/style/app_colors.dart';

class ActivityIndicator extends StatelessWidget {
  const ActivityIndicator({
    super.key,
    this.linear = false,
    this.backgroundColor = AppColors.secondary,
    this.color = AppColors.primary,
  });

  final bool linear;
  final Color backgroundColor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return linear
        ? LinearProgressIndicator(
            minHeight: 1.5,
            backgroundColor: backgroundColor,
            color: color,
          )
        : CircularProgressIndicator(
            strokeWidth: 1.5,
            backgroundColor: backgroundColor,
            color: color,
          );
  }
}
