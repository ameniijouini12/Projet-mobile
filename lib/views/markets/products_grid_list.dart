import 'package:flutter/material.dart';
import 'package:hiatunisie/app/style/widget_modifier.dart';
import 'package:hiatunisie/models/market.model.dart';
import 'package:hiatunisie/viewmodels/market_viewmodel.dart';
import 'package:provider/provider.dart';

class ProductsGridList extends StatefulWidget {
  const ProductsGridList({super.key, required this.box});

  final Market box;

  @override
  _ProductsGridListState createState() => _ProductsGridListState();
}

class _ProductsGridListState extends State<ProductsGridList> {
  @override
  Widget build(BuildContext context) {
    final marketViewModel = Provider.of<MarketViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      // Transparent AppBar with custom layout
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Colors.transparent,
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                // Title
                const Text(
                  "Produits",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // Menu Button
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () {
                    // Implement menu action
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              // Top Banner Section with widget.box.image
              Stack(
                children: [
                  // Background Image
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(widget.box.image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Gradient Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Name and Button
                  Positioned(
                    bottom: 30,
                    left: 20,
                    right: 20,
                    child: Column(
                      children: [
                        Text(
                          widget.box.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: const Center(
                            child: Text(
                              "Naviguer",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ).onTap(() {
                          marketViewModel.launchMaps(
                            widget.box.latitude,
                            widget.box.langitude,
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Grid of Products using ProductCard
            /* Expanded(
                child: widget.box.products != null &&
                        widget.box.products!.isNotEmpty
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: widget.box.products!.length,
                        itemBuilder: (context, index) {
                          final product = widget.box.products![index];
                          return ProductCard(
                            product: product,
                          ).onTap(() {
                            // Navigate to product detail screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                  product: product,
                                ),
                              ),
                            );
                          });
                        },
                      )
                    : const Center(
                        child: Text(
                          'No products available',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
