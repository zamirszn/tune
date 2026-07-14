import 'package:motor/motor.dart';

/// Central place for the spring presets used across TUNE's expressive
/// motion — shape morphs, mini-player expansion, sheet transitions, etc.
///
/// Keeping these named and centralized means the whole app's "feel" can be
/// retuned from one file instead of hunting down scattered Curves.easeOut.
class TuneMotion {
  TuneMotion._();

  /// Fast, snappy — button/icon shape morphs (play/pause, like).
  static const spatialFast = MaterialSpringMotion.expressiveSpatialFast;

  /// Slower, weightier — mini-player -> full player expansion.
  static const spatialSlow = MaterialSpringMotion.standardSpatialSlow;

  /// Default for simple fades/opacity changes (non-spatial).
  static const effects = MaterialSpringMotion.standardEffectsDefault();
}
