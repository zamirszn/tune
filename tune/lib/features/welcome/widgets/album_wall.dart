import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:motor/motor.dart';
import '../../../common/values/mock_data.dart';
import '../../../common/widgets/artwork.dart';

/// A full-bleed mosaic of album/playlist artwork that starts as an
/// edge-to-edge grid of squares. Each tile holds as a square for a beat,
/// then morphs — once — into an expressive [MaterialShapes] silhouette
/// (cookie, gem, flower, clover...), opening up the negative space between
/// covers. Tapping a tile morphs it again into a fresh random shape.
///
/// Mirrors bunpod's own ChannelWall: same shape catalog, same hold-then-
/// settle timing, same tap-to-reshape easter egg — swapped to TUNE's
/// mock album/playlist artwork instead of podcast channel covers.
class AlbumWall extends StatelessWidget {
  const AlbumWall({super.key});

  static const double _targetTile = 118;

  static List<_TileSpec> _layoutFor(double w, double h, int catalogSize) {
    final cols = (w / _targetTile).round().clamp(3, 5);
    final cell = w / cols;
    final rows = (h / cell).ceil();

    final specs = <_TileSpec>[];
    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final i = row * cols + col;
        specs.add(_TileSpec(
          index: i,
          left: col * cell,
          top: row * cell,
          size: cell,
          artworkIndex: i % catalogSize,
          shape: i % _FloatingTile.shapeCount,
        ));
      }
    }
    return specs;
  }

  @override
  Widget build(BuildContext context) {
    final artworkSeeds = [
      ...MockCatalog.albums.map((a) => a.artworkSeed),
      ...MockCatalog.playlists.map((p) => p.artworkSeed),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = _layoutFor(constraints.maxWidth, constraints.maxHeight, artworkSeeds.length);
        return Stack(
          children: [
            for (final spec in layout)
              _FloatingTile(
                key: ValueKey(spec.index),
                seed: artworkSeeds[spec.artworkIndex],
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
    required this.artworkIndex,
    required this.shape,
  });

  final int index;
  final double left;
  final double top;
  final double size;
  final int artworkIndex;

  /// Index into the shared settle-shape table.
  final int shape;
}

class _FloatingTile extends StatefulWidget {
  const _FloatingTile({super.key, required this.seed, required this.spec});

  final String seed;
  final _TileSpec spec;

  // The expressive shape each square settles into — same catalog bunpod
  // uses for its ChannelWall tiles.
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

  @override
  State<_FloatingTile> createState() => _FloatingTileState();
}

class _FloatingTileState extends State<_FloatingTile> {
  static final RoundedPolygon _square = MaterialShapes.square;

  /// How long the tile is held as a square before it morphs.
  static const Duration _hold = Duration(milliseconds: 300);

  Timer? _holdTimer;
  final math.Random _rng = math.Random();

  // The tile morphs between two shape slots; [_target] (0 or 1) says which
  // one it is currently heading to. It starts as a square heading to its
  // settle shape; tapping swaps the slot it's leaving for a fresh random
  // shape, so it ping-pongs to a new shape on every tap.
  late RoundedPolygon _shapeA = _square;
  late RoundedPolygon _shapeB =
      _FloatingTile._shapes[widget.spec.shape % _FloatingTile._shapes.length];
  double _target = 0;

  @override
  void initState() {
    super.initState();
    final reduceMotion = WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    if (reduceMotion) {
      _target = 1;
      return;
    }
    // Stagger the settle so tiles don't all morph in lockstep.
    _holdTimer = Timer(_hold + Duration(milliseconds: _rng.nextInt(400)), () {
      if (mounted) setState(() => _target = 1);
    });
  }

  /// Tap a cover to morph it to a fresh random shape, on the same
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
    final shapes = _FloatingTile._shapes;
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

  static ShapeBorder _morphBorder(RoundedPolygon a, RoundedPolygon b, double t) {
    final borderA = MaterialShapeBorder(shape: a);
    if (t <= 0) return borderA;
    final borderB = MaterialShapeBorder(shape: b);
    if (t >= 1) return borderB;
    return borderA.lerpTo(borderB, t)!;
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return Positioned(
      left: widget.spec.left,
      top: widget.spec.top,
      width: widget.spec.size,
      height: widget.spec.size,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        // The morph runs on the same Material expressive spring physics
        // the play button and sign-in buttons use elsewhere in the app.
        child: SingleMotionBuilder(
          motion: const MaterialSpringMotion.expressiveSpatialFast(),
          value: _target,
          from: 0.0,
          active: !reduceMotion,
          builder: (context, t, child) {
            final shape = _morphBorder(_shapeA, _shapeB, t.clamp(0.0, 1.0));
            return ClipPath(
              clipper: ShapeBorderClipper(shape: shape),
              child: child,
            );
          },
          child: Artwork(seed: widget.seed, size: widget.spec.size, borderRadius: BorderRadius.zero),
        ),
      ),
    );
  }
}