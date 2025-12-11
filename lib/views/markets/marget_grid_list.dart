import 'package:flutter/material.dart';
import 'package:hiatunisie/app/style/widget_modifier.dart';
import 'package:hiatunisie/constant.dart';
import 'package:hiatunisie/models/market.model.dart';
import 'package:hiatunisie/viewmodels/market_viewmodel.dart';
import 'package:hiatunisie/views/markets/MarketCardGrid.dart';
import 'package:hiatunisie/views/markets/market_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MarketGrid extends StatefulWidget {
  const MarketGrid({super.key});

  @override
  State<MarketGrid> createState() => _MarketGridState();
}

class _MarketGridState extends State<MarketGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        final marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
        if (!marketViewModel.isLoading) {
          marketViewModel.fetchMarkets();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onMarketTap(BuildContext context, Market market) async {
    final marketViewModel = Provider.of<MarketViewModel>(context, listen: false);

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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MarketDetailScreen(),
        ),
      );
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketViewModel>(
      builder: (context, marketViewModel, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              Expanded(
                child: marketViewModel.isLoading && marketViewModel.markets.isEmpty
                    ? _buildShimmerEffect()
                    : marketViewModel.markets.isEmpty
                        ? const Center(
                            child: Text(
                              'There is no available data',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : _buildMarketGrid(marketViewModel),
              ),
              if (marketViewModel.isLoading)
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Builds the shimmer effect when data is loading
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: kMainColor,
      child: GridView.count(
        controller: _scrollController,
        childAspectRatio: 0.75,
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 2.0,
        children: List.generate(
          4,
          (index) => Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the GridView with market cards
  Widget _buildMarketGrid(MarketViewModel marketViewModel) {
    // Safety check for empty or mismatched data
    if (marketViewModel.markets.isEmpty || 
        marketViewModel.distances.isEmpty ||
        marketViewModel.markets.length != marketViewModel.distances.length) {
      return const Center(
        child: Text(
          'Loading markets...',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    final List<int> sortedIndices = List.generate(marketViewModel.markets.length, (i) => i)
      ..sort((a, b) => marketViewModel.distances[a].compareTo(marketViewModel.distances[b]));

    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 160.0),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: marketViewModel.markets.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 2.0,
          ),
          itemBuilder: (context, index) {
            // Additional safety check for index bounds
            if (index >= sortedIndices.length) {
              return const SizedBox();
            }
            
            final sortedIndex = sortedIndices[index];
            
            if (sortedIndex >= marketViewModel.markets.length || 
                sortedIndex >= marketViewModel.distances.length) {
              return const SizedBox();
            }

            return Center(
              child: Marketcardgrid(
                restaurantData: marketViewModel.markets[sortedIndex],
                index: sortedIndex,
                isGrid: true,
              ).onTap(() async {
                _onMarketTap(context, marketViewModel.markets[sortedIndex]);
              }),
            );
          },
        ),
      ),
    );
  }
}
