import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyPad extends StatelessWidget {
  const KeyPad({
    Key? key,
    required this.onChange,
    required this.textEditingController,
  }) : super(key: key);

  static const double buttonSize = 72.0;
  final TextEditingController textEditingController;
  final Function(String value) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buttonWidget(context, '1'),
                buttonWidget(context, '2'),
                buttonWidget(context, '3'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buttonWidget(context, '4'),
                buttonWidget(context, '5'),
                buttonWidget(context, '6'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buttonWidget(context, '7'),
                buttonWidget(context, '8'),
                buttonWidget(context, '9'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                iconButtonWidget(context, Icons.backspace_outlined, () {
                  if (textEditingController.text.isNotEmpty) {
                    HapticFeedback.lightImpact();
                    final newText = textEditingController.text.substring(
                      0,
                      textEditingController.text.length - 1,
                    );
                    textEditingController.text = newText;
                    onChange(newText);
                  }
                }),
                buttonWidget(context, '0'),
                buttonWidget(context, '.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(16),
    );
  }

  Widget buttonWidget(BuildContext context, String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: _buttonStyle(context),
          onPressed: () {
            HapticFeedback.lightImpact();
            String currentText = textEditingController.text;
            String newText = currentText;

            if (buttonText == '.') {
              if (currentText.contains('.')) return;
              if (currentText.isEmpty) {
                newText = '0.';
              } else {
                newText = currentText + buttonText;
              }
            } else {
              if (currentText.contains('.')) {
                List<String> parts = currentText.split('.');
                if (parts.length == 2 && parts[1].length >= 2) {
                  return;
                }
              }
              newText = currentText + buttonText;
            }

            if (newText != currentText) {
              textEditingController.text = newText;
              onChange(newText);
            }
          },
          child: Center(
            child: Text(
              buttonText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget iconButtonWidget(
    BuildContext context,
    IconData icon,
    Function() function,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          style: _buttonStyle(context),
          onPressed: () {
            HapticFeedback.lightImpact();
            function();
          },
          icon: Center(child: Icon(icon, size: 30, color: Colors.black)),
          label: const SizedBox(),
        ),
      ),
    );
  }
}
