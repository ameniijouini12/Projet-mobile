import 'package:flutter/material.dart';
import 'package:hiatunisie/constant.dart';
import 'filter_data.dart';

class FilterChipElement extends StatelessWidget {
  const FilterChipElement({
    super.key,
    required this.catList,
    required this.onRemove,
  });

  final FilterData catList;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: kSecondaryColor.withOpacity(0.2),
              radius: 30.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage(catList.catIcon),
                ),
              ),
            ),
            Text(
              catList.catTitle,
              style: kTextStyle.copyWith(color: kTitleColor, fontSize: 12.0),
            ),
          ],
        ),
        Positioned(
          right: 1,
          top: 1,
          child: InkWell(
            onTap: onRemove,
            child: const CircleAvatar(
              backgroundColor: Colors.red,
              radius: 8,
              child: Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
