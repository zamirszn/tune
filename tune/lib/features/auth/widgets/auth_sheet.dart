import 'dart:async';

import 'package:flutter/material.dart';
import '../models/auth_provider.dart';
import 'morph_sign_in_button.dart';
import '../../shell/pages/app_shell.dart';
import '../../../common/widgets/styled_sheet.dart';

/// Sign-in as a floating modal sheet: a headline and two sign-in buttons.
///
/// UI only. Tapping a provider shows a short loading beat, then closes the
/// sheet and replaces the page under it with the app shell.
///
/// Note: bunpod shows this via their own vendored `expressive_sheet`
/// package (`showExpressiveSheet`), which floats the sheet off all edges
/// with its own spring-driven entrance. That package isn't public, so
/// this uses Flutter's standard [showModalBottomSheet] with the shared
/// [StyledSheet] chrome instead — same rounded-sheet feel, no extra
/// dependency required.
class AuthSheet extends StatefulWidget {
  const AuthSheet({super.key, this.onSignedIn});

  /// Invoked after the sign-in beat. Defaults to entering the app shell.
  final VoidCallback? onSignedIn;

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AuthSheet(),
    );
  }

  @override
  State<AuthSheet> createState() => _AuthSheetState();
}

class _AuthSheetState extends State<AuthSheet> {
  static const _signInBeat = Duration(seconds: 2);

  Timer? _timer;
  AuthProvider? _signingIn;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _signIn(AuthProvider provider) {
    if (_signingIn != null) return;
    setState(() => _signingIn = provider);

    _timer = Timer(_signInBeat, () {
      if (!mounted) return;
      if (widget.onSignedIn != null) {
        widget.onSignedIn!();
        return;
      }
      final navigator = Navigator.of(context);
      navigator.pop();
      navigator.pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const AppShell()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: StyledSheet(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Tune in.',
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),
              MorphSignInButton(
                icon: Icon(Icons.g_mobiledata_rounded, size: 28, color: cs.onSecondaryContainer),
                label: 'Continue with Google',
                background: cs.secondaryContainer,
                foreground: cs.onSecondaryContainer,
                loading: _signingIn == AuthProvider.google,
                enabled: _signingIn != AuthProvider.apple,
                onTap: () => _signIn(AuthProvider.google),
              ),
              const SizedBox(height: 8),
              MorphSignInButton(
                icon: Icon(Icons.apple_rounded, size: 24, color: cs.surface),
                label: 'Continue with Apple',
                background: cs.onSurface,
                foreground: cs.surface,
                loading: _signingIn == AuthProvider.apple,
                enabled: _signingIn != AuthProvider.google,
                onTap: () => _signIn(AuthProvider.apple),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
