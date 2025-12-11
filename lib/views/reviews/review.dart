
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:hiatunisie/app/style/app_colors.dart';
import 'package:hiatunisie/app/style/app_constants.dart';
import 'package:hiatunisie/app/style/app_style.dart';
import 'package:hiatunisie/app/style/font_size.dart';
import 'package:hiatunisie/models/establishement.model.dart';
import 'package:hiatunisie/viewmodels/review.viewmodel.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:icon_decoration/icon_decoration.dart';

class Reviewmodel extends StatelessWidget {
 final Review review;

  const Reviewmodel({super.key, required this.review});

  
  @override
  Widget build(BuildContext context) {

    //shimer effect for loading

    return Column(
      children: [
        Row(
          children: [
            ClipOval(
               child: SizedBox(
                height: 38.r,
                width: 38.r,
                child: CachedNetworkImage(
                    imageUrl: review.user.profileImage ?? '',
                    imageBuilder: (context, imageProvider) => ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image(
                        image: imageProvider,
                        height: 38.r,
                        width: 38.r,
                        fit: BoxFit.cover,
                      ),
                    ),
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                      height: 38.r,
                        width: 38.r,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => SizedBox(
                      height: 40.r,
                      width: 40.r,
                      child: CircleAvatar(
                        radius: AppConstants.imageRadius,
                        backgroundColor: AppColors.greenDark,
                        child: Text(
                          review.user.firstName.substring(0, 1).toUpperCase(),
                          style: AppStyles.interboldHeadline1
                              .light()
                              .withSize(20.sp),
                        ),
                      ),
                    ),
                  ),
              ),
            ),
            Gap(8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.user.lastName,
                  style: AppStyles.interSemiBoldTextButton
                      .medium()
                      .withSize(FontSizes.headline6),
                ),
                Row(
                  children: [
                    RatingSection(
                      size: 14.r,
                      fromComment: true,
                      initialRating: review.rating.toDouble(),
                      ignoreGestures: true,
                    ),
                    
                  ],
                )
              ],
            )
          ],
        ),
        Gap(12.h),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            review.comment ?? '',
            textAlign: TextAlign.start,
            style: AppStyles.interSemiBoldTextButton
                .medium()
                .withSize(FontSizes.headline6),
          ),
        ),
        Gap(24.h),
        Container(
          width: double.infinity,
          height: 1.h,
          decoration: const BoxDecoration(color: AppColors.primary),
        )
      ],
    ).marginSymmetric(vertical: 10.h);
  }
}

// ignore: must_be_immutable
class RatingSection extends StatelessWidget {
  RatingSection(
      {super.key, required this.size,
      this.fromComment,
      this.initialRating,
      required this.ignoreGestures});
  final double size;
  final double? initialRating;
  bool ignoreGestures = false;
  bool? fromComment = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewViewModel>(
      builder: (context, reviewViewModel, child) {
        return RatingBar(
          initialRating: fromComment == true ? initialRating!.toDouble() : reviewViewModel.rating,
          itemSize: size,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemPadding: EdgeInsets.only(right: 5.w),
          itemCount: 5,
          ignoreGestures: ignoreGestures,
          ratingWidget: RatingWidget(
            full: DecoratedIcon(
              icon: const Icon(
                Icons.star,
                color: AppColors.yellow,
              ),
              decoration: IconDecoration(
                border: IconBorder(
                  color: AppColors.yellow,
                  width: 2.w,
                ),
              ),
            ),
            half: DecoratedIcon(
              icon: const Icon(
                Icons.star,
                color: AppColors.yellow,
              ),
              decoration: IconDecoration(
                border: IconBorder(
                  color: AppColors.yellow,
                  width: 2.w,
                ),
              ),
            ),
            empty: DecoratedIcon(
              icon: const Icon(
                Icons.star,
                color: AppColors.secondaryBackground,
              ),
              decoration: IconDecoration(
                border: IconBorder(
                  color: AppColors.yellow,
                  width: 2.w,
                ),
              ),
            ),
          ),
          onRatingUpdate: (rating) {
            reviewViewModel.updateRating(rating);
          },
        );
      },
    );
  }
}

class ItemRating extends StatelessWidget {
  const ItemRating(
      {super.key, required this.ratingNumber, required this.widthRating});
  final int ratingNumber;
  final double widthRating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          ratingNumber.toString(),
          style: AppStyles.interSemiBoldTextButton
              .medium()
              .withSize(FontSizes.title),
        ),
        Gap(4.w),
        Icon(
          Icons.star,
          color: AppColors.yellow,
          size: 16.r,
        ),
        Gap(4.w),
        Container(
          height: 6.h,
          width: widthRating.w,
          decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(4)),
        )
      ],
    ).marginOnly(bottom: 4.h);
  }
}