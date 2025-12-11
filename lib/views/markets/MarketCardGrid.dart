import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hiatunisie/app/style/app_colors.dart';
import 'package:hiatunisie/app/style/app_constants.dart';
import 'package:hiatunisie/app/style/app_style.dart';
import 'package:hiatunisie/constant.dart';
import 'package:hiatunisie/models/market.model.dart';
import 'package:hiatunisie/viewmodels/market_viewmodel.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Marketcardgrid extends StatelessWidget {
  const Marketcardgrid({
    super.key, 
    required this.restaurantData, 
    this.isGrid = false, 
    required this.index,
  });

  final Market restaurantData;
  final int index;
  final bool isGrid;

  String _formatText(String text) {
    const int maxChars = 20; // Maximum number of characters allowed
    if (text.length > maxChars) {
      return "${text.substring(0, maxChars)}...";
    }
    return text;
  }
  String _truncateText(String text, int maxLength) {
  if (text.length > maxLength) {
    return '${text.substring(0, maxLength)}..';
  }
  return text;
}


  @override
  Widget build(BuildContext context) {
    final marketViewModel = Provider.of<MarketViewModel>(context);
    return SizedBox(
      width: isGrid ? 180.w : 320.w, // Adjust width for grid
      height: isGrid ? 190.h : 248.h, // Adjust height for grid
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.background.withOpacity(0.1),
              offset: const Offset(0, 5),
              blurRadius: 1,
              spreadRadius: 1,
              blurStyle: BlurStyle.inner,
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section with Image and Title
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    width: double.infinity,
                    height: isGrid ? 90.h : 150.h, // Adjust image height for grid
                    imageUrl: restaurantData.image!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey.shade300,
                          Colors.grey.shade100,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      child: Container(
                        height: isGrid ? 100.h : 150.h,
                        width: double.infinity,
                        color: AppColors.background,
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
                      height: isGrid ? 30.h : 50.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(8),

            // Bottom Section with Details
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 8.w),
                      Text(
                        _formatText(restaurantData.name),
                        style: AppStyles.interboldHeadline1
                            .withSize(isGrid ? 13.sp : 15.sp)
                            .withColor(AppColors.background),
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                  const Gap(6),
                  RichText(
                    text: TextSpan(
                      children: [
                        const WidgetSpan(
                          child: Icon(
                            Icons.location_on_outlined,
                            color: kGreyTextColor,
                            size: 15.0,
                          ),
                        ),
                       TextSpan(
  text: _truncateText(restaurantData.address!, 14),
  style: kTextStyle.copyWith(color: kGreyTextColor),
),

                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Gap(4),
                          const SizedBox(height: 6),
                          marketViewModel.isCalculating
                              ? const SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : RichText(
                                  text: TextSpan(
                                    children: [
                                      const WidgetSpan(
                                        child: Icon(
                                          Icons.location_on,
                                          color: kMainColor,
                                          size: 15.0,
                                        ),
                                      ),
                                      TextSpan(
  text: index < marketViewModel.distances.length 
      ? "${marketViewModel.distances[index].toStringAsFixed(1).length > 4 
          ? marketViewModel.distances[index].toStringAsFixed(1).substring(0, 4) + '..'
          : marketViewModel.distances[index].toStringAsFixed(1)} km"
      : "N/A",
  style: kTextStyle.copyWith(
    color: kGreyTextColor,
  ),
),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0, bottom: 4.0),
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: kMainColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            'Checkout',
                            style: kTextStyle.copyWith(color: Colors.white),
                          ),
                        ).onTap(() {
                          marketViewModel.launchMaps(
                              restaurantData.latitude, restaurantData.langitude);
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}