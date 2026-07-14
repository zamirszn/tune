import 'package:flutter/material.dart';
import '../../home/pages/home_page.dart';
import '../../explore/pages/explore_page.dart';
import '../../library/pages/library_page.dart';
import '../../search/pages/search_page.dart';
import '../../player/pages/player_page.dart';
import '../widgets/mini_player.dart';
import '../../../common/values/mock_data.dart';

/// Root scaffold: bottom nav (Home / Explore / Library) + a persistent
/// mini-player docked above it, mirroring YouTube Music's own shell.
/// Tapping the mini-player expands into the full [PlayerPage].
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
 final Song _nowPlaying = MockCatalog.songs.first;
  bool _isPlaying = false;

  static const _pages = [HomePage(), ExplorePage(), LibraryPage()];

  void _openPlayer() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, _, _) => PlayerPage(
          song: _nowPlaying,
          isPlaying: _isPlaying,
          onPlayPause: () => setState(() => _isPlaying = !_isPlaying),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: _pages[_index]),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            MiniPlayer(
              song: _nowPlaying,
              isPlaying: _isPlaying,
              onTap: _openPlayer,
              onPlayPause: () => setState(() => _isPlaying = !_isPlaying),
            ),
          NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore_rounded), label: 'Explore'),
              NavigationDestination(icon: Icon(Icons.library_music_outlined), selectedIcon: Icon(Icons.library_music_rounded), label: 'Library'),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchPage()),
              ),
              child: const Icon(Icons.search_rounded),
            )
          : null,
    );
  }
}
