import '../../../models/food.model.dart';
import '../exports/export_homescreen.dart';

class FoodCardViewModel extends ChangeNotifier {
  final Food food;
  final UserViewModel userViewModel;

  bool _isFavourite = false;
  bool get isFavourite => _isFavourite;

  FoodCardViewModel({
    required this.food,
    required this.userViewModel,
  }) {
    _initFavouriteStatus();
  }

  void _initFavouriteStatus() async {
    _isFavourite = await userViewModel.verifFoodFavourite(
      food.id,
      userViewModel.userData!.id,
    );
    notifyListeners();
  }

  Future<void> toggleFavourite() async {
    _isFavourite = !_isFavourite;
    notifyListeners();

    try {
      if (_isFavourite) {
        await userViewModel.addFoodsToFavourites(food.id, userViewModel.userData!.id);
      } else {
        await userViewModel.removeFoodsFromFavourites(food.id, userViewModel.userData!.id);
      }
    } catch (e) {
      _isFavourite = !_isFavourite; // Rollback if API fails
      notifyListeners();
    }
  }
}
