import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:hiatunisie/helpers/debugging_printer.dart';
import 'package:hiatunisie/models/offer.model.dart';
import 'package:hiatunisie/services/offer.service.dart';
import 'dart:async';

class OfferViewModel extends ChangeNotifier {
  final OfferService service = OfferService();
  List<Offer> _offers = [];
  final Map<String, DateTime> _endTimes = {};
  Timer? _globalTimer;
  final Queue<String> _deletionQueue = Queue<String>();
  bool _isProcessing = false;
  Timer? _batchTimer;
  static const _batchDelay = Duration(milliseconds: 300);

  List<Offer> get offers => List.unmodifiable(_offers);

  bool isLoading = false;
  

  OfferViewModel() {
    fetchOffers();
  }

  Future<void> refreshOffers() async {
    await fetchOffers();

  }
  Future<bool> decrementOfferQuantity(String offerId) async {
    try {
      // Call the service method
      await service.decrementOfferQuantity(offerId);
       await fetchOffers();
        notifyListeners();
      // Update local state
      final offerIndex = _offers.indexWhere((offer) => offer.id == offerId);
      if (offerIndex != -1) {
        final offer = _offers[offerIndex];
        offer.quantity--; // Decrement first
        
        Debugger.green('Current quantity for offer ${offer.id}: ${offer.quantity}');
        
        // Notify listeners immediately after quantity change
        notifyListeners();
        
        // Force check if quantity is 0 or less
        if (offer.quantity <= 0) {
          Debugger.yellow('Offer quantity is zero or less, triggering deletion...');
          await forceDeleteOffer(offerId);
          await service.deleteOfferById(offerId); 
          await fetchOffers();
         }
      }
      
      return true;
    } catch (e) {
      Debugger.red('Error decrementing offer quantity: $e');
      return false;
    }
  }

  Future<bool> decrementOfferQuantityBy(String offerId, int amount) async {
    try {
      // Update local state immediately
      final offerIndex = _offers.indexWhere((offer) => offer.id == offerId);
      if (offerIndex == -1) {
        throw Exception('Offer not found');
      }

      final offer = _offers[offerIndex];
      final previousQuantity = offer.quantity;
      
      // Call the service method
      await service.decrementOfferQuantityBy(offerId, amount);
      
      // Refresh offers from server to ensure consistency
      await fetchOffers();
      
      // Force check if quantity is 0 or less
      if (offer.quantity <= 0) {
        Debugger.yellow('Offer quantity is zero or less, triggering deletion...');
        await forceDeleteOffer(offerId);
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      Debugger.red('Error decrementing offer quantity by $amount: $e');
      return false;
    }
  }

  Future<void> fetchOffers() async {
    if (isLoading) return;
    
    isLoading = true;
    notifyListeners();

    try {
      // First try to get cached data
      _offers = await service.getCachedData();
      if (_offers.isNotEmpty) {
        Debugger.green('Fetched cached offers: ${_offers.length} offers');
      }

      // Then try to fetch from network
      bool internetAvailable = await _retryInternetCheck(
        retries: 1,
        delay: const Duration(seconds: 2)
      );

      if (internetAvailable) {
        Debugger.green('Internet available, fetching fresh data');
        final fetchedOffers = await service.fetchOffers();

        if (fetchedOffers.isNotEmpty) {
          _offers = fetchedOffers;
          await service.cacheData(_offers);
          Debugger.green('Updated offers from network: ${_offers.length} offers');
        } else {
          Debugger.yellow('No offers found from network');
        }
      } else {
        Debugger.yellow('No internet connection available');
      }
    } catch (e) {
      Debugger.red('Error fetching offers: $e');
      if (_offers.isEmpty) {
        rethrow;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> _retryInternetCheck({ int retries=3,  Duration delay=const Duration(seconds: 2)}) async {
    for (var i = 0; i < retries; i++) {
     if (await service.hasInternetConnection()) {
        return true;
      }
      await Future.delayed(delay);
    }
    return false;
  }

  List<Offer> mergeOffers(List<Offer> cached, List<Offer> fetched) {
    final Map<String, Offer> offerMap = {for (var e in cached) e.name: e};
    for (var offer in fetched) {
      offerMap[offer.name] = offer;
    }
    return offerMap.values.toList();
  }

  List<Offer> getOffersByEstablishment(String id) {
    return _offers.where((offer) => offer.etablishment.id == id).toList();
  }
   Future<void> deleteOffer(String offerId) async {
    try {

      _offers.removeWhere((offer) => offer.id == offerId);
        notifyListeners();
       await service.deleteOfferById(offerId) ; 

        
     
    } catch (e) {
      print('Error deleting offer: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _globalTimer?.cancel();
    _batchTimer?.cancel();
    super.dispose();
  }

  void initializeTimers(List<Offer> offers) {
    _offers = offers;
    
    // Initialize end times map
    for (var offer in offers) {
      _endTimes[offer.id] = offer.validUntil; // Changed endTime to expirationTime
    }

    // Start global timer
    _startGlobalTimer();
    notifyListeners();
  }

  void _startGlobalTimer() {
    _globalTimer?.cancel();
    _globalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      bool needsUpdate = false;

      // Check all active offers
      _endTimes.forEach((offerId, endTime) {
        if (endTime.isBefore(now)) {
          _deletionQueue.add(offerId);
          _endTimes.remove(offerId);
          needsUpdate = true;
        }
      });

      if (needsUpdate) {
        _processExpiredOffers();
      }
    });
  }

  void _processExpiredOffers() {
    if (_deletionQueue.isEmpty) return;

    // Remove expired offers from local state
    _offers = _offers.where((offer) => !_deletionQueue.contains(offer.id)).toList();
    notifyListeners();

    // Process backend deletions
    if (!_isProcessing) {
      _isProcessing = true;
      _processBatchDeletion();
    }
  }

  Future<void> _processBatchDeletion() async {
    try {
      while (_deletionQueue.isNotEmpty) {
        final batch = <String>[];
        while (batch.length < 5 && _deletionQueue.isNotEmpty) {
          batch.add(_deletionQueue.removeFirst());
        }

        await Future.wait(
          batch.map((id) => service.deleteOfferById(id).catchError((error) {
            if (!error.toString().contains('404')) {
              debugPrint('Error deleting offer $id: $error');
            }
            return null;
          })),
        );
      }
    } finally {
      _isProcessing = false;
    }
  }

  Duration? getRemainingTime(String offerId) {
    final endTime = _endTimes[offerId];
    if (endTime == null) return null;
    
    final remaining = endTime.difference(DateTime.now());
    return remaining.isNegative ? null : remaining;
  }

  Future<void> removeOfferLocally(String offerId) async {
    if (_deletionQueue.contains(offerId)) return;
    
    _deletionQueue.add(offerId);
    
    // Create new list and force rebuild
    _offers = List.from(_offers)..removeWhere((offer) => offer.id == offerId);
    
    // Notify twice to ensure complete rebuild
    notifyListeners();
    Future.microtask(notifyListeners);

    _batchTimer?.cancel();
    _batchTimer = Timer(_batchDelay, () {
      if (!_isProcessing) {
        _isProcessing = true;
        _processBatchDeletion();
      }
    });
  }

  // Helper method to force delete an offer
  Future<bool> forceDeleteOffer(String offerId) async {
    try {
      // Remove from database
      await service.deleteOfferById(offerId);
      
      // Remove locally
      final offerIndex = _offers.indexWhere((offer) => offer.id == offerId);
      if (offerIndex != -1) {
        _offers.removeAt(offerIndex);
        notifyListeners();
      }
      
      Debugger.green('Offer force deleted successfully');
      return true;
    } catch (e) {
      Debugger.red('Error force deleting offer: $e');
      return false;
    }
  }

  // Method to check and clean zero quantity offers
  Future<void> cleanZeroQuantityOffers() async {
    try {
      final zeroQuantityOffers = _offers.where((offer) => offer.quantity <= 0).toList();
      
      for (var offer in zeroQuantityOffers) {
        Debugger.yellow('Cleaning zero quantity offer: ${offer.id}');
        await forceDeleteOffer(offer.id);
      }
    } catch (e) {
      Debugger.red('Error cleaning zero quantity offers: $e');
    }
  }

  // Call this method periodically or after certain operations
  void checkAndCleanOffers() {
    cleanZeroQuantityOffers();
  }
}
