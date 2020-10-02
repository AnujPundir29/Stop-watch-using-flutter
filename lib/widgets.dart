// import 'dart:html';

import 'package:flutter/material.dart';

///The below class is used to design our button widget
///it uses color, onpressed , and a text
///this contains a constructor to take value and assign it the local variable
/// and also contains a required field with naming reference constructor
class ProductivityButton extends StatelessWidget {
  final Color color;
  final String text;
  // final double size;
  final VoidCallback onPressed;

  ProductivityButton(
      {@required this.color,
      @required this.text,
      // @required this.size,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(
        this.text,
        style: TextStyle(color: Colors.white),
      ),
      color: this.color,
      // minWidth: this.size,
      onPressed: this.onPressed,
    );
  }
}

/** typedef can be used as a pointer that references a function.
 *  This is because we want to call the function, with the correct parameters,
 *  from the relevant button */

typedef CallbackSetting = void Function(String, int);

class SettingButton extends StatelessWidget {
  final Color color;
  final String text;
  // final double size;
  final String setting;
  final CallbackSetting callback;
  final int value;

  SettingButton(this.color, this.text, this.value, this.setting, this.callback);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => this.callback(this.setting, this.value),
      color: this.color,
      child: Text(
        this.text,
        style: TextStyle(color: Colors.white),
      ),
      // minWidth: this.size,
    );
  }
}
