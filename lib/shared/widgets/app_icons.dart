import 'package:flutter/material.dart';

class AppIcons {
  /// Chevron that points in the forward navigation direction.
  /// In RTL (Persian) forward points left; in LTR it points right.
  static IconData forward(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl
        ? Icons.arrow_back_ios_new
        : Icons.arrow_forward_ios;
  }

  /// Arrow that points in the forward navigation direction.
  static IconData forwardArrow(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl
        ? Icons.arrow_back
        : Icons.arrow_forward;
  }
}
