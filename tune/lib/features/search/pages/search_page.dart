import 'package:flutter/material.dart';
import '../../../common/values/mock_data.dart';
import '../../../common/widgets/song_tile.dart';
import '../../../common/widgets/artwork.dart';

/// Full-screen search: text field up top, tabbed results below
/// (Songs / Albums / Artists / Playlists), matching YouTube Music's
/// search experience.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Search songs, albums, artists…',
              border: InputBorder.none,
            ),
          ),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Songs'),
              Tab(text: 'Albums'),
              Tab(text: 'Artists'),
              Tab(text: 'Playlists'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(children: MockCatalog.songs.map((s) => SongTile(song: s, onTap: () {})).toList()),
            ListView(
              children: MockCatalog.albums
                  .map((a) => ListTile(
                        leading: Artwork(seed: a.artworkSeed, size: 48),
                        title: Text(a.title),
                        subtitle: Text(a.artist),
                      ))
                  .toList(),
            ),
            ListView(
              children: MockCatalog.artists
                  .map((a) => ListTile(
                        leading: CircleAvatar(child: Artwork(seed: a.artworkSeed, size: 40, borderRadius: BorderRadius.circular(20))),
                        title: Text(a.name),
                      ))
                  .toList(),
            ),
            ListView(
              children: MockCatalog.playlists
                  .map((p) => ListTile(
                        leading: Artwork(seed: p.artworkSeed, size: 48),
                        title: Text(p.title),
                        subtitle: Text(p.subtitle),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
