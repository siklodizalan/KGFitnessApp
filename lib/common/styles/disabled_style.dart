import 'package:flutter/material.dart';
import 'package:kgf_app/utils/constants/colors.dart';

class DisabledStyle {
  static TextStyle? getDisabledTextStyle(
      BuildContext context, bool disabled, TextStyle? baseTextStyle) {
    if (disabled) {
      return baseTextStyle?.copyWith(
        color: Theme.of(context).disabledColor,
        fontStyle: FontStyle.italic,
      );
    } else {
      return null;
    }
  }

  static ButtonStyle? getDisabledButtonStyle(
      BuildContext context, bool disabled, ButtonStyle? baseButtonStyle) {
    if (disabled) {
      return baseButtonStyle?.copyWith(
          backgroundColor:
              MaterialStateProperty.all<Color>(Theme.of(context).disabledColor),
          foregroundColor: MaterialStateProperty.all<Color>(TColors.lightGrey));
    } else {
      return null;
    }
  }
}
