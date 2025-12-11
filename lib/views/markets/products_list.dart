import 'package:flutter/material.dart';
import 'package:hiatunisie/constant.dart';
import 'package:hiatunisie/models/market.model.dart';
import 'package:hiatunisie/viewmodels/product_viewmodel.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:hiatunisie/views/markets/product_card.dart';
import 'package:shimmer/shimmer.dart';

class ProductList extends StatelessWidget {
  final ProductViewModel productViewModel;
  final Market box ; 

  const ProductList({
    super.key,
    required this.productViewModel,
    required this.box
  });

  @override
  Widget build(BuildContext context) {
    if (productViewModel.isLoading && productViewModel.products.isEmpty) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: SizedBox(
          height: 200, // Specify a fixed height for the ListView
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (_, __) => Container(
              width: 200,
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
      );
    } else if (productViewModel.products.isEmpty) {
      return Center(
        child: SizedBox(
          height: 80,
          child: Text(
            'No deals for now',
            style: kTextStyle.copyWith(color: kGreyTextColor),
          ),
        ),
      );
    } else {
      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!productViewModel.isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            // Trigger fetching more products when reaching the end of the scroll
            productViewModel.fetchProducts(box.id);
            return true;
          }
          return false;
        },
        child: HorizontalList(
          spacing: 10,
          itemCount: productViewModel.products.length + (productViewModel.isLoading ? 1 : 0),
          itemBuilder: (_, i) {
            if (i == productViewModel.products.length) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 200,
                  height: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              );
            }
            return GestureDetector(
              onTap: () {
                // Navigate to product details screen
              },
              child: ProductCard(product: productViewModel.products[i]),
            );
          },
        ),
      );
    }
  }
}
