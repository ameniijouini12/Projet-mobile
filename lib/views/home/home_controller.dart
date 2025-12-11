import 'exports/export_homescreen.dart';

class HomeController {
  HomeController._private();
  static final instance = HomeController._private();

  late PageController pageController;
  ValueNotifier<int> selectedTab = ValueNotifier<int>(0);

  void goToCartTab() {
    selectedTab.value = 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.jumpToPage(1);
    });
  }

  void goToHomeTab() {
    selectedTab.value = 0;pageController.jumpToPage(0);
  }
}
