
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hiatunisie/app/style/app_style.dart';
import 'package:hiatunisie/app/style/font_size.dart';

class BackRow extends StatelessWidget {
  const BackRow({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:const  Icon(
            Icons.arrow_back_ios,
            size: 28,
            color: Colors.white,
          ),
        ),
        const Gap(18),
        Text(
          title,
          style: AppStyles.interSemiBoldTextButton.medium().withSize(FontSizes.headline3),
        )
      ],
    );
  }
}
