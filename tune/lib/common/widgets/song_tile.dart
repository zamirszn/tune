import 'package:flutter/material.dart';
import '../values/mock_data.dart';
import 'artwork.dart';

/// A single song row used across Home, Search, Library, and Playlist
/// pages. Tapping plays the song; the trailing button opens the
/// context menu (add to playlist, download, share, etc).
class SongTile extends StatelessWidget {
  final Song song;
  final VoidCallback? onTap;
  final VoidCallback? onMore;
  final bool showIndex;
  final int? index;

  const SongTile({
    super.key,
    required this.song,
    this.onTap,
    this.onMore,
    this.showIndex = false,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: showIndex
          ? SizedBox(
              width: 40,
              child: Text(
                '${(index ?? 0) + 1}',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
            )
          : Artwork(seed: song.artworkSeed, size: 48),
      title: Text(
        song.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        song.artist,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert_rounded),
        onPressed: onMore,
      ),
      onTap: onTap,
    );
  }
}
