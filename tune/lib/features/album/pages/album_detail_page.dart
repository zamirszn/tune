import 'package:flutter/material.dart';
import '../../../common/values/mock_data.dart';
import '../../../common/widgets/artwork.dart';
import '../../../common/widgets/song_tile.dart';
import '../../../common/widgets/expressive_play_button.dart';

/// Album detail — cover art, artist/year, and tracklist.
class AlbumDetailPage extends StatelessWidget {
  final Album album;

  const AlbumDetailPage({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(24, 80, 24, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(child: Artwork(seed: album.artworkSeed, size: 160, borderRadius: BorderRadius.circular(16))),
                    const SizedBox(height: 16),
                    Text(album.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                    Text('${album.artist} · ${album.year}', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: const Icon(Icons.download_outlined), onPressed: () {}),
                  ExpressivePlayButton(isPlaying: false, onTap: () {}, size: 56),
                ],
              ),
            ),
          ),
          SliverList.builder(
            itemCount: MockCatalog.songs.length,
            itemBuilder: (context, i) => SongTile(
              song: MockCatalog.songs[i],
              index: i,
              showIndex: true,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
