
class Song {
  final String id;
  final String title;
  final String artist;
  final String artworkSeed; // used to derive a placeholder color/gradient
  final Duration duration;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.artworkSeed,
    this.duration = const Duration(minutes: 3, seconds: 24),
  });
}

class Playlist {
  final String id;
  final String title;
  final String subtitle;
  final String artworkSeed;
  final List<Song> songs;

  const Playlist({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.artworkSeed,
    this.songs = const [],
  });
}

class Album {
  final String id;
  final String title;
  final String artist;
  final String artworkSeed;
  final int year;

  const Album({
    required this.id,
    required this.title,
    required this.artist,
    required this.artworkSeed,
    required this.year,
  });
}

class Artist {
  final String id;
  final String name;
  final String artworkSeed;
  final int monthlyListeners;

  const Artist({
    required this.id,
    required this.name,
    required this.artworkSeed,
    this.monthlyListeners = 0,
  });
}

/// Static mock catalog — swap for real API results later.
class MockCatalog {
  MockCatalog._();

  static final songs = List.generate(
    12,
    (i) => Song(
      id: 's$i',
      title: 'Song Title ${i + 1}',
      artist: 'Artist ${(i % 5) + 1}',
      artworkSeed: 's$i',
    ),
  );

  static final playlists = List.generate(
    8,
    (i) => Playlist(
      id: 'p$i',
      title: 'Playlist ${i + 1}',
      subtitle: '${20 + i} songs',
      artworkSeed: 'p$i',
      songs: songs,
    ),
  );

  static final albums = List.generate(
    8,
    (i) => Album(
      id: 'a$i',
      title: 'Album ${i + 1}',
      artist: 'Artist ${(i % 5) + 1}',
      artworkSeed: 'a$i',
      year: 2018 + (i % 8),
    ),
  );

  static final artists = List.generate(
    6,
    (i) => Artist(
      id: 'ar$i',
      name: 'Artist ${i + 1}',
      artworkSeed: 'ar$i',
      monthlyListeners: 100000 * (i + 1),
    ),
  );
}
