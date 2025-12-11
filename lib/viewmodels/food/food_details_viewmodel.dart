import '../../models/food.model.dart';
import '../../views/home/exports/export_homescreen.dart';
import '../cart_viewmodel.dart';
class FoodDetailsViewModel extends ChangeNotifier {
  final Food food;
  final UserViewModel userViewModel;
  final CartViewModel cartViewModel;

  int _quantity = 1;
  bool _isFavourite = false;

  int get quantity => _quantity;
  bool get isFavourite => _isFavourite;

  FoodDetailsViewModel({
    required this.food,
    required this.userViewModel,
    required this.cartViewModel,
  }) {
    _initFavouriteStatus(); // ✅ This will replace the old initState
  }

  void _initFavouriteStatus() async {
    _isFavourite = await userViewModel.verifFoodFavourite(
      food.id,
      userViewModel.userData!.id,
    );
    notifyListeners();
  }

  void increaseQuantity() {
    if (_quantity < 7) {
      _quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
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
    } catch (_) {
      _isFavourite = !_isFavourite; // rollback if failed
      notifyListeners();
    }
  }

  Future<bool> addToCart(BuildContext context) async {
    final success = await cartViewModel.addItem(food, _quantity);
    return success;
  }
}
