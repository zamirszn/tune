import 'package:tune/common/widgets/smooth_image.dart';
import 'package:tune/features/channel/models/channel.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:motor/motor.dart';

/// A full-bleed mosaic of channel cover art that starts as an edge-to-edge grid
/// of squares and morphs — once, on a short timer after it mounts — into an
/// expressive [MaterialShapes] silhouette, opening up the negative space
/// between covers. Once settled, it stays put.
///
/// The shape morph never waits on [channels]: tiles morph on their own timer
/// regardless of whether real data has arrived yet, so the wall reads as an
/// intentional design the instant it appears rather than a blank screen. When
/// [channels] is empty (still loading), every tile shows a solid placeholder
/// tint in its settled shape; the moment real channels are supplied, each
/// tile's cover art cross-fades in on top of its own placeholder, in place —
/// see [SmoothImage].
///
/// Because each shape stays inscribed in its own square cell, tiles are
/// gapless at the start and can never overlap.
///
/// Under reduced-motion the morph is skipped: tiles render statically in
/// their settled shape immediately.
class ChannelWall extends StatelessWidget {
  const ChannelWall({super.key, required this.channels});

  final List<Channel> channels;

  /// Target on-screen tile size; the column count is chosen to land near it.
  static const double _targetTile = 118;

  /// Builds a gapless, full-bleed grid of square cells covering the [w]×[h] box.
  static List<_TileSpec> _layoutFor(double w, double h) {
    final int cols = (w / _targetTile).round().clamp(3, 5);
    final double cell = w / cols;
    final int rows = (h / cell).ceil();

    final List<_TileSpec> specs = <_TileSpec>[];
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final int i = row * cols + col;
        specs.add(
          _TileSpec(
            index: i,
            left: col * cell,
            top: row * cell,
            size: cell,
            shape: i % _FloatingTile.shapeCount,
          ),
        );
      }
    }
    return specs;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final List<_TileSpec> layout = _layoutFor(
          constraints.maxWidth,
          constraints.maxHeight,
        );
        return Stack(
          children: <Widget>[
            for (final _TileSpec spec in layout)
              _FloatingTile(
                key: ValueKey<int>(spec.index),
                // Cycle through whatever real channels have arrived; while
                // channels is still empty this is null and the tile shows
                // its placeholder tint instead of art.
                channel: channels.isEmpty
                    ? null
                    : channels[spec.index % channels.length],
                spec: spec,
              ),
          ],
        );
      },
    );
  }
}

class _TileSpec {
  const _TileSpec({
    required this.index,
    required this.left,
    required this.top,
    required this.size,
    required this.shape,
  });

  /// Unique running index of this cell — used as the widget key.
  final int index;

  /// Absolute cell geometry, in logical pixels.
  final double left;
  final double top;
  final double size;

  /// Index into the shared settle-shape table.
  final int shape;
}

class _FloatingTile extends StatefulWidget {
  const _FloatingTile({super.key, required this.channel, required this.spec});

  final Channel? channel;
  final _TileSpec spec;

  // The expressive shape each square settles into.
  static final List<RoundedPolygon> _shapes = <RoundedPolygon>[
    MaterialShapes.cookie7Sided,
    MaterialShapes.clover4Leaf,
    MaterialShapes.sunny,
    MaterialShapes.cookie9Sided,
    MaterialShapes.gem,
    MaterialShapes.softBurst,
    MaterialShapes.cookie12Sided,
    MaterialShapes.pentagon,
    MaterialShapes.puffy,
    MaterialShapes.flower,
  ];

  static int get shapeCount => _shapes.length;

  /// A small, hand-picked palette so the wall reads as an intentional mosaic
  /// of color before any real cover art has loaded, rather than a single
  /// flat tint repeated everywhere.
  static const List<Color> _placeholderPalette = <Color>[
    Color(0xFF6750A4),
    Color(0xFF386A20),
    Color(0xFF904A43),
    Color(0xFF006874),
    Color(0xFF7D5700),
    Color(0xFF984061),
    Color(0xFF37618E),
    Color(0xFF6B5E1A),
  ];

  Color get placeholderSeed =>
      _placeholderPalette[spec.index % _placeholderPalette.length];

  @override
  State<_FloatingTile> createState() => _FloatingTileState();
}

class _FloatingTileState extends State<_FloatingTile> {
  static final RoundedPolygon _square = MaterialShapes.square;

  /// How long a tile is held as a square before it morphs. Runs on mount
  /// regardless of whether real channel data has arrived yet — the shape
  /// itself is the placeholder, so there's nothing worth waiting on.
  static const Duration _hold = Duration(milliseconds: 300);

  Timer? _holdTimer;
  bool _settleScheduled = false;

  final math.Random _rng = math.Random();

  // The tile morphs between two shape slots; [_target] (0 or 1) says which one
  // it is currently heading to. It starts as a square heading to its settle
  // shape; tapping swaps the slot it's leaving for a fresh random shape, so it
  // ping-pongs to a new shape on every tap.
  late RoundedPolygon _shapeA = _square;
  late RoundedPolygon _shapeB =
      _FloatingTile._shapes[widget.spec.shape % _FloatingTile._shapes.length];
  double _target = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only schedule the settle once per tile — didChangeDependencies can run
    // more than once (e.g. on theme/media-query changes).
    if (_settleScheduled) return;
    _settleScheduled = true;

    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduceMotion) {
      setState(() => _target = 1);
      return;
    }
    _holdTimer = Timer(_hold, () {
      if (mounted) setState(() => _target = 1);
    });
  }

  /// Easter egg: tap a cover to morph it to a fresh random shape, on the same
  /// expressive spring. Replaces the slot being left so it never repeats.
  void _onTap() {
    setState(() {
      if (_target == 0) {
        _shapeB = _pickShape(_shapeA);
        _target = 1;
      } else {
        _shapeA = _pickShape(_shapeB);
        _target = 0;
      }
    });
  }

  RoundedPolygon _pickShape(RoundedPolygon avoid) {
    final List<RoundedPolygon> shapes = _FloatingTile._shapes;
    RoundedPolygon s;
    do {
      s = shapes[_rng.nextInt(shapes.length)];
    } while (identical(s, avoid));
    return s;
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  static ShapeBorder _morphBorder(
    RoundedPolygon a,
    RoundedPolygon b,
    double t,
  ) {
    final MaterialShapeBorder na = MaterialShapeBorder(shape: a);
    if (t <= 0) return na;
    final MaterialShapeBorder nb = MaterialShapeBorder(shape: b);
    if (t >= 1) return nb;
    return na.lerpTo(nb, t)!;
  }

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final Channel? channel = widget.channel;

    return Positioned(
      left: widget.spec.left,
      top: widget.spec.top,
      width: widget.spec.size,
      height: widget.spec.size,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        // The morph runs on Material expressive spring physics, the same motion
        // the rest of the app morphs with.
        child: SingleMotionBuilder(
          motion: const MaterialSpringMotion.expressiveSpatialFast(),
          value: _target,
          from: 0.0,
          active: !reduceMotion,
          builder: (BuildContext context, double t, Widget? child) {
            final ShapeBorder shape = _morphBorder(
              _shapeA,
              _shapeB,
              t.clamp(0.0, 1.0),
            );
            return ClipPath(
              clipper: ShapeBorderClipper(shape: shape),
              child: child,
            );
          },
          // Solid tint until a channel arrives, then its cover art
          // cross-fades in on top — see [SmoothImage].
          child: SmoothImage(
            url: channel?.image,
            placeholderColor: channel?.seed ?? widget.placeholderSeed,
          ),
        ),
      ),
    );
  }
}