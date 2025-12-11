import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiatunisie/models/reservation.model.dart';
import 'package:hiatunisie/viewmodels/cart_viewmodel.dart';
import 'package:hiatunisie/viewmodels/reservation_viewmodel.dart';
import 'package:hiatunisie/views/card/cart_screen.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:hiatunisie/app/style/app_colors.dart';
import 'package:hiatunisie/app/style/app_constants.dart';
import 'package:hiatunisie/app/style/app_style.dart';
import 'package:hiatunisie/app/style/font_size.dart';
import 'package:hiatunisie/app/style/widget_modifier.dart';
import 'package:hiatunisie/views/home/home.dart';
import 'package:hiatunisie/views/profile/order_tracking/order_details_screen.dart';
import 'package:hiatunisie/views/reviews/review_screen.dart';
import 'package:hiatunisie/widgets/loading_scren_cart_order.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserViewModel>(context).userData!.id;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReservationViewModel()..getMyReservations(userId)),
      ],
      child: Consumer<CartViewModel>(
        builder: (context, cartViewModel, child) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: AppColors.background,
                body: Column(
                  children: [
                    AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
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
                    title: Row(
                      children: [
                        Text(
                          'Historique des commandes',
                          style: AppStyles.interboldHeadline5
                              .medium()
                              .withColor(Colors.white.withValues(alpha:0.9)),
                        ),
                      ],
                    ),
                  ),
                    Gap(AppConstants.verticalSpacing),
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: "En attente"),
                        Tab(text: "Terminé"),
                      ],
                      labelColor: AppColors.selectTabColor,
                      unselectedLabelColor: AppColors.offWhite,
                      indicatorColor: AppColors.selectTabColor,
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildOrderList(context, "Pending"),
                          _buildOrderList(context, "Done"),
                        ],
                      ),
                    ),
                  ],
                ).paddingSymmetric(
                  horizontal: AppConstants.bodyMinSymetricHorizontalPadding,
                  vertical: AppConstants.minBodyTopPadding,
                ),
                floatingActionButton: Consumer<ReservationViewModel>(
                  builder: (context, orderHistoryViewModel, child) {
                    return Visibility(
                      visible: orderHistoryViewModel.myReservation.isEmpty && !orderHistoryViewModel.isLoading,
                      child: IconButton(
                        color : Colors.white,
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home(initialIndex: 0,)));
                          },
                          icon: Icon (
                            Icons.home,
                            color: AppColors.offWhite,
                            size: 30.sp,
                          )),
                    );
                  },
                ),
              ),
              if (cartViewModel.reOrderLoading)
                const LoadingScreenCart(),
            ],
          );
        },
      ),
    );
  }
  Widget _buildOrderList(BuildContext context, String status) {
    return Consumer<ReservationViewModel>(
      builder: (context, orderHistoryViewModel, child) {
        if (orderHistoryViewModel.isLoading) {
          return _buildShimmerEffect();
        }

        final orders = orderHistoryViewModel.myReservation.where((order) => order.status == status).toList();

        if (orders.isEmpty) {
          return const _EmptyHistory().center();
        }

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return _HistoryItem(order: orders[index]);
          },
        );
      },
    );
  }

   Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: kMainColor,
          highlightColor: Colors.green[100]!,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.historyCardRadius),
              gradient: AppColors.accountGradientClr,
              border: Border.all(color: Colors.blueGrey, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Container(
                        width: AppConstants.orderImageSize,
                        height: AppConstants.orderImageSize,
                        color: Colors.white,
                      ),
                    ),
                    Gap(16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100.w,
                          height: 20.h,
                          color: Colors.white,
                        ),
                        Gap(5.w),
                        Container(
                          width: 60.w,
                          height: 15.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
                Gap(AppConstants.verticalSpacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 80.w,
                      height: 20.h,
                      color: Colors.white,
                    ),
                    Container(
                      width: 60.w,
                      height: 20.h,
                      color: Colors.white,
                    ),
                  ],
                ),
                Gap(10.h),
                const ZigzagDivider(color: Colors.blueGrey),
                Gap(12.h),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(1, (index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 5.h),
                          width: 150.w,
                          height: 15.h,
                          color: Colors.white,
                        );
                      }),
                    ),
                  ],
                ),
                Gap(10.h),
                Divider(color: Colors.blueGrey, thickness: 2.r),
                
              ],
            ).paddingSymmetric(
              horizontal: AppConstants.bodyMinSymetricHorizontalPadding,
              vertical: 16.h,
            ),
          ).paddingOnly(bottom: AppConstants.verticalSpacing),
        );
      },
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "images/emptyCard.png",
          width: 80.w,
          height: 80.w,
        ),
        Gap(AppConstants.verticalSpacing),
        Text(
          "Pas d'historique de commande",
          style: AppStyles.interSemiBoldTextButton.regular().withSize(FontSizes.headline5),
        ),
        Gap(12.h),
      ],
    ).paddingSymmetric(vertical: MediaQuery.of(context).size.height / 4);
  }
}

class _HistoryItem extends StatelessWidget {
  final Reservation order;
  const _HistoryItem({required this.order});

  @override
  Widget build(BuildContext context) {
    final formattedDate = order.date != null ? order.date!.toLocal().toString().split(" ")[0] : "";

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailScreen(order: order))),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.historyCardRadius),
          gradient: AppColors.accountGradientClr,
          border: Border.all(color: Colors.blueGrey, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Container(
                    width: AppConstants.orderImageSize,
                    height: AppConstants.orderImageSize,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: FastCachedImage(
                     url: order.establishment?.image ?? order.market?.image ?? "",
                      fit: BoxFit.cover,
                      width: 40.w,
                      height: 40.h,
                      loadingBuilder: (context, loadingProgress) {
                        return loadingProgress.isDownloading && loadingProgress.totalBytes != null
                            ? Shimmer(
                                gradient: AppColors.shimmerGradient,
                                child: Container(
                                  width: 40.w,
                                  height: 40.h,
                                  color: AppColors.unselectedItemShadow,
                                ),
                              )
                            : SizedBox(
                                width: 40.w,
                                height: 40.h,
                              );
                      },
                    ),
                  ),
                ),
                Gap(16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "#${order.codeReservation}",
                      style: AppStyles.interSemiBoldTextButton.bold().withSize(FontSizes.headline5),
                    ),
                    Gap(5.w),
                    Text(
                      formattedDate,
                      style: AppStyles.interSemiBoldTextButton.regular().withColor(Colors.blueGrey).withSize(FontSizes.title),
                    ),
                  ],
                ),
              ],
            ),
            Gap(AppConstants.verticalSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total price ",
                  style: AppStyles.interSemiBoldTextButton.regular().withColor(Colors.blueGrey).withSize(FontSizes.headline6),
                ),
                Text(
                  "${order.getFormattedTotalPrice()} DT",
                  style: AppStyles.interSemiBoldTextButton.medium().withSize(FontSizes.title),
                ),
              ],
            ),
            Gap(10.h),
            const ZigzagDivider(color: Colors.blueGrey),
            Gap(12.h),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: order.items.map((item) {
                    if (item.food != null) {
                      return RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "* ${item.quantity}x ",
                              style: AppStyles.interSemiBoldTextButton.medium().withSize(FontSizes.headline6),
                            ),
                            TextSpan(
                              text: " ${item.food!.name}",
                              style: AppStyles.interSemiBoldTextButton.regular().withSize(FontSizes.title),
                            ),
                          ],
                        ),
                      );
                    } else if (item.offer != null) {
                      return RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "* ${item.quantity}x ",
                              style: AppStyles.interSemiBoldTextButton.medium().withSize(FontSizes.headline6),
                            ),
                            TextSpan(
                              text: " ${item.offer!.name}",
                              style: AppStyles.interSemiBoldTextButton.regular().withSize(FontSizes.title),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }).toList(),
                ),
              ],
            ),
            if (order.status == "Done") ...[
              Gap(10.h),
              Divider(color: Colors.blueGrey, thickness: 2.r),
              Gap(10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
                      cartViewModel.setReOrderLoading(true);
                      cartViewModel.clearCart();
                       if (order.items.isNotEmpty && order.items.any((item) => item.food != null)) {
  await cartViewModel.addItems(
    order.items.map((item) => item.food!).toList()
  );

  await cartViewModel.overrideEstablishmentId(
    order.establishment?.id ?? order.market?.id ?? '',
  );
} else if (order.items.isNotEmpty && order.items.any((item) => item.product != null)){
   await cartViewModel.addItemsProducts(
    order.items.map((item) => item.product!).toList()
  );

}
                      Future.delayed(const Duration(seconds: 2), () {
                        cartViewModel.setReOrderLoading(false);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_bag_sharp, color: AppColors.offWhite, size: 18),
                        const Gap(4),
                        Text(
                          "Re-order",
                          style: AppStyles.interregularTitle.withSize(16.sp).withColor(AppColors.offWhite).bold(),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      final firstFood = order.items.first.food;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewScreen(food: firstFood!)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: AppColors.offWhite, size: 18),
                        const Gap(4),
                        Text(
                          "Rate",
                          style: AppStyles.interregularTitle.withSize(16.sp).withColor(AppColors.offWhite).bold(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ).paddingSymmetric(
          horizontal: AppConstants.bodyMinSymetricHorizontalPadding,
          vertical: 16.h,
        ),
      ).paddingOnly(bottom: AppConstants.verticalSpacing),
    );
  }
}