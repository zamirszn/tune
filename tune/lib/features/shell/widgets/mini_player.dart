import 'package:flutter/material.dart';
import '../../../common/values/mock_data.dart';
import '../../../common/widgets/artwork.dart';

/// Docked mini-player shown above the bottom nav bar. Tapping it opens
/// the full [PlayerPage]; the play/pause button works in place without
/// navigating.
class MiniPlayer extends StatelessWidget {
  final Song song;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback onPlayPause;

  const MiniPlayer({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.onTap,
    required this.onPlayPause,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Artwork(seed: song.artworkSeed, size: 40, borderRadius: BorderRadius.circular(8)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                onPressed: onPlayPause,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next_rounded),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
