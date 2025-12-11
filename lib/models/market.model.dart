import 'package:hiatunisie/models/product.model.dart';
import 'package:hive/hive.dart';


@HiveType(typeId: 7)
class Market extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? image;

  @HiveField(3)
  double langitude;

  @HiveField(4)
  double latitude;

  @HiveField(5)
  String? address;

  @HiveField(6)
  String? phone;

  @HiveField(7)
  List<Product>? products;

  @HiveField(8)
  bool isOpened;

  @HiveField(9)
  List<String>? categories; // Liste von Strings

  /// Standardkonstruktor
  Market.empty()
      : id = '',
        name = '',
        image = '',
        latitude = 0.0,
        langitude = 0.0,
        address = '',
        phone = '',
        isOpened = true,
        products = [],
        categories = [];

  /// Hauptkonstruktor
  Market({
    required this.id,
    required this.name,
    this.image,
    required this.latitude,
    required this.langitude,
    this.address,
    this.phone,
    required this.isOpened,
    this.products,
    this.categories,
  });

  /// Factory zum Parsen von JSON ohne Produkte
  factory Market.fromJsonWithoutProducts(Map<String, dynamic> json) {
    return Market(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      langitude: (json['langitude'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      isOpened: json['isOpened'] as bool? ?? false,
      categories: (json['category'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
    );
  }

  /// Factory zum Parsen des vollständigen JSON
  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      langitude: (json['langitude'] as num?)?.toDouble() ?? 0.0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      isOpened: json['isOpened'] as bool? ?? false,
      products: (json['products'] is List)
          ? (json['products'] as List<dynamic>)
              .map((e) => e is Map<String, dynamic>
                  ? Product.fromJson(e)
                  : null)
              .whereType<Product>()
              .toList()
          : [],
      categories: (json['category'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  /// Methode zum Konvertieren des Market-Objekts zurück zu JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'latitude': latitude,
      'langitude': langitude,
      'address': address,
      'phone': phone,
      'isOpened': isOpened,
      'products': products?.map((product) => product.toJson()).toList(),
      'category': categories,
    };
  }
}
