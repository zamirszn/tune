import 'package:flutter/material.dart';
import '../../../common/values/mock_data.dart';
import '../../../common/widgets/song_tile.dart';

/// Draggable "up next" queue sheet, reachable from the full player page.
class QueueSheet extends StatelessWidget {
  final Song currentSong;

  const QueueSheet({super.key, required this.currentSong});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 8),
            Container(width: 36, height: 4, decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            )),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Up next', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                children: MockCatalog.songs.map((s) => SongTile(song: s, onTap: () {})).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
