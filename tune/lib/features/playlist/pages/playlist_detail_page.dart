import 'package:flutter/material.dart';
import '../../../common/values/mock_data.dart';
import '../../../common/widgets/artwork.dart';
import '../../../common/widgets/song_tile.dart';
import '../../../common/widgets/expressive_play_button.dart';

/// Playlist detail — header art, title/subtitle, shuffle/play controls,
/// and the full track list.
class PlaylistDetailPage extends StatelessWidget {
  final Playlist playlist;

  const PlaylistDetailPage({super.key, required this.playlist});

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Artwork(seed: playlist.artworkSeed, size: 160, borderRadius: BorderRadius.circular(16))),
                    const SizedBox(height: 16),
                    Text(playlist.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                    Text(playlist.subtitle, style: Theme.of(context).textTheme.bodyMedium),
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
                  Row(
                    children: [
                      IconButton(icon: const Icon(Icons.download_outlined), onPressed: () {}),
                      IconButton(icon: const Icon(Icons.shuffle_rounded), onPressed: () {}),
                    ],
                  ),
                  ExpressivePlayButton(isPlaying: false, onTap: () {}, size: 56),
                ],
              ),
            ),
          ),
          SliverList.builder(
            itemCount: playlist.songs.length,
            itemBuilder: (context, i) => SongTile(
              song: playlist.songs[i],
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
