import 'package:hiatunisie/views/home/exports/export_homescreen.dart';

class NavigationModel extends ChangeNotifier {
  int _selectedItemPosition = 0;
  int get selectedItemPosition => _selectedItemPosition;

  void updateSelectedIndex(int index) {
    _selectedItemPosition = index;
    notifyListeners();
  }
}