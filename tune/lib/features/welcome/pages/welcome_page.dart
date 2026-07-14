import 'package:flutter/material.dart';
import '../../auth/widgets/auth_sheet.dart';
import '../widgets/album_wall.dart';

/// The first impression of TUNE: a living wall of album/playlist artwork
/// behind a scrim, the wordmark, a short promise, and a single clear
/// action. The wall stays tappable underneath (tap a tile to re-settle
/// its shape) because the scrim is [IgnorePointer] and the copy/CTA sit
/// bottom-anchored rather than covering the whole screen.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, this.onStart});

  final VoidCallback? onStart;

  void _start(BuildContext context) {
    if (onStart != null) {
      onStart!();
      return;
    }
    AuthSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Living, tappable wall of artwork.
          const AlbumWall(),

          // Scrim: fades to solid surface color where the copy/CTA live,
          // so text stays legible without washing out the art up top.
          // IgnorePointer so it never eats taps meant for the wall.
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          cs.surface.withValues(alpha: 0.30),
                          cs.surface.withValues(alpha: 0.55),
                          cs.surface.withValues(alpha: 0.94),
                          cs.surface,
                        ]
                      : [
                          cs.surface.withValues(alpha: 0.0),
                          cs.surface.withValues(alpha: 0.0),
                          cs.surface.withValues(alpha: 0.88),
                          cs.surface,
                        ],
                  stops: isDark
                      ? const [0.0, 0.42, 0.72, 0.9]
                      : const [0.0, 0.46, 0.74, 0.88],
                ),
              ),
            ),
          ),

          // Foreground copy + CTA — static, bottom-anchored so the mosaic
          // above stays interactive.
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TUNE',
                          style: text.headlineSmall?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Every track, your shape.',
                          style: text.headlineMedium?.copyWith(
                            color: cs.onSurface,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Search, play, and organize the music you already '
                          'listen to — with an interface built to move.',
                          style: text.bodyLarge?.copyWith(
                            color: cs.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: () => _start(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: cs.primary,
                        foregroundColor: cs.onPrimary,
                        minimumSize: const Size.fromHeight(60),
                        shape: const StadiumBorder(),
                        textStyle: text.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Start Listening'),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
