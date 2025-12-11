import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hiatunisie/models/establishement.model.dart';
import 'package:hiatunisie/models/food.model.dart';
import 'package:hiatunisie/viewmodels/food_viewmodel.dart';


class FoodSearchDelegateEstablishment extends SearchDelegate<Food> {
  final FoodViewModel foodViewModel;

  FoodSearchDelegateEstablishment(this.foodViewModel);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
   return IconButton(
  icon: const Icon(Icons.arrow_back),
  onPressed: () {
    close(context, Food(
      id: '',
      name: '',
      image: '',
      price: 0,
      averageRating: 0,
      description: '', 
      category: [], 
      ingredients: [], 
      remise: 0, 
      isAvailable: true, 
      remiseDeadline: DateTime.now(), establishment: Establishment(
        name: '',
        address: '',
        phone: '',
        image: '',
        averageRating: 0,
        foods: [],
        reviews: [], id: '', latitude: 0.0, longitude: 0.0, isOpened: false,
      ), reviews: []
    ));
  },
);



  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildEstablishmentList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildEstablishmentList();
  }

  Widget _buildEstablishmentList() {
    
    List<Food> filteredEstablishments = foodViewModel.foods.where((establishment) {
      return establishment.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

   return ListView.builder(
    
  itemCount: filteredEstablishments.length,
  itemBuilder: (context, index) {
    final food = filteredEstablishments[index];
    return ListTile(
      tileColor: Colors.white,
      title: Text(
        food.name,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Row(
        children: [
          RatingBarIndicator(
            rating: food.averageRating.toDouble(),
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 15.0,
          ),
          const SizedBox(width: 5.0), 
        
        ],
      ),
      leading: food.image.isNotEmpty
          ? Image.network(
              food.image,
              width: 70.0, 
              height: 70.0,
              fit: BoxFit.cover,
            )
          : null,
           trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
      ),
      onTap: () {
       
      },
    );
  },
);

  }
}