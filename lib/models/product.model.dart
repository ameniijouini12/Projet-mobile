import 'package:hiatunisie/helpers/debugging_printer.dart';
import 'package:hive/hive.dart';


@HiveType(typeId: 8)
class Product extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  double price;

  @HiveField(4)
  String image;

  @HiveField(5)
  bool isAvailable;

  @HiveField(6)
  double remise;

  @HiveField(7)
  DateTime? remiseDeadline;

  @HiveField(8)
  String marketId; 

  @HiveField(9)
  String categoryId; 

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.image,
    required this.isAvailable,
    required this.remise,
    this.remiseDeadline,
    required this.marketId,
    required this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing product JSON: $json');
      
      // Handle category ID extraction
      String categoryId = '';
      if (json['category'] != null) {
        if (json['category'] is String) {
          categoryId = json['category'];
        } else if (json['category'] is Map) {
          categoryId = json['category']['_id'] ?? '';
        }
      }

      // Handle market ID extraction
      String marketId = '';
      if (json['market'] != null) {
        if (json['market'] is String) {
          marketId = json['market'];
        } else if (json['market'] is Map) {
          marketId = json['market']['_id'] ?? '';
        }
      }

      return Product(
        id: json['_id'] as String? ?? json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        description: json['description'] as String?,
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        image: json['image'] as String? ?? '',
        isAvailable: json['isAvailable'] as bool? ?? false,
        remise: (json['remise'] as num?)?.toDouble() ?? 0.0,
        remiseDeadline: json['remiseDeadline'] != null 
            ? DateTime.parse(json['remiseDeadline'] as String)
            : null,
        categoryId: categoryId,
        marketId: marketId,
      );
    } catch (e, stackTrace) {
      Debugger.red('Error parsing Product from JSON: $e');
      Debugger.red('Problematic JSON: $json');
      Debugger.red('Stack trace: $stackTrace');
      throw Exception('Failed to parse Product: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'isAvailable': isAvailable,
      'remise': remise,
      'remiseDeadline': remiseDeadline?.toIso8601String(),
      'market': marketId,
      'category': categoryId,
    };
  }
}
