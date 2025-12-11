import 'package:flutter/material.dart';
import 'package:hiatunisie/constant.dart';

class PreferenceChipElement extends StatelessWidget {
  const PreferenceChipElement({
    super.key,
    required this.pref,
  });

  final String pref;

  @override
  Widget build(BuildContext context) {
     final Map<String, String> iconMap = {
      'Fast Food': 'images/cat2.png',
      'Vegan': 'images/cat6.png',
      'Sugar': 'images/cat8.png',
      'Nut-Free': 'images/cat14.png',
      // Add more mappings as needed
    };
    final String iconPath = iconMap[pref] ?? 'assets/default_icon.png';
    final String title = pref;
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: kSecondaryColor.withOpacity(0.1),
              radius: 32.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  height: 38,
                  width: 38,
                  image: AssetImage(iconPath),
                ),
              ),
            ),
            Text(
              title,
              style: kTextStyle.copyWith(color: kTitleColor, fontSize: 13.0),
            ),
          ],
        ),
       
      ],
    );
  }
}
