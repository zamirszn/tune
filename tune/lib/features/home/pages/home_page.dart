import 'package:flutter/material.dart';
import '../../../common/values/mock_data.dart';
import '../../../common/widgets/section_carousel.dart';
import '../../../common/widgets/song_tile.dart';
import '../../account/pages/account_page.dart';

/// The Home tab — YouTube Music's landing feed: quick picks, mixed-for-you
/// carousels, and a "listen again" style list, topped by a category chip row.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: const Text('Home'),
          actions: [
            IconButton(
              icon: const CircleAvatar(radius: 14, child: Icon(Icons.person_rounded, size: 18)),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AccountPage()),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        SliverToBoxAdapter(child: _CategoryChips()),
        SliverToBoxAdapter(
          child: SectionCarousel(
            title: 'Quick picks',
            items: MockCatalog.albums
                .map((a) => CarouselItem(title: a.title, subtitle: a.artist, artworkSeed: a.artworkSeed))
                .toList(),
          ),
        ),
        SliverToBoxAdapter(
          child: SectionCarousel(
            title: 'Mixed for you',
            items: MockCatalog.playlists
                .map((p) => CarouselItem(title: p.title, subtitle: p.subtitle, artworkSeed: p.artworkSeed))
                .toList(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 16, bottom: 24),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text('Listen again', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                ),
                ...MockCatalog.songs.take(5).map((s) => SongTile(song: s, onTap: () {})),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips();

  @override
  Widget build(BuildContext context) {
    const categories = ['Relax', 'Energize', 'Workout', 'Focus', 'Commute', 'Feel good'];
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) => ChoiceChip(
          label: Text(categories[i]),
          selected: false,
          onSelected: (_) {},
        ),
      ),
    );
  }
}
