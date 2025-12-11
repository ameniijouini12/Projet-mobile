import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateFormatter {
  static bool _isInitialized = false;

  static void initialize() {
    if (!_isInitialized) {
      initializeDateFormatting('en', null);
      _isInitialized = true;
    }
  }

  static String formatDate(DateTime date, String format) {
    if (!_isInitialized) {
      initialize();
    }
    return DateFormat(format, 'en').format(date);
  }
}