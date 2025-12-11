import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:hiatunisie/app/style/app_constants.dart';
import 'package:hiatunisie/models/food.model.dart';
import 'package:hiatunisie/viewmodels/review.viewmodel.dart';
import 'package:hiatunisie/views/reviews/review.dart';
import 'package:hiatunisie/widgets/back_row.dart';

import 'package:hiatunisie/app/style/app_style.dart';
import 'package:hiatunisie/app/style/font_size.dart';
import 'package:hiatunisie/app/style/widget_modifier.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:hiatunisie/widgets/custom_toast.dart';
import 'package:hiatunisie/widgets/styled_button.dart';

import '../../app/style/app_colors.dart';



class ReviewScreen extends StatelessWidget {
  final Food food;
  const ReviewScreen({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReviewViewModel(food.id),
      child: Consumer<ReviewViewModel>(
        builder: (context, controller, child) {
          return SmartScaffold(
            backgroundColor: AppColors.background,
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 5.w, top: 15.h),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const BackRow(title: ''),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 15.h),
                              child: Text(
                                food.name,
                                style: AppStyles.interSemiBoldTextButton
                                    .withSize(FontSizes.headline6),
                              ),
                            ),
                          ],
                        ),
                        Gap(20.h),
                        controller.isLoading
                            ? _buildLoadingShimmer()
                            : _buildReviewList(controller),
                        Gap(14.h),
                        controller.isLoading
                            ? _buildLoadingShimmerList()
                            : _buildReviews(controller),
                      ],
                    ),
                  ),
                ),
                _buildAddReviewButton(context, controller),
              ],
            ).customPadding(
              right: AppConstants.bodyMinSymetricHorizontalPadding,
              left: AppConstants.bodyMinSymetricHorizontalPadding,
              top: AppConstants.minBodyTopPadding,
              bottom: AppConstants.bodyMinBottomPadding,
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: kMainColor,
      highlightColor: Colors.green[100]!,
      child: SizedBox(
        height: 100.h,
        width: double.infinity,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewList(ReviewViewModel controller) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ItemRating(ratingNumber: 5, widthRating: 151),
                  ItemRating(ratingNumber: 4, widthRating: 106),
                  ItemRating(ratingNumber: 3, widthRating: 60),
                  ItemRating(ratingNumber: 2, widthRating: 19),
                  ItemRating(ratingNumber: 1, widthRating: 6),
                ],
              ),
              Gap(10.w),
              Column(
                children: [
                  Text(
                    controller.averagereview == 0
                        ? "N/A"
                        : controller.averagereview.toStringAsFixed(1),
                    style: AppStyles.interSemiBoldTextButton
                        .bold()
                        .withSize(FontSizes.splashTitle),
                  ),
                  Gap(8.h),
                  RatingSection(
                    size: 14.r,
                    fromComment: true,
                    ignoreGestures: true,
                    initialRating: controller.averagereview,
                  ),
                  Gap(8.h),
                  Text(
                    "${controller.reviewsProduct.length} Review",
                    style: AppStyles.interSemiBoldTextButton
                        .semiBold()
                        .withSize(FontSizes.title),
                  ),
                ],
              )
            ],
          ).paddingSymmetric(vertical: 20.h, horizontal: 20.w),
        ),
      ],
    );
  }

  Widget _buildLoadingShimmerList() {
    return Column(
      children: List.generate(
        5,
        (index) => Shimmer.fromColors(
          baseColor: kMainColor,
          highlightColor: Colors.green[100]!,
          child: SizedBox(
            height: 100.h,
            width: double.infinity,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviews(ReviewViewModel controller) {
    return Column(
      children: 
      controller.reviewsProduct.isEmpty ?
      [
        Text(
          "No reviews yet",
          style: AppStyles.interSemiBoldTextButton
              .medium()
              .withColor(AppColors.grey)
              .withSize(FontSizes.headline6),
        ),
      ]
      :
      List.generate(
        controller.reviewsProduct.length,
        (index) => Reviewmodel(
          review: controller.reviewsProduct[index],
        ),
      ),
    );
  }

  Widget _buildAddReviewButton(BuildContext context, ReviewViewModel controller) {
    return StyledButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Consumer<ReviewViewModel>(
              builder: (context, controller, child) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Stack(
                    children: [
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: const Color.fromARGB(126, 1, 66, 18),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          alignment: Alignment.center,
                          width: 350.w,
                          height: 549.h,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Gap(24.h),
                              Text(
                                controller.rating.toStringAsFixed(1),
                                style: AppStyles.interregularTitle
                                    .withSize(48)
                                    .copyWith(
                                        decoration: TextDecoration.none),
                              ),
                              RatingSection(
                                size: 30.r,
                                ignoreGestures: false,
                                initialRating: controller.rating,
                              ),
                              Gap(13.h),
                              Text(
                                "Take a moment to rate your experience with ${food.name} 😀",
                                textAlign: TextAlign.center,
                                style: AppStyles.interSemiBoldTextButton
                                    .medium()
                                    .withColor(AppColors.grey)
                                    .withSize(FontSizes.headline6)
                                    .copyWith(
                                        decoration: TextDecoration.none),
                              ),
                              Gap(36.h),
                              Material(
                                color: Colors.transparent,
                                child: Container(
                                  width: double.infinity,
                                  height: 103,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryBackground,
                                    border: Border.all(
                                        color: AppColors.background,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: TextField(
                                    style: AppStyles.interSemiBoldTextButton
                                        .medium(),
                                    keyboardType: TextInputType.multiline,
                                    controller: controller.commentController,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 10.w),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      hintText: 'Enter here',
                                      hintStyle: AppStyles
                                          .interSemiBoldTextButton
                                          .medium()
                                          .withColor(Colors.grey[200]!)
                                          .withSize(FontSizes.headline6),
                                    ),
                                  ),
                                ),
                              ),
                              Gap(24.h),
                              StyledButton(
                                onPressed: () async {
                                  await controller.addReview(food.id);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  showCustomToast(
                                    context,
                                    "Your review has been added successfully",);
                                },  
                                style: ButtonStyles.primary,
                                title: 'Submit',
                              ),
                              Gap(24.h),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Cancel",
                                  style: AppStyles.interSemiBoldTextButton
                                      .medium()
                                      .withSize(FontSizes.headline4)
                                      .copyWith(
                                          decoration: TextDecoration.none),
                                ),
                              ),
                            ],
                          ).paddingSymmetric(horizontal: 23.w),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
      style: ButtonStyles.primary,
      title: 'Add review',
    );
  }
}







