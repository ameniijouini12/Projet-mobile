import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';

class PhoneInputField extends StatefulWidget {
  final Function(String fullPhone)? onChanged;
  final String initialCountryCode;
  final TextEditingController? controller;

  const PhoneInputField({
    super.key,
    this.onChanged,
    this.initialCountryCode = '+216',
    this.controller,
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  late TextEditingController _controller;
  late String _countryCode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _countryCode = widget.initialCountryCode;

    _controller.addListener(_onPhoneChanged);
  }

  void _onPhoneChanged() {
    final digitsOnly = _controller.text.replaceAll(RegExp(r'\D'), '');
    widget.onChanged?.call('$_countryCode$digitsOnly');
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: [
          CountryCodePicker(
            flagDecoration: const BoxDecoration(shape: BoxShape.circle),
            onChanged: (code) {
              setState(() => _countryCode = code.toString());
              _onPhoneChanged();
            },
            initialSelection: _countryCode,
            favorite: ['+216', 'TN'],
            textStyle: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              cursorColor: Colors.blueAccent,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
                _TunisianPhoneFormatter(),
              ],
              decoration: const InputDecoration(
                hintText: 'xx xxx xxx',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TunisianPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 8) digits = digits.substring(0, 8);

    String formatted = '';
    for (int i = 0; i < digits.length; i++) {
      formatted += digits[i];
      if (i == 1 || i == 4) formatted += ' ';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
