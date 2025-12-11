import 'package:flutter/material.dart';
import 'package:hiatunisie/constant.dart';

class OtpForm extends StatefulWidget {
  final void Function(String) onOtpEntered;

  const OtpForm({
    super.key,
    required this.onOtpEntered,
  });

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  late FocusNode pin2FocusNode;
  late FocusNode pin3FocusNode;
  late FocusNode pin4FocusNode;
  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 50.0,
                  child: TextFormField(
                    controller: controllers[index],
                    autofocus: index == 0,
                    obscureText: true,
                    style: const TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    focusNode: index == 0
                        ? null
                        : index == 1
                            ? pin2FocusNode
                            : index == 2
                                ? pin3FocusNode
                                : pin4FocusNode,
                    onChanged: (value) {
                      widget
                          .onOtpEntered(controllers.map((e) => e.text).join());
                      if (value.length == 1 && index < 3) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
