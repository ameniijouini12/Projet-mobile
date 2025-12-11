import 'package:flutter/material.dart';
import 'package:hiatunisie/viewmodels/cart_viewmodel.dart';
import 'package:hiatunisie/views/card/cart_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoadingScreenCart extends StatelessWidget {
  const LoadingScreenCart({super.key});

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);

    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        cartViewModel.setReOrderLoading(false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
      }
    });

    return Container(
      color: Colors.white,
      child: Center(
        child: Lottie.asset(
          'images/loading_cart_animation.json', 
          width: 200,
          height: 200,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}