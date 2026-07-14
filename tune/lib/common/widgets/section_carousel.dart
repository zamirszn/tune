import 'package:flutter/material.dart';
import 'artwork.dart';

/// A titled horizontal carousel of cards — used for "Quick picks",
/// "Recommended albums", "New releases", mood/genre grids, etc.
class SectionCarousel extends StatelessWidget {
  final String title;
  final List<CarouselItem> items;
  final VoidCallback? onSeeAll;

  const SectionCarousel({
    super.key,
    required this.title,
    required this.items,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              if (onSeeAll != null)
                TextButton(onPressed: onSeeAll, child: const Text('See all')),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final item = items[i];
              return SizedBox(
                width: 140,
                child: GestureDetector(
                  onTap: item.onTap,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Artwork(seed: item.artworkSeed, size: 140),
                      const SizedBox(height: 8),
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      if (item.subtitle != null)
                        Text(
                          item.subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CarouselItem {
  final String title;
  final String? subtitle;
  final String artworkSeed;
  final VoidCallback? onTap;

  const CarouselItem({
    required this.title,
    this.subtitle,
    required this.artworkSeed,
    this.onTap,
  });
}
