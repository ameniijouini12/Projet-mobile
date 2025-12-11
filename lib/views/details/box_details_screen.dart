import 'dart:async';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hiatunisie/app/style/app_style.dart';
import 'package:hiatunisie/app/style/font_size.dart';
import 'package:hiatunisie/models/offer.model.dart';
import 'package:hiatunisie/viewmodels/cart_viewmodel.dart';
import 'package:hiatunisie/views/details/establishment.details.dart';
import 'package:hiatunisie/app/style/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../constant.dart';

class BoxDetailsScreen extends StatefulWidget {
  const BoxDetailsScreen({super.key, required this.box});

  final Offer box;

  @override
  _BoxDetailsScreenState createState() => _BoxDetailsScreenState();
}

class _BoxDetailsScreenState extends State<BoxDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ---------------------------
          // SliverAppBar with hero image
          // ---------------------------
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
                  icon: Image.asset(
                    'images/left-arrow.png',
                    width: 18.w,
                    height: 18.w,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: ClipPath(
                clipper: CustomShapeClipper(),
                child: Stack(
                  children: [
                    FastCachedImage(
                      url: widget.box.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 300.0,
                      loadingBuilder: (context, loadingProgress) {
                        return loadingProgress.isDownloading &&
                                loadingProgress.totalBytes != null
                            ? Shimmer(
                                child: Container(
                                  width: double.infinity,
                                  height: 300.0,
                                  color: AppColors.unselectedItemShadow,
                                ),
                              )
                            : const SizedBox(
                                width: double.infinity,
                                height: 300.0,
                              );
                      },
                    ),
                    // Gradient overlay from bottom to top
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    // Center Title
                    Center(
                      child: Text(
                        widget.box.name,
                        style: AppStyles.interSemiBoldTextButton
                            .black()
                            .withSize(FontSizes.headline2)
                            .withColor(AppColors.offWhite),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ---------------------------
          // Body Content
          // ---------------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const QuantityControl(),
                  const Gap(30),

                  // ------------------
                  // Profile + Chips Row
                  // ------------------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Establishment profile image
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EstablishmentDetailsScreen(
                                establishment: widget.box.etablishment,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,

                          ),
                          child: ClipOval(
                            child: Image.network(
                              widget.box.etablishment.image!,
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      // REPLACE "Available"/"Not Available" with a countdown
                      CountdownStatusChip(
                        endTime: widget.box.validUntil,
                      ),

                      const SizedBox(width: 10),

                      // Shows how many items left
                      StatusChip(
                        status: "${widget.box.quantity} items left",
                        icon: Icons.shopping_cart,
                        textColor: widget.box.quantity < 3
                            ? Colors.red
                            : AppColors.background,
                        iconColor: widget.box.quantity < 3
                            ? Colors.red
                            : AppColors.background,
                        backgroundColor: widget.box.quantity < 3
                            ? Colors.red.withOpacity(0.1)
                            : AppColors.background.withOpacity(0.1),
                      ),
                    ],
                  ),

                  const Gap(25),

                  // ------------------
                  // Description
                  // ------------------
                  Text(
                    'Description',
                    style: AppStyles.interSemiBoldTextButton
                        .medium()
                        .withSize(FontSizes.headline4)
                        .withColor(AppColors.offBlack),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(20),
                  Text(
                    widget.box.description,
                    style: kTextStyle.copyWith(
                      color: Colors.blueGrey,
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(30),

                  // ------------------
                  // Price
                  // ------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.box.newPrice != null) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${widget.box.newPrice!.toStringAsFixed(2)} TND',
                              style: AppStyles.interSemiBoldTextButton
                                  .bold()
                                  .withSize(FontSizes.headline4)
                                  .withColor(AppColors.offBlack),
                            ),
                            const Gap(2),
                            Text(
                              '${widget.box.price.toStringAsFixed(2)} TND',
                              style: AppStyles.interSemiBoldTextButton
                                  .withSize(FontSizes.headline5)
                                  .withColor(Colors.grey)
                                  .copyWith(decoration: TextDecoration.lineThrough),
                            ),
                          ],
                        ),
                      ] else
                        Text(
                          '${widget.box.price.toStringAsFixed(2)} TND',
                          style: AppStyles.interSemiBoldTextButton
                              .bold()
                              .withSize(FontSizes.headline4)
                              .withColor(AppColors.offBlack),
                        ),
                    ],
                  ),
                  const Gap(20),

                  // ------------------
                  // "Add to Cart" Button
                  // ------------------
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleAddToCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.background,
                            padding: const EdgeInsets.symmetric(vertical: 11.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                          ),
                          child: Text(
                            'Add to cart',
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
            ),
          ),
        ],
      ),
    );
  }

  void _handleAddToCart() async {
    try {
      final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
      
      bool success = await cartViewModel.addItem(
        null,
        quantity,
        offer: widget.box,
      );

      if (!mounted) return;

      if (success) {
        // Vérifier si l'article était déjà dans le panier
        bool wasAlreadyInCart = cartViewModel.isItemInCart(widget.box.id);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(wasAlreadyInCart 
              ? 'Quantité mise à jour dans le panier'
              : 'Box ajoutée au panier avec succès'
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de l\'ajout au panier'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

/// A custom shape clipper for the AppBar background
class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// A re-usable status chip for textual badges
class StatusChip extends StatelessWidget {
  final String status;
  final IconData icon;
  final Color textColor;
  final Color iconColor;
  final Color backgroundColor;

  const StatusChip({
    super.key,
    required this.status,
    required this.icon,
    required this.textColor,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: textColor, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20.w, color: iconColor),
          const SizedBox(width: 8.0),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// CountdownStatusChip: Similar to [StatusChip], but shows a live countdown
/// rather than a static text. Updates every second. If countdown <= 0, shows "Expired".
/// ---------------------------------------------------------------------------
class CountdownStatusChip extends StatefulWidget {
  final DateTime endTime;

  const CountdownStatusChip({
    super.key,
    required this.endTime,
  });

  @override
  State<CountdownStatusChip> createState() => _CountdownStatusChipState();
}

class _CountdownStatusChipState extends State<CountdownStatusChip> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.endTime.difference(DateTime.now());
    if (_remaining.isNegative) {
      _remaining = Duration.zero;
    }
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final diff = widget.endTime.difference(DateTime.now());
      if (diff.isNegative) {
        _timer.cancel();
        setState(() => _remaining = Duration.zero);
      } else {
        setState(() => _remaining = diff);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /// Creates a formatted time string showing days (if >=24h left),
  /// otherwise HH:MM:SS, or "Expired" if no time left.
  String get timeText {
    if (_remaining.inSeconds <= 0) {
      return "Expired";
    }

    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;

    if (_remaining.inHours >= 24) {
      // e.g. 1j:04:32:10
      return '${days}j:${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    } else {
      // e.g. 04:32:10 (if >= 1h), or 00:45:10 (under 1h)
      final hh = _remaining.inHours.toString().padLeft(2, '0');
      final mm = minutes.toString().padLeft(2, '0');
      final ss = seconds.toString().padLeft(2, '0');
      return '$hh:$mm:$ss';
    }
  }

  @override
  Widget build(BuildContext context) {
    // We style it just like StatusChip
    // If time is expired, we can color it red or do something else.
    final isExpired = _remaining.inSeconds <= 0;

    final textColor = isExpired ? Colors.red : AppColors.background;
    final backgroundColor = isExpired
        ? Colors.red.withOpacity(0.1)
        : AppColors.background.withOpacity(0.1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: textColor, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_clock,
            size: 20.w,
            color: textColor,
          ),
          const SizedBox(width: 8.0),
          Text(
            timeText,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Provider that manages quantity for the "QuantityControl" widget
class QuantityProvider with ChangeNotifier {
  int _quantity = 1;

  int get quantity => _quantity;

  void increment() {
    _quantity++;
    notifyListeners();
  }

  void decrement() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void setQuantity(int newQuantity) {
    _quantity = newQuantity;
    notifyListeners();
  }
}

/// A small widget to increment/decrement quantity
class QuantityControl extends StatelessWidget {
  const QuantityControl({super.key});

  @override
  Widget build(BuildContext context) {
    final quantityProvider = Provider.of<QuantityProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.remove,
              color: Colors.white.withOpacity(0.5),
            ),
            onPressed: quantityProvider.decrement,
          ),
          Text(
            '${quantityProvider.quantity}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white.withOpacity(0.5),
            ),
            onPressed: quantityProvider.increment,
          ),
        ],
      ),
    );
  }
}
