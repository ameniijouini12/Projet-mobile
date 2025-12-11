import 'package:hiatunisie/helpers/debugging_printer.dart';
import 'package:hiatunisie/models/establishement.model.dart';
import 'package:hiatunisie/utils/date_formatter.dart';
import 'package:hive/hive.dart';
import 'food.model.dart'; // Import the Food model to use it within the Offer model

part 'offer.model.g.dart';

@HiveType(typeId: 1)
class Offer extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final List<Food> food;

  @HiveField(4)
  final Establishment etablishment;

  @HiveField(5)
  final int remise;

  @HiveField(6)
  final DateTime validFrom;

  @HiveField(7)
  final DateTime validUntil;

  @HiveField(8)
  final bool isAvailable;

  @HiveField(9)
  late final int quantity;

  @HiveField(10)
  final String id;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final DateTime updatedAt;

  @HiveField(13)
  final int price;

  @HiveField(14)
  final int? newPrice;

  final String formattedValidUntil;

  Offer({
    required this.name,
    required this.description,
    required this.image,
    required this.food,
    required this.etablishment,
    required this.remise,
    required this.validFrom,
    required this.validUntil,
    required this.isAvailable,
    required this.quantity,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.price,
    this.newPrice,
  }) : formattedValidUntil = DateFormatter.formatDate(validUntil, 'dd MMM yyyy');


  //factory without etablishment 
  factory Offer.fromJsonWithoutEtablishment(Map<String, dynamic> json) {
    return Offer(
      name: json['name'],
      description: json['description'],
      image: json['image'],
      food: (json['food'] as List).map((item) => Food.fromJson(item)).toList(),
      etablishment: Establishment.empty(),
      remise: json['remise'],
      validFrom: DateTime.parse(json['validFrom']),
      validUntil: DateTime.parse(json['validUntil']),
      isAvailable: json['isAvailable'],
      quantity: json['quantity'],
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      price: json['price'],
      newPrice: json['newPrice'],
    );
  }


  factory Offer.fromJson(Map<String, dynamic> json) {
    try {
      return Offer(
        id: json['_id'] ?? json['id'] ?? '',  // Handle both _id and id
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        image: json['image'] ?? '',
        food: (json['food'] as List).map((item) => Food.fromJson(item)).toList(),
        etablishment: Establishment.fromJsonWithoutFoods(json['etablishment']),
        remise: json['remise'],
        validFrom: DateTime.parse(json['validFrom']),
        validUntil: DateTime.parse(json['validUntil']),
        isAvailable: json['isAvailable'],
        quantity: json['quantity'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        price: json['price'],
        newPrice: json['newPrice'],
      );
    } catch (e) {
      Debugger.red('Error creating Offer from JSON: $e');
      Debugger.red('Problematic JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'food': food.map((item) => item.toJson()).toList(),
      'etablishment': etablishment.toJson(),
      'remise': remise,
      'validFrom': validFrom.toIso8601String(),
      'validUntil': validUntil.toIso8601String(),
      'isAvailable': isAvailable,
      'quantity': quantity,
      '_id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'price': price,
      'newPrice': newPrice,
    };
  }
}