import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hiatunisie/constant.dart';
import 'package:shimmer/shimmer.dart';

class CartItemWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;


  const CartItemWidget({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: imageUrl,
                width: 80.0,
                height: 80.0,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 80.0,
                    height: 80.0,
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style:
                      kTextStyle.copyWith(color: Colors.blueGrey, fontSize: 14),
                ),
                const SizedBox(height: 12.0),
                Text(
                  '$price DT',
                  style: TextStyle(
                    color: kTitleColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const SizedBox(width: 10.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0 , vertical: 5.0),
             decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
               color: kMainColor.withValues(alpha:0.2),
             ),
              child: Row(
                spacing: 10,
                children: [

                  GestureDetector(
                    onTap: quantity == 1 ? onRemove : onDecrease,
                    child:  Icon(
                     quantity ==1 ? Icons.delete_outline : Icons.remove,
                      color: kMainColor,
                    ),
                  ),

                  Text(
                    quantity.toString(),
                    style:TextStyle(
                      color: kTitleColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  GestureDetector(
                    onTap: onIncrease,
                    child: const Icon(
                      Icons.add,
                      color: kMainColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
