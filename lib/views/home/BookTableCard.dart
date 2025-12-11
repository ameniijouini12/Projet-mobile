import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiatunisie/app/style/app_constants.dart';
import 'package:hiatunisie/constant.dart';
import 'package:hiatunisie/models/establishement.model.dart';

import 'package:shimmer/shimmer.dart';

import '../../app/style/app_colors.dart';
import '../../app/style/app_style.dart';

class BookTableCard extends StatelessWidget {
  const BookTableCard({
    super.key,
    required this.establishment,
    required this.index,
  });

  final Establishment establishment;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 280.0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      width: double.infinity,
                      height: 100.0,
                      imageUrl: establishment.image ?? "",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.grey, Colors.white],
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 100.0,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                    // Gradient Overlay at the bottom of the image
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40.0, // Adjust gradient height if needed
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha:0.6),
                              Colors.transparent
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    // Badge Icon at the top right corner
                    if (establishment.averageRating! >= 5)
                      Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration:  BoxDecoration(
                              color:
                              Colors.blueGrey.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              "images/prime_icon.png",
                              width:  25,
                              height: 25,
                            ),
                          )
                      ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        establishment.name,
                        style: AppStyles.interregularTitle
                            .medium()
                            .withColor(kTitleColor)
                            .withSize(16.sp),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'images/location_icon.png',
                            width: 20.0,
                            height: 20.0,
                          ),
                          const SizedBox(width: 4),
                          // Ellipsis-enabled city text
                          SizedBox(
                            width: 120, // You can adjust width as needed
                            child: Text(
                              establishment.city ?? "",
                              style: kTextStyle.copyWith(color: kGreyTextColor),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '(${establishment.averageRating})',
                              style: kTextStyle.copyWith(color: kGreyTextColor),
                            ),
                            const WidgetSpan(child: SizedBox(width: 2.0)),
                            WidgetSpan(
                              child: establishment.averageRating! >= 5
                                  ? Image.asset(
                                'images/icon_rate2.png',
                                width: 20.0,
                                height: 20.0,
                              )
                                  : Image.asset(
                                'images/icon_rate1.png',
                                width: 20.0,
                                height: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    StatusChipOpenedClosed(
                      status: establishment.isOpened ? 'Opened' : 'Closed',
                    ),
                  ],
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}

class StatusChipOpenedClosed extends StatelessWidget {
  final String status;

  const StatusChipOpenedClosed({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    String icon;
    Color textColor;

    switch (status) {
      case 'Opened':
        icon = "open_icon";
        textColor = AppColors.background;
        break;
      case 'Closed':
        icon = "closed_icon";
        textColor = AppColors.red;
        break;
      default:
        icon = "pending-64";
        textColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      decoration: BoxDecoration(
        border: Border.all(color: textColor, width: 1.0),
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'images/$icon.png',
            width: 16.w,
            height: 16.w,
          ),
          const SizedBox(width: 8.0), // Space between icon and text
          Text(
            status,
            style: TextStyle(
              color: textColor, // Dynamic text color based on status
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}