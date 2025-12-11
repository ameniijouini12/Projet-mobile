

import 'package:hiatunisie/models/establishement.model.dart';
import 'package:hiatunisie/services/food_service.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';

class ReviewViewModel extends ChangeNotifier {
  double averagereview = 0.0;
  double _rating = 1.0;
  double get rating => _rating;
  List <Review> _reviewsProduct = [];
  List <Review> get reviewsProduct => _reviewsProduct;
  bool isLoading = true;

  final UserViewModel _userViewModel = UserViewModel();

   


  final FoodService _foodService = FoodService();
  
  final commentController = TextEditingController();

  ReviewViewModel(String id) {
    fetchReviews(id);
  }

  Future<void> fetchReviews(String id) async{
     isLoading = true;
     notifyListeners();
    _foodService.fetchReviews(id).then((value) {
      _reviewsProduct = value;
      calculateAverageReview();
      isLoading = false;

      notifyListeners();
    }).catchError((e) {
      isLoading = false;
      notifyListeners();
    });
  }

  void calculateAverageReview() {
    if (reviewsProduct.isEmpty) {
      averagereview = 0.0;
    } else {
      averagereview = reviewsProduct
              .map((e) => e.rating)
              .reduce((a, b) => a + b) /
          reviewsProduct.length;
    }
  }

  void updateRating(double rating) {
    _rating = rating;
    notifyListeners();
  }

  Future<void> addReview(String id ) async {
    isLoading = true;
    notifyListeners();

    final review = {
      "userId": _userViewModel.userId,
      "comment": commentController.text,
      "rating": rating,
    };

    try {
    await _foodService.addReview(id, review);
    await fetchReviews(id);  // This will fetch the latest reviews and update the UI.
  } catch (e) {
    //
  } finally {
    commentController.clear();
    isLoading = false;
    notifyListeners();
  }

   
  }
}