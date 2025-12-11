import 'package:flutter/material.dart';
import 'package:hiatunisie/constant.dart';
import 'package:hiatunisie/models/product.model.dart';
import 'package:hiatunisie/views/markets/product_card.dart';
import 'package:hiatunisie/views/markets/product_detail_screen.dart';
import 'package:hiatunisie/app/style/app_style.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;
  final List<Product> products;

  const CategoryProductsScreen({
    Key? key,
    required this.categoryName,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          categoryName,
          style: AppStyles.interSemiBoldTextButton.copyWith(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: kMainColor, // Green AppBar
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // White back button
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      product: products[index],
                    ),
                  ),
                );
              },
              child: ProductCard(
                product: products[index],
              ),
            );
          },
        ),
      ),
    );
  }
} 