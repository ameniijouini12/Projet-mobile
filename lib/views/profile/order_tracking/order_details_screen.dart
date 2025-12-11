import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hiatunisie/models/reservation.model.dart';
import 'package:hiatunisie/app/style/app_colors.dart';
import 'package:hiatunisie/app/style/app_style.dart';
import 'package:hiatunisie/app/style/font_size.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:hiatunisie/viewmodels/cart_viewmodel.dart';
import 'package:hiatunisie/viewmodels/market_viewmodel.dart';
import 'package:hiatunisie/widgets/loading_scren_cart_order.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../viewmodels/establishement_viewmodel.dart';
import '../../details/establishment.details.dart';

class OrderDetailScreen extends StatefulWidget {
  final Reservation order;

  const OrderDetailScreen({required this.order, super.key});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
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
    final EstablishmentViewModel establishmentViewModel =
        Provider.of<EstablishmentViewModel>(context, listen: false);
    return Consumer<CartViewModel>(builder: (context, cartViewModel, child) {
      if (cartViewModel.reOrderLoading) {
        return const LoadingScreenCart();
      }
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
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
                          // Ensure that PageView is fully accessible and no other widget blocks it
                          Positioned.fill(
                            child: PageView.builder(
                              key: Key(widget.order.items.length.toString()),
                              controller: _pageController,
                              itemCount: widget.order.items.length,
                              itemBuilder: (context, index) {
                                return FastCachedImage(
                                  url:  widget.order.items[index].offer != null 
                                    ? widget.order.items[index].offer!.image 
                                    : widget.order.items[index].product != null 
                                    ? widget.order.items[index].product!.image
                                    : widget.order.items[index].food!.image,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 250.0,
                                  loadingBuilder: (context, loadingProgress) {
                                    return loadingProgress.isDownloading &&
                                            loadingProgress.totalBytes != null
                                        ? Shimmer(
                                            child: Container(
                                              width: double.infinity,
                                              height: 250.0,
                                              color: AppColors
                                                  .unselectedItemShadow,
                                            ),
                                          )
                                        : const SizedBox(
                                            width: double.infinity,
                                            height: 250.0,
                                          );
                                  },
                                );
                              },
                            ),
                          ),
                          // Ensure this container is not intercepting gestures
                          Positioned.fill(
                            child: IgnorePointer(
                              ignoring: true,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.8),
                                      Colors.transparent
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 18.0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: SmoothPageIndicator(
                                controller: _pageController,
                                count: widget.order.items.length,
                                effect: const WormEffect(
                                    dotHeight: 8.0,
                                    dotWidth: 8.0,
                                    activeDotColor: AppColors.background,
                                    dotColor: Colors.white),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.order.establishment?.name ?? widget.order.market?.name ?? ''
                                        'Order Detail',
                                    style: AppStyles.interSemiBoldTextButton
                                        .black()
                                        .withSize(FontSizes.headline3)
                                        .withColor(AppColors.offWhite),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Gap(15),
                                  GestureDetector(
  onTap: () async {
    if (widget.order.establishment != null) {
      final establishment = establishmentViewModel.establishments.firstWhere(
        (element) => element.id == widget.order.establishment?.id,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EstablishmentDetailsScreen(
            establishment: establishment,
          ),
        ),
      );
    } else if (widget.order.market != null) {
      final market = widget.order.market;
      if (market != null) {
        final marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
        
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Prepare market data
        final success = await marketViewModel.prepareMarketData(market);
        
        // Hide loading indicator
        Navigator.pop(context);

        if (success) {
          // Navigate to detail screen
          Navigator.pushNamed(
            context,
            '/market-detail',
            arguments: market,
          );
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(marketViewModel.error ?? 'Failed to load market data'),
            ),
          );
        }
      }
    }
  },
  child: Text(
    widget.order.establishment != null 
      ? 'See establishment >' 
      : 'See market >',
    style: AppStyles.interSemiBoldTextButton
        .light()
        .withSize(FontSizes.headline6)
        .withColor(AppColors.offWhite),
    textAlign: TextAlign.center,
  ),
),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              widget.order.status == 'Done'
                                  ? Image.asset(
                                      'images/favourite.png',
                                      width: 45.w,
                                      height: 45.w,
                                    )
                                  : Image.asset(
                                      'images/takeaway.png',
                                      width: 45.w,
                                      height: 45.w,
                                    ),
                              const Gap(25),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StatusChip(
                                      status: widget.order.status!,
                                    ),
                                    const Gap(10),
                                    Text(
                                      widget.order.getFormattedDate(),
                                      style: AppStyles.interSemiBoldTextButton
                                          .medium()
                                          .withColor(Colors.black)
                                          .withSize(FontSizes.subtitle)
                                          .bold(),
                                    ),
                                    Gap(2.h),
                                    Text(
                                      "Order Number: ${widget.order.codeReservation}",
                                      style: AppStyles.interSemiBoldTextButton
                                          .regular()
                                          .withColor(Colors.blueGrey)
                                          .withSize(FontSizes.subtitle),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(20),
                        const ZigzagDivider(),
                        const Gap(20),
                        Text(
                          "Your Order",
                          style: AppStyles.interSemiBoldTextButton
                              .black()
                              .withColor(Colors.black)
                              .withSize(FontSizes.headline3),
                        ),
                        const Gap(20),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "${widget.order.items.length} ",
                                style: AppStyles.interSemiBoldTextButton
                                    .regular()
                                    .withColor(Colors.blueGrey)
                                    .withSize(FontSizes.title),
                              ),
                              TextSpan(
                                text: widget.order.items.length == 1
                                    ? "item"
                                    : "items",
                                style: AppStyles.interSemiBoldTextButton
                                    .regular()
                                    .withColor(Colors.blueGrey)
                                    .withSize(FontSizes.title),
                              ),
                              TextSpan(
                                text: " from ",
                                style: AppStyles.interSemiBoldTextButton
                                    .regular()
                                    .withColor(Colors.blueGrey)
                                    .withSize(FontSizes.title),
                              ),
                              TextSpan(
                                text: widget.order.establishment?.name ?? widget.order.market?.name ?? '',
                                style: AppStyles.interSemiBoldTextButton
                                    .medium()
                                    .withColor(Colors.blueGrey)
                                    .withSize(FontSizes.title),
                              ),
                            ],
                          ),
                        ),
                        const Gap(12),
                        _buildOrderItems(),
                        const Gap(80),
                        _buildOrderSteps(),
                        const Gap(120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final cartViewModel =
                          Provider.of<CartViewModel>(context, listen: false);

                      cartViewModel.setReOrderLoading(true);
                      cartViewModel.clearCart();
                     if (widget.order.items.isNotEmpty && widget.order.items.any((item) => item.food != null)) {
  await cartViewModel.addItems(
    widget.order.items.map((item) => item.food!).toList()
  );

  await cartViewModel.overrideEstablishmentId(
    widget.order.establishment?.id ?? widget.order.market?.id ?? '',
  );
} else if (widget.order.items.isNotEmpty && widget.order.items.any((item) => item.product != null)){
   await cartViewModel.addItemsProducts(
    widget.order.items.map((item) => item.product!).toList()
  );

}

                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.background,
                      padding: const EdgeInsets.symmetric(vertical: 11.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35.0),
                      ),
                    ),
                    child: Text(
                      'Re-order',
                      style: AppStyles.interSemiBoldTextButton
                          .withColor(AppColors.offWhite)
                          .withSize(FontSizes.headline5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildOrderSteps() {
    // Replace this with your real data
    final status = widget.order.status;
    final date = widget.order.getFormattedDate();

    //extract from "Aug 23, 2024 | 02:29" to get the date and
    //time of the order
    final dateAndTime = date.split('|');
    final dateOfOrder = dateAndTime[0];
    final timeOfOrder = dateAndTime[1];

    final steps = [
      {
        "status": "Order",
        "time": timeOfOrder,
        "date": dateOfOrder,
        "completed": true,
      },
      {
        "status": "Pending",
        "time": timeOfOrder,
        "date": dateOfOrder,
        "completed": true,
      },
      {
        "status": "Confirmed",
        "time": "",
        "date": "",
        "completed": status == 'Done',
      },
      {
        "status": "Picked up",
        "time": "",
        "date": "",
        "completed": status == 'Done',
      },
    ];

    return Column(
      children: steps.map((step) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Time on the left
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  (step["time"] ?? "").toString(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color:
                        step["completed"] != null ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
            const Gap(10),
            // Dots and line in the center
            Column(
              children: [
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: step["completed"] == true
                        ? AppColors.background
                        : Colors.grey,
                  ),
                ),
                Container(
                  width: 2.w,
                  height: steps.last == step ? 30.h : 70.h,
                  color: step["completed"] == true
                      ? AppColors.background
                      : Colors.grey,
                ),
              ],
            ),
            const Gap(10),
            // Status and date on the right
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (step["status"] ?? "").toString(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: step["completed"] != null
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                    Text(
                      (step["date"] ?? "").toString(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w300,
                        color: step["completed"] != null
                            ? Colors.blueGrey
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildOrderItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.order.items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "${item.quantity}x ",
                      style: AppStyles.interSemiBoldTextButton
                          .regular()
                          .withColor(Colors.black)
                          .withSize(FontSizes.headline6),
                    ),
                    TextSpan(
                      text: item.offer != null  ? item.offer!.name  : item.product != null ? item.product!.name : item.food!.name,

                      style: AppStyles.interSemiBoldTextButton
                          .medium()
                          .withColor(Colors.black)
                          .withSize(FontSizes.title),
                    ),
                  ],
                ),
              ),
              Text(
                "${item.getFormattedPrice()} DT",
                style: AppStyles.interSemiBoldTextButton
                    .regular()
                    .withColor(Colors.black)
                    .withSize(FontSizes.title),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class ZigzagDivider extends StatelessWidget {
  final double height;
  final double width;
  final Color color;

  const ZigzagDivider({
    this.height = 7.0,
    this.width = double.infinity,
    this.color = const Color.fromARGB(224, 215, 215, 215),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _ZigzagPainter(color: color),
    );
  }
}

class _ZigzagPainter extends CustomPainter {
  final Color color;

  _ZigzagPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    final double segmentWidth = size.width / 25;

    for (double x = 0; x < size.width; x += segmentWidth) {
      path.moveTo(x, size.height);
      path.lineTo(x + segmentWidth / 2, 0);
      path.lineTo(x + segmentWidth, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    String icon;
    Color textColor;
    Color iconColor;

    switch (status) {
      case 'Done':
        icon = "food-delivery-64";
        textColor = AppColors.background;
        iconColor = AppColors.background;
        break;
      case 'Pending':
        icon = "pending-64";
        textColor = Colors.orange;
        iconColor = Colors.orange;
        break;
      case 'Confirmed':
        icon = "food-delivery-64";
        textColor = AppColors.background;
        iconColor = AppColors.background;
        break;
      case 'Picked up':
        icon = "food-delivery-64";
        textColor = AppColors.background;
        iconColor = AppColors.background;
        break;
      default:
        icon = "pending-64";
        textColor = Colors.orange;
        iconColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: textColor, width: 1.0),
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'images/$icon.png',
            width: 20.w,
            height: 20.w,
            color: iconColor,
          ),
          const SizedBox(width: 8.0), // Space between icon and text
          Text(
            status,
            style: TextStyle(
              color: textColor, // Dynamic text color based on status
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
