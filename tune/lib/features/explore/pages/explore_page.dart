import 'package:flutter/material.dart';
import '../../../common/values/mock_data.dart';
import '../../../common/widgets/section_carousel.dart';

/// The Explore tab — charts, new releases, and moods & genres, matching
/// YouTube Music's discovery surface.
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(floating: true, title: Text('Explore')),
        SliverToBoxAdapter(
          child: SectionCarousel(
            title: 'Charts',
            items: MockCatalog.songs
                .take(6)
                .map((s) => CarouselItem(title: s.title, subtitle: s.artist, artworkSeed: s.artworkSeed))
                .toList(),
          ),
        ),
        SliverToBoxAdapter(
          child: SectionCarousel(
            title: 'New releases',
            items: MockCatalog.albums
                .map((a) => CarouselItem(title: a.title, subtitle: '${a.artist} · ${a.year}', artworkSeed: a.artworkSeed))
                .toList(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Moods & genres', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                _MoodGrid(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MoodGrid extends StatelessWidget {
  const _MoodGrid();

  static const moods = [
    ('Chill', Color(0xFF6750A4)),
    ('Energize', Color(0xFFB3261E)),
    ('Party', Color(0xFF386A20)),
    ('Sad', Color(0xFF31629B)),
    ('Focus', Color(0xFF8E5D00)),
    ('Sleep', Color(0xFF6A3F8A)),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.4,
      ),
      itemCount: moods.length,
      itemBuilder: (context, i) {
        final (label, color) = moods[i];
        return Container(
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
          child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
        );
      },
    );
  }
}
