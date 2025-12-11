import 'package:flutter/material.dart';
import 'package:hiatunisie/models/establishement.model.dart';
import 'package:hiatunisie/viewmodels/establishement_viewmodel.dart';
import 'package:hiatunisie/views/details/establishment.details.dart';

import '../../widgets/homescreen/establishment_card.dart';

class EstablishmentSearchDelegate extends SearchDelegate<Establishment> {
  final EstablishmentViewModel establishmentViewModel;
  List<String> recentSearches = ["Le Bistrot", "Tortuga"];
  EstablishmentSearchDelegate(this.establishmentViewModel);

  @override
  String get searchFieldLabel => "Chercher un restaurant";

  @override
  TextStyle get searchFieldStyle => const TextStyle(color: Colors.blueGrey);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: Colors.blueGrey),
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.blueGrey),
        ),
        hintStyle: const TextStyle(color: Colors.blueGrey),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      // elevation
      appBarTheme: const AppBarTheme(
        elevation: 1,
        color: Colors.white,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.blueGrey),
        onPressed: () {
          if (query.isEmpty) {
            close(context, Establishment.empty());
          } else {
            query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.blueGrey),
      onPressed: () {
        close(context, Establishment.empty());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        body: _buildEstablishmentList(),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Unfocus the search field
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        body:
            query.isEmpty ? _buildRecentSearches() : _buildEstablishmentList(),
      ),
    );
  }

  // Manage the recent searches list
  void _updateRecentSearches(String search) {
    if (recentSearches.contains(search)) {
      recentSearches
          .remove(search); // Remove the search if it's already in the list
    }
    recentSearches.insert(0, search); // Add the new search at the beginning

    if (recentSearches.length > 3) {
      recentSearches.removeLast(); // Ensure the list has no more than 3 items
    }
  }

  Widget _buildRecentSearches() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Vos recherches récentes",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            children: recentSearches.map((search) {
              return Chip(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(15)),
                label: Text(search),
                labelStyle: const TextStyle(color: Colors.blueGrey),
                backgroundColor: Colors.blueGrey[100],
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            "Établissements populaires",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: establishmentViewModel.establishments.length,
              itemBuilder: (context, index) {
                final establishment =
                    establishmentViewModel.establishments[index];
                return _buildSearchTile(establishment, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstablishmentList() {
    List<Establishment> filteredEstablishments = establishmentViewModel
        .establishments
        .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (filteredEstablishments.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 50, color: Colors.blueGrey),
            SizedBox(height: 10),
            Text("Pas de résultat trouvé",
                style: TextStyle(fontSize: 18, color: Colors.blueGrey)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredEstablishments.length,
      itemBuilder: (context, index) {
        return _buildSearchTile(filteredEstablishments[index], context);
      },
    );
  }

  Widget _buildSearchTile(Establishment establishment, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          close(context, establishment);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EstablishmentDetailsScreen(establishment: establishment),
            ),
          );
        },
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: double.infinity,
              height: 210,
              child: Stack(
                children: [
                  // Background Image
                  Positioned.fill(
                    child: establishment.image == null
                        ? Image.asset(
                            'images/placeholder.png',
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            establishment.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'images/placeholder.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),

                  // Gradient Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0),
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Rating and Favorite Button
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          establishment.averageRating! >= 5
                              ? Image.asset(
                                  'images/icon_rate2.png',
                                  width: 20.0,
                                  height: 20.0,
                                )
                              : Image.asset(
                                  'images/icon_rate1.png',
                                  width: 20.0,
                                  height: 20.0,
                                ),
                          const SizedBox(width: 5),
                          Text(
                            "${establishment.averageRating} (${establishment.reviews?.length})",
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Section (Title & Details)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            establishment.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 5),

                          // Metadata (Time, Difficulty, Chef)
                          Row(
                            children: [
                              StatusChipOpenedClosed(
                                  status: establishment.isOpened
                                      ? 'Opened'
                                      : 'Closed'),
                              const SizedBox(width: 10),
                              const Icon(Icons.circle,
                                  size: 6, color: Colors.blueGrey),
                              const SizedBox(width: 10),
                              Image.asset(
                                'images/location_icon.png',
                                width: 20.0,
                                height: 20.0,
                              ),
                              Text(
                                  " ${establishment.address}", // Using address as chef name placeholder
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.blueGrey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
