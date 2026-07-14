import 'package:flutter/material.dart';
import '../../../common/values/mock_data.dart';
import '../../../common/widgets/artwork.dart';
import '../../../common/widgets/song_tile.dart';
import '../../playlist/pages/playlist_detail_page.dart';
import '../../album/pages/album_detail_page.dart';
import '../../artist/pages/artist_detail_page.dart';

/// The Library tab — tabbed view over playlists, albums, artists, songs,
/// and downloads, mirroring YouTube Music's library structure.
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          const SliverAppBar(
            title: Text('Library'),
            floating: true,
            pinned: true,
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Playlists'),
                Tab(text: 'Albums'),
                Tab(text: 'Artists'),
                Tab(text: 'Songs'),
                Tab(text: 'Downloads'),
              ],
            ),
          ),
        ],
        body: const TabBarView(
          children: [
            _PlaylistsTab(),
            _AlbumsTab(),
            _ArtistsTab(),
            _SongsTab(),
            _DownloadsTab(),
          ],
        ),
      ),
    );
  }
}

class _PlaylistsTab extends StatelessWidget {
  const _PlaylistsTab();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const ListTile(
          leading: CircleAvatar(child: Icon(Icons.favorite_rounded)),
          title: Text('Liked songs'),
        ),
        const ListTile(
          leading: CircleAvatar(child: Icon(Icons.history_rounded)),
          title: Text('History'),
        ),
        const Divider(),
        ...MockCatalog.playlists.map((p) => ListTile(
              leading: Artwork(seed: p.artworkSeed, size: 48),
              title: Text(p.title),
              subtitle: Text(p.subtitle),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PlaylistDetailPage(playlist: p)),
              ),
            )),
      ],
    );
  }
}

class _AlbumsTab extends StatelessWidget {
  const _AlbumsTab();
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: MockCatalog.albums.length,
      itemBuilder: (context, i) {
        final a = MockCatalog.albums[i];
        return GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => AlbumDetailPage(album: a)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(aspectRatio: 1, child: Artwork(seed: a.artworkSeed, size: 200)),
              const SizedBox(height: 8),
              Text(a.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('${a.artist} · ${a.year}', maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        );
      },
    );
  }
}

class _ArtistsTab extends StatelessWidget {
  const _ArtistsTab();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: MockCatalog.artists
          .map((a) => ListTile(
                leading: CircleAvatar(radius: 24, child: Artwork(seed: a.artworkSeed, size: 44, borderRadius: BorderRadius.circular(22))),
                title: Text(a.name),
                subtitle: Text('${(a.monthlyListeners / 1000).toStringAsFixed(0)}K monthly listeners'),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ArtistDetailPage(artist: a)),
                ),
              ))
          .toList(),
    );
  }
}

class _SongsTab extends StatelessWidget {
  const _SongsTab();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: MockCatalog.songs.map((s) => SongTile(song: s, onTap: () {})).toList(),
    );
  }
}

class _DownloadsTab extends StatelessWidget {
  const _DownloadsTab();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.download_done_rounded, size: 48, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          const Text('No downloads yet'),
        ],
      ),
    );
  }
}
