import 'package:hiatunisie/helpers/debugging_printer.dart';
import 'package:hiatunisie/models/cart/cart_item.model.dart';
import 'package:hiatunisie/models/establishement.model.dart';
import 'package:hiatunisie/models/food.model.dart';
import 'package:hiatunisie/models/offer.model.dart';
import 'package:hiatunisie/models/product.model.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'cart.model.g.dart';

@HiveType(typeId: 5)
class Cart extends HiveObject {
  @HiveField(0)
  List<CartItem> items;

  @HiveField(1)
  String? establishmentId;

  @HiveField(2)
  Establishment? establishment;

  Cart({required this.items , this.establishmentId});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      establishmentId: json['establishmentId'] as String? ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'establishmentId': establishmentId,
    };
  }

  void overrideEstablishmentId(String id) {
    establishmentId = id;
    save();
  }
 Future<bool> addItem(Food? food, int quantity, {Offer? offer , Product? product}) async {
  Debugger.red(product?.marketId); // Changed market to marketId since that's the property available on Product
  try {
    if (food == null && offer == null && product == null) {
      Debugger.red('Cannot add item without food or offer or product');
      return false;
    }
    
     if (food != null){

     
    if (items.isEmpty) {
       establishment = food.establishment;
      establishmentId = food.establishment.id;
      Debugger.blue('Establishment ID: $establishmentId');
    }

    if (establishmentId != food.establishment.id) {
      Debugger.red('Cannot add item from a different establishment');
      return false;
    }

    // Find the index of the existing item
    int existingIndex = items.indexWhere((item) => item.food!.id == food.id);

    if (existingIndex != -1) {
      // Update the quantity of the existing item
      items[existingIndex].quantity += quantity;
      Debugger.blue('Updated existing item quantity: ${items[existingIndex].quantity}');
    } else {
      // Add the new item to the cart
      items.add(CartItem(food: food, quantity: quantity , offer: offer));
      Debugger.blue('Added new item: ${food.name}, quantity: $quantity');
    }
     }
     else if (product !=null){
      if (items.isEmpty) {
      establishmentId = product.marketId;
      Debugger.blue('Market ID: $establishmentId');
    }

    if (establishmentId != product.marketId) {
      Debugger.red('Cannot add item from a different market');
      return false;
    }

    // Find the index of the existing item
    int existingIndex = items.indexWhere((item) => item.product!.id == product.id);

    if (existingIndex != -1) {
      // Update the quantity of the existing item
      items[existingIndex].quantity += quantity;
      Debugger.blue('Updated existing item quantity: ${items[existingIndex].quantity}');
    }
      
      items.add(CartItem(food: null, quantity: quantity , offer: null , product: product));
      Debugger.blue('Added new item: ${product.name}, quantity: $quantity');
    
     }
      else if (offer !=null){
      if (items.isEmpty) {
      establishmentId = offer.etablishment.id;

      Debugger.blue('Establishment ID: $establishmentId');
    }

    if (establishmentId != offer.etablishment.id) {
      Debugger.red('Cannot add item from a different establishment');
      return false;
    }
      
      items.add(CartItem(food: null, quantity: quantity , offer: offer));
      Debugger.blue('Added new item: ${offer.name}, quantity: $quantity');
     }
           
    save(); // Save the updated cart
    return true;
  } catch (error) {
    Debugger.red('Error adding item: $error');
    return false;
  }
}

void clearCart() {
  items.clear();
  establishmentId = null;


  save();
}


    void removeItem(Food? food, {Offer? offer,Product? product}) {
      if (food != null && offer != null && product != null) {
        items.removeWhere((item) => 
          (item.food != null && item.food!.id == food.id) || 
          (item.offer != null && item.offer!.id == offer.id) ||
          (item.product != null && item.product!.id == product.id)
        );
      } 
      else if (food != null) {
        items.removeWhere((item) => item.food != null && item.food!.id == food.id);
      } 
      else if (offer != null) {
        items.removeWhere((item) => item.offer != null && item.offer!.id == offer.id);
      }
      else if (product != null) {
        items.removeWhere((item) => item.product != null && item.product!.id == product.id);
      }
    
      if (items.isEmpty) {
        establishmentId = null;
      }
    
      save();
    }

  void updateItemQuantity(Food? food, int quantity , {Offer? offer,Product? product}) {
    if (food != null){
      int index = items.indexWhere((item) => item.food!.id == food.id);
    if (index != -1) {
      items[index].quantity = quantity;
      save();
    }
    }else if (offer != null){
      int index = items.indexWhere((item) => item.offer!.id == offer.id);
    if (index != -1) {
      items[index].quantity = quantity;
      save();
    }
    }
    else if (product != null){
      int index = items.indexWhere((item) => item.product!.id == product.id);
    if (index != -1) {
      items[index].quantity = quantity;
      save();
    }
    }
    
  }

 

    double getTotalPrice() {
      return items.fold(0, (total, item) {
      if (item.food != null) {
        return total + (item.food!.price * item.quantity);
      } else if (item.offer != null) {
        return total + (item.offer!.price * item.quantity);
      }
      else if (item.product != null) {
        return total + (item.product!.price * item.quantity);
      }
      return total;
    });
  }

  String getFormattedTotalPrice() {
    final formatter = NumberFormat('#,##0.000', 'en_US');
    return formatter.format(getTotalPrice());
  }
}