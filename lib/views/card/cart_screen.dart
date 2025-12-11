import 'package:hiatunisie/helpers/debugging_printer.dart';
import 'package:hiatunisie/viewmodels/cart_viewmodel.dart';
import 'package:hiatunisie/views/card/empty_card.dart';
import 'package:hiatunisie/views/card/loading_order.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:hiatunisie/widgets/cart_item_widget.dart';
import 'package:hiatunisie/widgets/shimmer_cart_item.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Scaffold(
            body: Column(
              children: [
                const SizedBox(height: 30.0),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: Colors.white,
                    ),
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return const ShimmerCartItem();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        var cart = viewModel.cart!;
        if (cart.items.isEmpty) {
          return const EmptyCard();
        }

        Debugger.green(viewModel.cart?.establishmentId);
        return SmartScaffold(
          bottomNavigationBar: Card(
            color: Colors.white,
            elevation:0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _showLoadingScreen(context);
                      },
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: kMainColor,
                        ),
                        child: Center(
                          child: Text(
                            'Commander  ${cart.getFormattedTotalPrice()} DT',
                            style: kTextStyle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/hiaauthbgg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 60.0),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10.0),
                          Column(
                            children: [
                              const SizedBox(height: 22.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 25.0),
                                  const Text(
                                    'Votre panier',
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      color: kTitleColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 25.0),
                                  Text(
                                    '${cart.items.length} ${cart.items.length > 1 ? 'produits' : 'produit'} de chez ${cart.establishment?.name}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                            ],
                          ),
                          Flexible(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: cart.items.length,
                              itemBuilder: (context, index) {
                                var item = cart.items[index];
                                var key = item.food?.id ??
                                    item.offer?.id ??
                                    item.product?.id ??
                                    '';
                                var name = item.food?.name ??
                                    item.offer?.name ??
                                    item.product?.name ??
                                    '';
                                var imageUrl = item.food?.image ??
                                    item.offer?.image ??
                                    item.product?.image ??
                                    '';
                                var price = item.food?.price ??
                                    item.offer?.newPrice ??
                                    item.product?.price ??
                                    0.0;

                                String formattedPrice = getFormattedPrice(price.toDouble());


                                return Column(
                                  children: [
                                    Dismissible(
                                      key: Key(key),
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        color: Colors.transparent,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Lottie.asset(
                                                'images/delete_icon.json',
                                                height: 70.0,
                                                width: 70.0,
                                                repeat: false),
                                          ),
                                        ),
                                      ),
                                      onDismissed: (direction) {
                                        if (item.food != null) {
                                          viewModel.removeItem(item.food!);
                                        } else if (item.offer != null) {
                                          viewModel.removeItem(null,
                                              offer: item.offer);
                                        } else if (item.product != null) {
                                          viewModel.removeItem(null,
                                              offer: null,
                                              product: item.product);
                                          //showCustomToast(context, "${item.product!.name} removed from cart");
                                        }
                                      },
                                      child: CartItemWidget(
                                        imageUrl: imageUrl,
                                        name: name,
                                        price: formattedPrice,
                                        quantity: item.quantity,
                                        onIncrease: () {
                                          if (item.food != null) {
                                            viewModel.updateItemQuantity(
                                                item.food!, item.quantity + 1,
                                                offer: null, product: null);
                                          } else if (item.offer != null) {
                                            // Check if we've reached the box's quantity limit
                                            if (item.quantity <
                                                item.offer!.quantity) {
                                              viewModel.updateItemQuantity(
                                                  null, item.quantity + 1,
                                                  offer: item.offer!);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Quantité maximale atteinte (${item.offer!.quantity})'),
                                                  backgroundColor:
                                                      Colors.orange,
                                                ),
                                              );
                                            }
                                          } else if (item.product != null) {
                                            viewModel.updateItemQuantity(
                                                null, item.quantity + 1,
                                                offer: null,
                                                product: item.product);
                                          }
                                        },
                                        onDecrease: () {
                                          if (item.quantity > 1) {
                                            // Prevent going below 0
                                            if (item.food != null) {
                                              viewModel.updateItemQuantity(
                                                  item.food!, item.quantity - 1,
                                                  offer: null, product: null);
                                            } else if (item.offer != null) {
                                              viewModel.updateItemQuantity(
                                                  null, item.quantity - 1,
                                                  offer: item.offer!,
                                                  product: null);
                                            } else if (item.product != null) {
                                              viewModel.updateItemQuantity(
                                                  null, item.quantity - 1,
                                                  offer: null,
                                                  product: item.product);
                                            }
                                          }
                                        },
                                        onRemove : () {
                                          if (item.food != null) {
                                            viewModel.removeItem(item.food!);
                                          } else if (item.offer != null) {
                                            viewModel.removeItem(null,
                                                offer: item.offer);
                                          } else if (item.product != null) {
                                            viewModel.removeItem(null,
                                                offer: null,
                                                product: item.product);
                                            //showCustomToast(context, "${item.product!.name} removed from cart");
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

String getFormattedPrice(double price) {
  final formatter = NumberFormat('#,##0.000', 'en_US');
  return formatter.format(price);
}

void _showLoadingScreen(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const LoadingScreenDialog(),
  );
}
