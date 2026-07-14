import 'package:flutter/material.dart';
import 'package:tune/features/welcome/pages/welcome_page.dart';

class AuthSheet extends StatelessWidget {
  const AuthSheet({super.key});

  static const Color modalBg = Color(0xFFEFECE0);    // Inner container sand color
  static const Color buttonBg = Color(0xFFE4DFD5);   // Soft cream-tan for authentication button
  static const Color darkPillBg = Color(0xFF1E1E1B); // The dark physical accent block at the bottom

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Keeps the outer bounding space invisible for the floating look
      elevation: 0,
      builder: (context) => const AuthSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      // Provides the distinct floating margins from screen boundaries
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: modalBg,
          borderRadius: BorderRadius.circular(42), // Material 3 Expressive Ultra-Large Corners
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Text
            Center(
              child: Text(
                'Tune in.',
                style: textTheme.headlineMedium?.copyWith(
                  color: WelcomePage.charcoalText,
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                  letterSpacing: -0.8,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Google Sign-In Action Item
            InkWell(
              onTap: () {
                // TODO: Wire up your google authentication pipeline here
                Navigator.of(context).pop();
              },
              borderRadius: BorderRadius.circular(32),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: buttonBg,
                  borderRadius: BorderRadius.circular(32),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Clean asset or flat icon for the branding vector
                    Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_\"G\"_logo.svg',
                      height: 22,
                      width: 22,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.g_mobiledata_rounded,
                        size: 28,
                        color: WelcomePage.charcoalText,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Continue with Google',
                      style: textTheme.titleMedium?.copyWith(
                        color: WelcomePage.charcoalText.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tactile Accent Pill Block 
            Center(
              child: Container(
                height: 56,
                width: 130,
                decoration: BoxDecoration(
                  color: darkPillBg,
                  borderRadius: BorderRadius.circular(28),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: CircleBorder(), 
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}