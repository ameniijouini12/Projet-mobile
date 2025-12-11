import 'package:hiatunisie/models/cart/cart_item.model.dart';
import 'package:hiatunisie/models/establishement.model.dart';
import 'package:hiatunisie/models/market.model.dart';
import 'package:intl/intl.dart';

class Reservation {
  final String userId;
  final String? etablishmentId;
  final List<CartItem> items;
  final String? codeReservation;
  final String? id;
  final DateTime? date;
  final Establishment? establishment;
  final Market? market;

  final String? status;
  final double? totalPrice;

  Reservation({
    required this.userId,
    this.etablishmentId,
    this.market, 
    required this.items,
    this.codeReservation,
    this.id,
    this.date,
    this.establishment,
    this.status,
    this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'etablishmentId': etablishmentId ?? market!.id,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      userId: json['user'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJsonWithoutFood(item))
          .toList(),
      codeReservation: json['codeReservation'],
      id: json['_id'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      establishment: json['etablishment'] != null &&
              json['etablishment'] is Map<String, dynamic>
          ? Establishment.fromJsonWithoutFoods(json['etablishment'])
          : null,
      market: json['market'] != null &&
              json['market'] is Map<String, dynamic>
          ? Market.fromJsonWithoutProducts(json['market'])
          : null,
      status: json['status'],
      totalPrice: json['totalPrice'] != null
          ? (json['totalPrice'] is Map<String, dynamic> &&
                  json['totalPrice']['\$numberDecimal'] != null
              ? double.parse(json['totalPrice']['\$numberDecimal'])
              : double.parse(json['totalPrice'].toString()))
          : null,
    );
  }

  String getFormattedDate() {
    if (date == null) return '';
    final DateFormat formatter = DateFormat('MMM dd, yyyy | HH:mm');
    return formatter.format(date!);
  }

  // Return total price in this format: e.g., 13,000
   String getFormattedTotalPrice() {
    if (totalPrice == null) return '';
    final NumberFormat formatter = NumberFormat('#,###.##');
    return formatter.format(totalPrice);
  }
}