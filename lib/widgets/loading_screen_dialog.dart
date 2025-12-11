import 'package:flutter/material.dart';
import 'package:hiatunisie/models/cart/cart.model.dart';
import 'package:hiatunisie/viewmodels/cart_viewmodel.dart';
import 'package:hiatunisie/viewmodels/offer.viewmodel.dart';


class LoadingScreenDialog extends StatefulWidget {
  final Cart cart;
  final CartViewModel cartViewModel;
  final OfferViewModel offerViewModel;

  const LoadingScreenDialog({
    Key? key,
    required this.cart,
    required this.cartViewModel,
    required this.offerViewModel,
  }) : super(key: key);

  @override
  State<LoadingScreenDialog> createState() => _LoadingScreenDialogState();
}

class _LoadingScreenDialogState extends State<LoadingScreenDialog> {
  bool _isProcessing = true;
  String _status = 'Traitement de votre commande...';
  bool _success = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> processOrder() async {
    try {
      setState(() {
        _status = 'Traitement de votre commande...';
      });

      // Process each item in the cart
      for (var item in widget.cart.items) {
        if (item.offer != null) {
          setState(() {
            _status = 'Mise à jour des quantités...';
          });

          // Vérifier si la quantité demandée est toujours disponible
          if (item.offer!.quantity < item.quantity) {
            throw Exception('La quantité demandée n\'est plus disponible pour ${item.offer!.name}');
          }

          // Mettre à jour immédiatement la quantité dans l'interface
          final offerIndex = widget.offerViewModel.offers.indexWhere((o) => o.id == item.offer!.id);
          if (offerIndex != -1) {
            widget.offerViewModel.offers[offerIndex].quantity -= item.quantity;
            widget.offerViewModel.notifyListeners(); // Force UI update
          }

          // Décrémenter la quantité du box par la quantité réservée
          bool success = await widget.offerViewModel.decrementOfferQuantityBy(
            item.offer!.id, 
            item.quantity
          );
          
          if (!success) {
            // En cas d'échec, restaurer la quantité précédente
            if (offerIndex != -1) {
              widget.offerViewModel.offers[offerIndex].quantity += item.quantity;
              widget.offerViewModel.notifyListeners();
            }
            throw Exception('Erreur lors de la mise à jour de la quantité pour ${item.offer!.name}');
          }

          // Vérifier si la quantité est maintenant à zéro
          final remainingQuantity = item.offer!.quantity - item.quantity;
          if (remainingQuantity <= 0) {
            await widget.offerViewModel.forceDeleteOffer(item.offer!.id);
          }
        }
      }

      // Clean up any remaining zero quantity offers
      widget.offerViewModel.checkAndCleanOffers();

      // Vider le panier après une commande réussie
      widget.cartViewModel.clearCart();

      setState(() {
        _isProcessing = false;
        _success = true;
        _status = 'Commande effectuée avec succès!';
      });

      // Close dialog after success
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.of(context).pop(true);
      }

    } catch (e) {
      setState(() {
        _isProcessing = false;
        _success = false;
        _status = 'Erreur: ${e.toString()}';
      });

      // Close dialog after error
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.of(context).pop(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isProcessing) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ] else ...[
              Icon(
                _success ? Icons.check_circle : Icons.error,
                color: _success ? Colors.green : Colors.red,
                size: 50,
              ),
              const SizedBox(height: 20),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}