import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:hiatunisie/app/style/app_colors.dart';
import 'package:hiatunisie/app/style/app_style.dart';
import 'package:hiatunisie/app/style/font_size.dart';
import 'package:hiatunisie/constant.dart';
import 'package:hiatunisie/viewmodels/market_viewmodel.dart';
import 'package:hiatunisie/views/markets/category_products_screen.dart';
import 'package:hiatunisie/views/markets/product_card.dart';
import 'package:hiatunisie/views/markets/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MarketDetailScreen extends StatefulWidget {
  @override
  _MarketDetailScreenState createState() => _MarketDetailScreenState();
}

class _MarketDetailScreenState extends State<MarketDetailScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketViewModel>(
      builder: (context, marketViewModel, child) {
        if (marketViewModel.selectedMarket == null) {
          return const Scaffold(
            body: Center(child: Text('No market selected')),
          );
        }

        final market = marketViewModel.selectedMarket!;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    expandedHeight: 250.0,
                    pinned: true,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Image.asset('images/left-arrow.png',
                              width: 18.w, height: 18.w),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(90.0),
                          bottomRight: Radius.circular(90.0),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: FastCachedImage(
                                url: market.image ?? '',
                                fit: BoxFit.cover,
                                loadingBuilder: (context, progress) {
                                  return Shimmer(
                                    child: Container(
                                      color: AppColors.unselectedItemShadow,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.7),
                                      Colors.transparent
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 18.0,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Text(
                                    market.name,
                                    style: AppStyles.interSemiBoldTextButton
                                        .withColor(Colors.white)
                                        .withSize(FontSizes.headline3),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Gap(8),
                                  Text(
                                    market.address ?? '',
                                    style: AppStyles.interSemiBoldTextButton
                                        .withColor(Colors.white70)
                                        .withSize(FontSizes.subtitle),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Categories and Products
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: 80.h),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final categoryId = marketViewModel.categories[index];
                          final products = marketViewModel.categoryProducts[categoryId] ?? [];

                          // Skip rendering if the product list is empty
                          if (products.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (index == 0) // Only show the phone button for the first category
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0), // Adjust top padding
                                  child: Center(
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.phone_in_talk_sharp,
                                        color: Color.fromARGB(255, 4, 58, 9),
                                      ),
                                      onPressed: () async {
                                        final phoneNumber = 'tel:${market.phone}';
                                        if (await canLaunchUrlString(phoneNumber)) {
                                          await launchUrlString(phoneNumber);
                                        } else {
                                          throw 'Could not launch $phoneNumber';
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '$categoryId :',
                                      style: AppStyles.interSemiBoldTextButton
                                          .withColor(const Color.fromARGB(255, 0, 0, 0))
                                          .withSize(FontSizes.headline5),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CategoryProductsScreen(
                                              categoryName: categoryId,
                                              products: products,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Tout',
                                        style: AppStyles.interSemiBoldTextButton
                                            .withColor(kMainColor)
                                            .withSize(FontSizes.subtitle),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 200.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  itemCount: products.length,
                                  itemBuilder: (context, productIndex) {
                                    final product = products[productIndex];

                                    return GestureDetector(
                                      onTap: () {
                                        // Navigate to ProductDetailScreen and pass the selected product
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProductDetailScreen(product: product),
                                          ),
                                        );
                                      },
                                      child: ProductCard(product: product),
                                    );
                                  },
                                ),
                              ),
                              const Gap(16),
                            ],
                          );
                        },
                        // Only include categories with at least one product
                        childCount: marketViewModel.categories.where((categoryId) {
                          final products = marketViewModel.categoryProducts[categoryId] ?? [];
                          return products.isNotEmpty;
                        }).length,
                      ),
                    ),
                  ),
                ],
              ),

              // Checkout Button
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 2, 61, 37),
                          Color.fromARGB(255, 14, 70, 44),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        marketViewModel.launchMaps(
                          marketViewModel.selectedMarket!.latitude,
                          marketViewModel.selectedMarket!.langitude,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 30.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Naviguer',
                            style: kTextStyle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
