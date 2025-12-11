import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';

import '../viewmodels/cart_viewmodel.dart';
import '../views/home/home_controller.dart';

class GlobalFloatingCartButton extends StatelessWidget {
  const GlobalFloatingCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: kMainColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
      ),
      onPressed: () {
        HomeController.instance.goToCartTab();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(FontAwesomeIcons.cartShopping, size: 18),
          const SizedBox(width: 10),
          Text('Continuer vers panier ${cart.getFormattedTotalPrice()}'),
        ],
      ),
    );
  }
}
