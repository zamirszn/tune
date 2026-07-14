import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:motor/motor.dart';

/// The signature "expressive" control: the button's own silhouette morphs
/// between a [MaterialShapes.square] (paused) and [MaterialShapes.circle]
/// (playing) using real Material 3 polygon shapes and spring physics —
/// the same [MaterialShapeBorder] + [Morph] mechanism bunpod uses for its
/// ChannelWall tiles, not an approximated corner-radius tween.
class ExpressivePlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;
  final double size;

  const ExpressivePlayButton({
    super.key,
    required this.isPlaying,
    required this.onTap,
    this.size = 72,
  });

  static ShapeBorder _morphBorder(RoundedPolygon a, RoundedPolygon b, double t) {
    final borderA = MaterialShapeBorder(shape: a);
    if (t <= 0) return borderA;
    final borderB = MaterialShapeBorder(shape: b);
    if (t >= 1) return borderB;
    return borderA.lerpTo(borderB, t)!;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return GestureDetector(
      onTap: onTap,
      child: SingleMotionBuilder(
        motion: const MaterialSpringMotion.expressiveSpatialFast(),
        value: isPlaying ? 1.0 : 0.0,
        active: !reduceMotion,
        builder: (context, morph, child) {
          final shape = _morphBorder(
            MaterialShapes.square,
            MaterialShapes.circle,
            morph.clamp(0.0, 1.0),
          );
          return ClipPath(
            clipper: ShapeBorderClipper(shape: shape),
            child: child,
          );
        },
        child: SizedBox(
          width: size,
          height: size,
          child: Container(
            color: colorScheme.primaryContainer,
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: colorScheme.onPrimaryContainer,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}