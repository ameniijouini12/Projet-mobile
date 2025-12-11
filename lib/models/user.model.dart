import 'package:hive/hive.dart';

part 'user.model.g.dart';

@HiveType(typeId: 6)
class User {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String password;

  @HiveField(5)
  final String? phone;

  @HiveField(6)
  final bool isVerified;

  @HiveField(7)
   String? profileImage;

  @HiveField(8)
  final String? address;

  @HiveField(9)
  final String? longitude;

  @HiveField(10)
  final String? latitude;

  @HiveField(11)
  final List<String> favoriteFood;

  @HiveField(12)
  final List<String> foodPreference;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.phone,
    required this.isVerified,
    this.profileImage,
    this.address,
    this.longitude,
    this.latitude,
    required this.favoriteFood,
    required this.foodPreference,
  });
  User.empty()
      : id = '',
        firstName = '',
        lastName = '',
        email = '',
        password = '',
        phone = '',
        isVerified = false,
        profileImage = '',
        address = '',
        longitude = '',
        latitude = '',
        favoriteFood = [],
        foodPreference = [];



  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'],
      isVerified: json['isVerified'] ?? false,
      profileImage: json['profileImage'],
      address: json['address'],
      longitude: json['langitude'],
      latitude: json['latitude'],
      favoriteFood: List<String>.from(json['favoriteFood'] ?? []),
      foodPreference: List<String>.from(json['foodPreference'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phone': phone,
      'isVerified': isVerified,
      'profileImage': profileImage,
      'address': address,
      'langitude': longitude,
      'latitude': latitude,
      'favoriteFood': favoriteFood,
      'foodPreference': foodPreference,
    };
  }
}