import 'package:flutter/material.dart';
import '../values/shape_values.dart';

/// Shared chrome for modal bottom sheets — drag handle + rounded top
/// corners + optional title. Used by the queue sheet, song context menu,
/// and auth sheet so they all feel like one family instead of each
/// re-implementing the handle/padding.
class StyledSheet extends StatelessWidget {
  final String? title;
  final Widget child;

  const StyledSheet({super.key, this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: ShapeValues.sheetTop,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title!, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              ),
            ),
          Flexible(child: child),
        ],
      ),
    );
  }
}
