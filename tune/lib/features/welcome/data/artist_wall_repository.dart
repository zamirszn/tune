import 'package:flutter/material.dart';
import 'package:tune/features/channel/models/channel.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' hide Channel;

/// Fetches a wall of real, currently-live YouTube artist channels to back the
/// [ChannelWall] on the welcome screen.
///
/// YouTube Music has no public API, so this goes straight to YouTube itself:
/// [YoutubeExplode]'s search client talks to the same channel-search endpoint
/// YouTube's own web client uses — no API key, no quota, no server of ours in
/// the middle. A handful of genre/artist queries spanning the catalog (pop,
/// hip hop, k-pop, afrobeats, and so on) stand in for "browse the catalog",
/// since there's no single "trending artists" endpoint to call. Results are
/// pooled, deduplicated by channel id, shuffled, and capped, then cached for
/// the life of the app so the wall doesn't refetch every time this screen is
/// shown.
class ArtistWallRepository {
  ArtistWallRepository._();

  static final ArtistWallRepository instance = ArtistWallRepository._();

  /// Broad, genre-spanning queries so the wall reads like YouTube Music's
  /// whole catalog rather than one corner of it.
  static const List<String> _queries = <String>[
    'pop music artist',
    'hip hop artist',
    'r&b singer',
    'rock band',
    'k-pop group',
    'afrobeats artist',
    'reggaeton artist',
    'edm dj',
    'indie folk artist',
    'country music artist',
    'latin pop artist',
    'jazz musician',
  ];

  /// How many channels to keep from each query before the pool is
  /// deduplicated, shuffled, and trimmed down to [_wallSize].
  static const int _perQuery = 6;

  /// Total tiles the welcome wall needs — comfortably covers a tall phone
  /// screen at the wall's target tile size, with room to spare.
  static const int _wallSize = 48;

  Future<List<Channel>>? _cache;

  /// Real YouTube artist channels for the welcome wall. Cached for the life
  /// of the app; call [refresh] to force a refetch.
  Future<List<Channel>> fetchWall() => _cache ??= _fetch();

  /// Clears the cache so the next [fetchWall] call fetches fresh data.
  void refresh() => _cache = null;

  Future<List<Channel>> _fetch() async {
    final YoutubeExplode yt = YoutubeExplode();
    try {
      final List<List<SearchChannel>> batches = await Future.wait(
        _queries.map((String q) => _searchChannels(yt, q)),
      );

      final Map<String, SearchChannel> byId = <String, SearchChannel>{};
      for (final List<SearchChannel> batch in batches) {
        for (final SearchChannel c in batch) {
          byId[c.id.value] = c;
        }
      }

      final List<SearchChannel> pool = byId.values.toList()..shuffle();
      final List<SearchChannel> picked = pool.take(_wallSize).toList();

      return picked.map(_toChannel).toList();
    } finally {
      // Always release the underlying http client, even if a query above
      // threw something [_searchChannels] didn't already catch.
      yt.close();
    }
  }

  /// One genre query's worth of channels, or an empty list if that
  /// particular query fails. A single failing query — rate limiting, a
  /// parsing change on YouTube's end — shouldn't take down the whole wall.
  Future<List<SearchChannel>> _searchChannels(
    YoutubeExplode yt,
    String query,
  ) async {
    try {
      final SearchList results = await yt.search.searchContent(
        query,
        filter: TypeFilters.channel,
      );
      return results
          .whereType<SearchChannel>()
          .where((SearchChannel c) => c.thumbnails.isNotEmpty)
          .take(_perQuery)
          .toList();
    } catch (_) {
      return const <SearchChannel>[];
    }
  }

  Channel _toChannel(SearchChannel c) {
    final Thumbnail thumb = c.thumbnails.reduce(
      (Thumbnail a, Thumbnail b) => a.width >= b.width ? a : b,
    );
    return Channel(
      name: c.name,
      host: c.name,
      seed: _seedFrom(c.id.value),
      image: thumb.url.toString(),
      description: c.description.isNotEmpty
          ? c.description
          : '${c.videoCount} videos on YouTube',
    );
  }

  /// A stable, pleasant seed color derived from the channel id, so the same
  /// channel always gets the same placeholder tint across sessions.
  Color _seedFrom(String id) {
    final int hash = id.codeUnits.fold<int>(
      0,
      (int h, int unit) => (h * 31 + unit) & 0x7fffffff,
    );
    final double hue = (hash % 360).toDouble();
    return HSLColor.fromAHSL(1, hue, 0.55, 0.45).toColor();
  }
}