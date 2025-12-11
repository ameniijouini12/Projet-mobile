import 'package:flutter/material.dart';
import 'package:hiatunisie/models/market.model.dart';
import 'package:hiatunisie/viewmodels/market_viewmodel.dart';


class MarketHorizontal extends StatelessWidget {
  final Market market;
  final MarketViewModel marketViewModel;

  const MarketHorizontal({
    Key? key,
    required this.market,
    required this.marketViewModel,
  }) : super(key: key);

  void _onMarketTap(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onMarketTap(context),
      child: Container(
        width: 200, // Adjust width as needed
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                market.image ?? '',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    market.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    market.address ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
