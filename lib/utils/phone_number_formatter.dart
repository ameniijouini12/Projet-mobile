import 'package:flutter/services.dart';
class PhoneNumberFormatter extends TextInputFormatter {
  final String? countryCode; // e.g. 'TN'

  PhoneNumberFormatter({this.countryCode});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Remove all non-digits
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // If Tunisia: must start with 9, 5, 2, or 4
    if (countryCode == 'TN' && digits.isNotEmpty) {
      if (!RegExp(r'^[9524]').hasMatch(digits)) {
        // Reject if first digit not allowed
        return oldValue;
      }
    }

    // Limit to 8 digits (spaces not counted)
    if (digits.length > 8) {
      digits = digits.substring(0, 8);
    }

    // Apply formatting: XX XXX XXX
    String formatted = '';
    for (int i = 0; i < digits.length; i++) {
      formatted += digits[i];
      if (i == 1 || i == 4) formatted += ' ';
    }

    // Return formatted value
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
