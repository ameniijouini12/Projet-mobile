import 'package:hiatunisie/models/food.model.dart';
import 'package:hiatunisie/models/offer.model.dart';
import 'package:hiatunisie/models/product.model.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'cart_item.model.g.dart';

@HiveType(typeId: 4)
class CartItem extends HiveObject {
  @HiveField(0)
  final Food? food;

  @HiveField(1)
  int quantity;

  @HiveField(2)
  final Offer? offer;

  @HiveField(3)
  final Product? product;

  @HiveField(4)
   String type;



  CartItem({this.food, this.offer, this.type = "food",this.product, required this.quantity});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      food: json['food'] != null ? Food.fromJson(json['food']) : null,
      offer: json['offer'] != null ? Offer.fromJson(json['offer']) : null,
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
      quantity: json['quantity'],
      type: json['type'] ?? "food",
    );
  }

  factory CartItem.fromJsonWithoutFood(Map<String, dynamic> json) {
    return CartItem(
      food: json['food'] != null ? Food.fromJsonWithoutEstablishment(json['food']) : null,
      offer: json['offer'] != null ? Offer.fromJsonWithoutEtablishment(json['offer']) : null,
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
      quantity: json['quantity'],
    );
  }

  String getFormattedPrice() {
    final formatter = NumberFormat('#,##0.000', 'en_US');
    if (food != null) {
      return formatter.format(food!.price);
    } else if (offer != null) {
      return formatter.format(offer!.price);
    } else if (product != null) {
      return formatter.format(product!.price);
    }
     else {
      return '0.000';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'food': food?.toJson(),
      'offer': offer?.toJson(),
      'product':product?.toJson() ,
      'quantity': quantity,
      'type':type
    };
  }

  bool isValid() {
    return (food != null || offer != null || product != null) && (food == null || offer == null || product == null);
  }
}