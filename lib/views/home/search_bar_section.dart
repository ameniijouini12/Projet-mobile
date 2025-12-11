import 'package:flutter/material.dart';
import 'package:hiatunisie/constant.dart';

import 'establishment_search_delegate.dart';
import 'exports/export_homescreen.dart';

class SearchBarSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                showSearch(
                  context: context,
                  delegate:
                  EstablishmentSearchDelegate(
                    Provider.of<
                        EstablishmentViewModel>(
                        context,
                        listen: false),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.blueGrey),
                    SizedBox(width: 8),
                    Text(
                      "Chercher un restaurant",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.filter_list, color: kMainColor),
              onPressed: () {
                // Implement filter functionality
                showDialog(
                  context: context,
                  builder: (context) {
                    return FilterDialog(
                      initialSelectedFilters:
                      Provider.of<FoodViewModel>(
                          context,
                          listen: false)
                          .selectedFilters,
                      onApply: (selectedFilters) {
                        Provider.of<FoodViewModel>(
                            context,
                            listen: false)
                            .applyFilters(
                            selectedFilters);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
