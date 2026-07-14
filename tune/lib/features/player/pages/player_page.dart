import 'package:flutter/material.dart';
import '../../../common/values/mock_data.dart';
import '../../../common/widgets/artwork.dart';
import '../../../common/widgets/expressive_play_button.dart';
import '../widgets/queue_sheet.dart';

/// The full "Now Playing" screen — large artwork, expressive morphing
/// play button, progress bar, and quick access to queue/lyrics via a
/// bottom sheet, matching YouTube Music's full player.
class PlayerPage extends StatelessWidget {
  final Song song;
  final bool isPlaying;
  final VoidCallback onPlayPause;

  const PlayerPage({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.onPlayPause,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Now Playing'),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert_rounded), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(),
              AspectRatio(
                aspectRatio: 1,
                child: Artwork(seed: song.artworkSeed, size: 400, borderRadius: BorderRadius.circular(24)),
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(song.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(song.artist, style: theme.textTheme.bodyLarge),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Slider(value: 0.35, onChanged: (_) {}),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('1:12'),
                  Text('3:24'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(icon: const Icon(Icons.shuffle_rounded), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.skip_previous_rounded, size: 36), onPressed: () {}),
                  ExpressivePlayButton(isPlaying: isPlaying, onTap: onPlayPause, size: 72),
                  IconButton(icon: const Icon(Icons.skip_next_rounded, size: 36), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.repeat_rounded), onPressed: () {}),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: const Icon(Icons.favorite_border_rounded), onPressed: () {}),
                  TextButton.icon(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => QueueSheet(currentSong: song),
                    ),
                    icon: const Icon(Icons.queue_music_rounded),
                    label: const Text('Queue'),
                  ),
                  IconButton(icon: const Icon(Icons.lyrics_outlined), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
