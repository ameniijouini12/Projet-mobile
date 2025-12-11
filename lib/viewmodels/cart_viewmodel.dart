import 'package:flutter/material.dart';
import 'package:hiatunisie/helpers/debugging_printer.dart';
import 'package:hiatunisie/models/cart/cart.model.dart';
import 'package:hiatunisie/models/food.model.dart';
import 'package:hiatunisie/models/offer.model.dart';
import 'package:hiatunisie/models/product.model.dart';
import 'package:hive/hive.dart';
import 'package:hiatunisie/viewmodels/offer.viewmodel.dart';
import 'package:intl/intl.dart';

class CartViewModel extends ChangeNotifier {
  late Box<Cart> _cartBox;
  Cart? _cart;
  bool _isLoading = true;
  final OfferViewModel offerViewModel;

  bool get isLoading => _isLoading;
  Cart? get cart => _cart;
  int get cartLength => _cart?.items.length ?? 0;

  bool _reOrderLoading = false;
  bool get reOrderLoading => _reOrderLoading;

  void setReOrderLoading(bool value) {
    Debugger.blue('Setting reOrderLoading to $value');
    _reOrderLoading = value;
    notifyListeners();
  }

  CartViewModel({required this.offerViewModel}) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    _cartBox = await Hive.openBox<Cart>('cartBox');
    _cart = _cartBox.get('cart', defaultValue: Cart(items: []));
    _isLoading = false;
    notifyListeners();
  }

  bool isItemInCart(String offerId) {
    if (_cart == null) return false;
    return _cart!.items.any((item) => item.offer?.id == offerId);
  }

  Future<bool> addItem(Food? food, int quantity, {Offer? offer, Product? product}) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (offer != null) {
        // Check if offer is still available
        final offerIndex = offerViewModel.offers.indexWhere((o) => o.id == offer.id);
        if (offerIndex != -1) {
          final currentOffer = offerViewModel.offers[offerIndex];
          if (currentOffer.quantity <= 0) {
            throw Exception('Cette offre n\'est plus disponible');
          }
          
          // Check if adding this quantity would exceed the box's limit
          final existingItemIndex = _cart?.items.indexWhere((item) => item.offer?.id == offer.id) ?? -1;
          final existingQuantity = existingItemIndex != -1 ? _cart!.items[existingItemIndex].quantity : 0;
          
          if (existingQuantity + quantity > currentOffer.quantity) {
            throw Exception('La quantité demandée dépasse la limite disponible');
          }
        }
      }

      // Initialize cart if null
      _cart ??= Cart(items: []);

      // Check if item already exists in cart
      if (offer != null) {
        final existingItemIndex = _cart!.items.indexWhere((item) => item.offer?.id == offer.id);
        if (existingItemIndex != -1) {
          // Increment quantity of existing item
          _cart!.items[existingItemIndex].quantity += quantity;
          notifyListeners();
          return true;
        }
      } else if (food != null) {
        final existingItemIndex = _cart!.items.indexWhere((item) => item.food?.id == food.id);
        if (existingItemIndex != -1) {
          // Increment quantity of existing item
          _cart!.items[existingItemIndex].quantity += quantity;
          notifyListeners();
          return true;
        }
      } else if (product != null) {
        final existingItemIndex = _cart!.items.indexWhere((item) => item.product?.id == product.id);
        if (existingItemIndex != -1) {
          // Increment quantity of existing item
          _cart!.items[existingItemIndex].quantity += quantity;
          notifyListeners();
          return true;
        }
      }

      // If item doesn't exist, add it to cart
      _cart!.addItem(food, quantity, offer: offer, product: product);

      notifyListeners();
      Debugger.green('Article ajouté au panier avec succès');
      return true;

    } catch (e) {
      Debugger.red('Erreur lors de l\'ajout au panier: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void removeItem(Food? food, {Offer? offer, Product? product}) {
    _cart?.removeItem(food, offer: offer, product: product);
    notifyListeners();
  }

  void updateItemQuantity(Food? food, int quantity, {Offer? offer, Product? product}) {
    if (quantity < 0) return; // Prevent negative quantities
    
    if (offer != null) {
      // Check if the new quantity exceeds the box's limit
      final offerIndex = offerViewModel.offers.indexWhere((o) => o.id == offer.id);
      if (offerIndex != -1) {
        final currentOffer = offerViewModel.offers[offerIndex];
        if (quantity > currentOffer.quantity) {
          return; // Don't update if it would exceed the limit
        }
      }
    }
    
    if (food != null) {
      _cart?.updateItemQuantity(food, quantity, offer: offer, product: product);
    } else if (offer != null) {
      _cart?.updateItemQuantity(null, quantity, offer: offer, product: null);
    } else if (product != null) {
      _cart?.updateItemQuantity(null, quantity, offer: null, product: product);
    }
    notifyListeners();
  }

  double getTotalPrice() {
    return _cart?.getTotalPrice() ?? 0.0;
  }

  String getFormattedTotalPrice() {
    final NumberFormat formatter = NumberFormat('#,###.##');
    return formatter.format(getTotalPrice());
  }

  void clearCart() {
    _cart?.clearCart();
    notifyListeners();
  }

  Future<void> addItems(List<Food> foods, {Offer? offer}) async {
    for (var food in foods) {
      _cart?.addItem(food, 1, offer: offer);
    }
    notifyListeners();
  }

  Future<void> addItemsProducts(List<Product> products) async {
    for (var product in products) {
      await addItem(null, 1, offer: null, product: product);
    }
  }

  Future<void> overrideEstablishmentId(String id) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    _cart?.overrideEstablishmentId(id);
    notifyListeners();
  }

}
