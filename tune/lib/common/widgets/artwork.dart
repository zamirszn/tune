import 'package:flutter/material.dart';

/// Deterministic gradient placeholder standing in for album/playlist
/// artwork until real thumbnails come from the YT Music data layer.
class Artwork extends StatelessWidget {
  final String seed;
  final double size;
  final BorderRadius? borderRadius;

  const Artwork({
    super.key,
    required this.seed,
    this.size = 56,
    this.borderRadius,
  });

  Color _colorFromSeed(BuildContext context, int offset) {
    final hash = seed.codeUnits.fold<int>(0, (a, b) => a + b) + offset;
    final hue = (hash * 37) % 360;
    return HSLColor.fromAHSL(1, hue.toDouble(), 0.55, 0.55).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _colorFromSeed(context, 0),
              _colorFromSeed(context, 90),
            ],
          ),
        ),
        child: Icon(
          Icons.music_note_rounded,
          color: Colors.white.withValues(alpha: 0.85),
          size: size * 0.4,
        ),
      ),
    );
  }
}
