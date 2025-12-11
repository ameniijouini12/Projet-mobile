import 'package:hiatunisie/models/food.model.dart';
import 'package:hiatunisie/models/user.model.dart';
import 'package:hive/hive.dart';

part 'establishement.model.g.dart';

@HiveType(typeId: 3)
class Review extends HiveObject {
  @HiveField(0)
  User user;

  @HiveField(1)
  String? comment;

  @HiveField(2)
  double rating;

  Review({required this.user, this.comment, required this.rating});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      comment: json['comment'] as String?,
      rating: (json['rating'] as num).toDouble(),
    );
  }

  //from json with empty user
  factory Review.fromJsonWithoutUser(Map<String, dynamic> json) {
    return Review(
      user: User.empty(),
      comment: json['comment'] as String?,
      rating: (json['rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'comment': comment,
      'rating': rating,
    };
  }
}


@HiveType(typeId: 2)
class Establishment extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String? image;

  @HiveField(4)
  double latitude;

  @HiveField(5)
  double longitude;

  @HiveField(6)
  String? address;

  @HiveField(7)
  int? averageRating;

  @HiveField(8)
  String? phone;

  @HiveField(9)
  bool isOpened;

  @HiveField(10)
  List<String>? preferences;

  @HiveField(11)
  List<Food>? foods;

  @HiveField(12)
  List<Review>? reviews;


  //constructor empty establishment
  Establishment.empty()
      : id = '',
        name = '',
        description = '',
        image = '',
        latitude = 0,
        longitude = 0,
        address = '',
        averageRating = 0,
        phone = '',
        isOpened = false,
        preferences = [],
        foods = [],
        reviews = [];

  Establishment({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.latitude,
    required this.longitude,
    this.address,
    this.averageRating,
    this.phone,
    required this.isOpened,
    this.preferences,
    this.foods,
    this.reviews,
  });

  // establishment without foods
  factory Establishment.fromJsonWithoutFoods(Map<String, dynamic> json) {
    return Establishment(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['langitude'] as num).toDouble(),
      address: json['address'] as String?,
      averageRating: (json['averageRating'] as num?)?.toInt(),
      phone: json['phone'] as String?,
      isOpened: json['isOpened'] as bool,
      preferences: (json['preferences'] as List<dynamic>?)?.map((e) => e as String).toList(),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  factory Establishment.fromJson(Map<String, dynamic> json) {
  return Establishment(
    id: json['_id'] as String,
    name: json['name'] as String,
    description: json['description'] as String?,
    image: json['image'] as String?,
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['langitude'] as num).toDouble(),
    address: json['address'] as String?,
    averageRating: (json['averageRating'] as num?)?.toInt(),
    phone: json['phone'] as String?,
    isOpened: json['isOpened'] as bool,
    
    preferences: (json['preferences'] as List<dynamic>?)
        ?.map((e) => e as String).toList(),

    foods: (json['foods'] is List)
        ? (json['foods'] as List<dynamic>)
            .map((e) => e is Map<String, dynamic> 
              ? Food.fromJson(e) 
              : null) // Handle potential invalid structure
            .whereType<Food>() // Filter out any null values
            .toList()
        : [],

    reviews: (json['reviews'] is List)
        ? (json['reviews'] as List<dynamic>)
            .map((e) => e is Map<String, dynamic> 
              ? Review.fromJson(e) 
              : null) // Handle potential invalid structure
            .whereType<Review>() // Filter out any null values
            .toList()
        : [],
  );
}


  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'image': image,
      'latitude': latitude,
      'langitude': longitude,
      'address': address,
      'averageRating': averageRating,
      'phone': phone,
      'isOpened': isOpened,
      'preferences': preferences,
      'foods': foods?.map((e) => e.toJson()).toList(),
      'reviews': reviews?.map((e) => e.toJson()).toList(),
    };
  }

    String? get city {
    if (address == null) return null;

    // Regex to extract the city part from an address string (both English and Arabic)
    final RegExp cityRegex = RegExp(
      r'(?:(?:\d+\s*)?[A-Za-z.-]+\s*)+|[\u0621-\u064A\u0660-\u0669 ]+',
      unicode: true,
    );
    final match = cityRegex.firstMatch(address!);
    return match?.group(0);
  }
}
