import 'package:flutter/widgets.dart';

/// Shared corner-radius tokens so cards, sheets, and artwork stay visually
/// consistent. Keep this separate from [TuneMotion] (theme/motion.dart) —
/// this file is static geometry, motion.dart is the animated transitions
/// between shapes/states.
class ShapeValues {
  ShapeValues._();

  static const small = BorderRadius.all(Radius.circular(8));
  static const medium = BorderRadius.all(Radius.circular(12));
  static const large = BorderRadius.all(Radius.circular(16));
  static const extraLarge = BorderRadius.all(Radius.circular(24));

  static const sheetTop = BorderRadius.vertical(top: Radius.circular(28));
}
