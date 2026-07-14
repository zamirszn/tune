import 'package:flutter/material.dart';
import '../../../common/values/mock_data.dart';
import '../../../common/widgets/artwork.dart';
import '../../../common/widgets/section_carousel.dart';
import '../../../common/widgets/song_tile.dart';

/// Artist detail — banner art, monthly listeners, top songs, and
/// discography carousel.
class ArtistDetailPage extends StatelessWidget {
  final Artist artist;

  const ArtistDetailPage({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Artwork(seed: artist.artworkSeed, size: 400, borderRadius: BorderRadius.zero),
              title: Text(artist.name),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${(artist.monthlyListeners / 1000).toStringAsFixed(0)}K monthly listeners'),
                  FilledButton.tonalIcon(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none_rounded),
                    label: const Text('Subscribe'),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Top songs', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            ),
          ),
          SliverList.builder(
            itemCount: 5,
            itemBuilder: (context, i) => SongTile(song: MockCatalog.songs[i], index: i, showIndex: true, onTap: () {}),
          ),
          SliverToBoxAdapter(
            child: SectionCarousel(
              title: 'Albums',
              items: MockCatalog.albums
                  .map((a) => CarouselItem(title: a.title, subtitle: '${a.year}', artworkSeed: a.artworkSeed))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
