import 'package:flutter/material.dart';
import 'package:hiatunisie/viewmodels/establishement_viewmodel.dart';
import 'package:hiatunisie/viewmodels/market_viewmodel.dart';

import 'package:hiatunisie/views/home/establishment_search_delegate.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:hiatunisie/views/markets/marget_grid_list.dart';

import 'package:provider/provider.dart';

import '../../constant.dart';

class MarketsScreen extends StatefulWidget {
  const MarketsScreen({super.key});

  @override
  _MarketsScreenState createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen> {
  @override
  Widget build(BuildContext context) {
//Provider.of<MarketViewModel>(context).fetchMarkets();
    return SmartScaffold(
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
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 35.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                  await showSearch(
                        context: context,
                        delegate: EstablishmentSearchDelegate(
                          Provider.of<EstablishmentViewModel>(context,
                              listen: false),
                        ), // Replace with your custom SearchDelegate
                      );
                      // Handle search results if needed
                    },
                  ),
                ),
                const SizedBox(height: 30.0),
                Consumer<MarketViewModel>(
                  builder: (context, marketViewModel, child) {
                    return const MarketGrid();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }
}
