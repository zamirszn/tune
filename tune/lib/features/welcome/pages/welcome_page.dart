import 'package:flutter/material.dart';
import '../../auth/widgets/auth_sheet.dart';
import '../widgets/album_wall.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, this.onStart});

  final VoidCallback? onStart;

  // BunPod-accurate Warm Editorial Palette
  static const Color creamBg = Color(0xFFF6F4EB);
  static const Color oliveGreen = Color(0xFF5D5E1A);
  static const Color charcoalText = Color(0xFF1C1C16);
  static const Color softGreyText = Color(0xFF706F68);

  void _start(BuildContext context) {
    if (onStart != null) {
      onStart!();
      return;
    }
    AuthSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: creamBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. The living wall of YouTube Music artwork
          const AlbumWall(),

          // 2. Linear Scrim matching the exact Warm Cream tone
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    creamBg.withValues(alpha: 0.1),
                    creamBg.withValues(alpha: 0.45),
                    creamBg.withValues(alpha: 0.9),
                    creamBg,
                  ],
                  stops: const [0.0, 0.40, 0.70, 0.88],
                ),
              ),
            ),
          ),

          // 3. Foreground Branding & Typography
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Brand Wordmark + Expressive Shape Logo
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFD6C561), // BunPod's muted gold accent
                            // TODO: Pass your 8-pointed scalloped shape from material_shapes here
                            shape: CircleBorder(), 
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'TUNE',
                          style: textTheme.titleLarge?.copyWith(
                            color: charcoalText,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Main Headline
                    Text(
                      'Every track, your shape.',
                      style: textTheme.headlineMedium?.copyWith(
                        color: charcoalText,
                        fontWeight: FontWeight.w800,
                        fontSize: 34,
                        height: 1.1,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle / Description
                    Text(
                      'Search, play, and organize the music you already listen to — with an interface built to move.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: softGreyText,
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // CTA Start Button
                    FilledButton(
                      onPressed: () => _start(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: oliveGreen,
                        foregroundColor: creamBg,
                        minimumSize: const Size.fromHeight(64),
                        elevation: 0,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Start Listening',
                            style: textTheme.titleMedium?.copyWith(
                              color: creamBg,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 20,
                            color: creamBg,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
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