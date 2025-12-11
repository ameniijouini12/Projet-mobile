import 'package:hiatunisie/models/establishement.model.dart'; // Ensure correct import path
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'food.model.g.dart';

@HiveType(typeId: 0)
class Food extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String image;

  @HiveField(4)
  final List<String> category;

  @HiveField(5)
  final int averageRating;

  @HiveField(6)
  final List<String> ingredients;

  @HiveField(7)
  final bool isAvailable;

  @HiveField(8)
  final int remise;

  @HiveField(9)
  final DateTime remiseDeadline;

  @HiveField(10)
  final List<Review>? reviews;

  @HiveField(11)
  final Establishment establishment; // Correct field name

  @HiveField(12)
  final String id;

  //create constructor empty food
  Food.empty()
      : id = '',
        name = '',
        description = '',
        price = 0,
        image = '',
        category = [],
        averageRating = 0,
        ingredients = [],
        isAvailable = false,
        remise = 0,
        remiseDeadline = DateTime.now(),
        reviews = [],
        establishment = Establishment.empty();
         

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.averageRating,
    required this.ingredients,
    required this.isAvailable,
    required this.remise,
    required this.remiseDeadline,
    required this.reviews,
    required this.establishment, // Correct field name
  });

  

  //factory from json without establishment 
  factory Food.fromJsonWithoutEstablishment(Map<String, dynamic> json) {
    return Food(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      image: json['image'],
      category: List<String>.from(json['category']),
    averageRating: json['averageRating'] is double
    ? (json['averageRating'] as double).toInt()
    : json['averageRating'],      
    ingredients: List<String>.from(json['ingredients']),
      isAvailable: json['isAvailable'],
      remise: json['remise'] is double
    ? (json['remise'] as double).toInt()
    : json['remise'],
      remiseDeadline: DateTime.parse(json['remiseDeadline']),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Review.fromJsonWithoutUser(e as Map<String, dynamic>))
          .toList(),
      establishment: Establishment.empty(), // Correct key name

    );
  }



       factory Food.fromJson(Map<String, dynamic> json) {
      return Food(
        id: json['_id'],
        name: json['name'],
        description: json['description'],
        price: json['price'].toDouble(),
        image: json['image'],
        category: List<String>.from(json['category']),
        averageRating: json['averageRating'] is double
            ? (json['averageRating'] as double).toInt()
            : json['averageRating'],
        ingredients: List<String>.from(json['ingredients']),
        isAvailable: json['isAvailable'],
        remise: json['remise'] is double
            ? (json['remise'] as double).toInt()
            : json['remise'],
        remiseDeadline: DateTime.parse(json['remiseDeadline']),
        reviews: (json['reviews'] as List<dynamic>?)
            ?.map((e) => Review.fromJsonWithoutUser(e as Map<String, dynamic>))
            .toList(),
        establishment: Establishment.fromJson(json['etablishment']),
      );
    }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'averageRating': averageRating,
      'ingredients': ingredients,
      'isAvailable': isAvailable,
      'remise': remise,
      'remiseDeadline': remiseDeadline.toIso8601String(),
      'reviews': reviews?.map((e) => e.toJson()).toList(),
      'etablishment': establishment.toJson(), // Correct key name
    };
  }

  String getFormattedPrice() {
    final formatter = NumberFormat('#,##0.000', 'en_US');
    return formatter.format(price);
  }
}