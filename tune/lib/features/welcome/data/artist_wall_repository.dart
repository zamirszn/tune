import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tune/features/channel/models/channel.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' hide Channel;

/// Fetches a wall of real, currently-live YouTube artist channels to back the
/// [ChannelWall] on the welcome screen.
///
/// YouTube Music has no public API, so this goes straight to YouTube itself:
/// [YoutubeExplode]'s search client talks to the same channel-search endpoint
/// YouTube's own web client uses — no API key, no quota, no server of ours in
/// the middle. A broad set of genre/artist queries stands in for "browse the
/// catalog", since there's no single "trending artists" endpoint to call.
///
/// Two things this repository is careful about, beyond just calling search:
///
/// 1. **Every genre gets a fair shot.** A plain shuffle-and-cap over the
///    pooled results lets one or two high-yield genres crowd out low-yield
///    ones by chance — which read as "some genres just never show up".
///    [_interleave] round-robins one channel per genre per round instead, so
///    any genre that returned *something* is guaranteed a place before the
///    wall is capped at [_wallSize].
/// 2. **A flaky query doesn't mean a flaky wall.** Each genre query gets one
///    retry on failure or an empty result (see [_searchChannels]) before
///    it's allowed to contribute nothing.
///
/// Results are cached to disk (see [_readCache] / [_writeCache]) so the next
/// app launch can paint the wall instantly from yesterday's data while a
/// fresh copy is quietly fetched in the background for the launch after
/// that — see [fetchWall] for the exact policy.
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
    'amapiano artist',
    'reggae artist',
    'reggaeton artist',
    'edm dj',
    'house music dj',
    'techno artist',
    'indie folk artist',
    'country music artist',
    'latin pop artist',
    'salsa musician',
    'jazz musician',
    'blues musician',
    'metal band',
    'punjabi singer',
    'gospel artist',
    'anime soundtrack composer',
  ];

  /// How many channels to keep from each query before the pool is
  /// deduplicated, interleaved, and trimmed down to [_wallSize].
  static const int _perQuery = 6;

  /// Total tiles the welcome wall needs — comfortably covers a tall phone
  /// screen at the wall's target tile size, with room to spare.
  static const int _wallSize = 48;

  /// How long a cached wall is considered fresh enough to skip a background
  /// refetch entirely. Past this age, [fetchWall] still returns the cached
  /// wall instantly, but kicks off a silent refresh for next time.
  static const Duration _cacheTtl = Duration(hours: 6);

  static const String _cacheDataKey = 'artist_wall_cache_v1';
  static const String _cacheTimeKey = 'artist_wall_cache_time_v1';

  Future<List<Channel>>? _cache;

  /// Real YouTube artist channels for the welcome wall.
  ///
  /// - First call of the process: read the on-disk cache. If it's there,
  ///   return it immediately (regardless of age) so the wall never sits on
  ///   an empty future. If it's older than [_cacheTtl], also kick off a
  ///   background refetch that updates the disk cache for the *next*
  ///   launch — this call doesn't wait on it.
  /// - No disk cache yet (first-ever launch): fetch live, since there's
  ///   nothing else to show.
  /// - Later calls this same process: return the same in-memory future, so
  ///   repeat visits to this screen don't refetch or re-read disk.
  Future<List<Channel>> fetchWall() => _cache ??= _load();

  /// Drops the in-memory result so the next [fetchWall] call re-reads disk
  /// (and, if that's stale or missing, fetches live again).
  void refresh() => _cache = null;

  Future<List<Channel>> _load() async {
    final _CacheEntry? cached = await _readCache();
    if (cached != null) {
      if (DateTime.now().difference(cached.savedAt) > _cacheTtl) {
        unawaited(_refreshLive());
      }
      return cached.records.map(_ArtistRecord.toChannel).toList();
    }
    return _refreshLive();
  }

  /// Runs the live searches, persists the result to disk for next launch,
  /// and returns it as [Channel]s for this launch.
  Future<List<Channel>> _refreshLive() async {
    final List<_ArtistRecord> records = await _fetchRecords();
    if (records.isNotEmpty) await _writeCache(records);
    return records.map(_ArtistRecord.toChannel).toList();
  }

  Future<List<_ArtistRecord>> _fetchRecords() async {
    final YoutubeExplode yt = YoutubeExplode();
    try {
      final List<List<SearchChannel>> batches = await Future.wait(
        _queries.map((String q) => _searchChannels(yt, q)),
      );
      final List<SearchChannel> picked = _interleave(batches)
          .take(_wallSize)
          .toList()
        ..shuffle();
      return picked
          .map(
            (SearchChannel c) => _ArtistRecord(
              id: c.id.value,
              name: c.name,
              description: c.description.isNotEmpty
                  ? c.description
                  : '${c.videoCount} videos on YouTube',
              image: c.thumbnails
                  .reduce(
                    (Thumbnail a, Thumbnail b) => a.width >= b.width ? a : b,
                  )
                  .url
                  .toString(),
            ),
          )
          .toList();
    } finally {
      // Always release the underlying http client, even if a query above
      // threw something [_searchChannels] didn't already catch.
      yt.close();
    }
  }

  /// One genre query's worth of channels. Retries once on failure or an
  /// empty result — rate limiting or a hiccup in YouTube's response
  /// shouldn't be enough to make a whole genre vanish from the wall — and
  /// gives up quietly (returning an empty list) only after that.
  Future<List<SearchChannel>> _searchChannels(
    YoutubeExplode yt,
    String query,
  ) async {
    for (int attempt = 0; attempt < 2; attempt++) {
      try {
        final SearchList results = await yt.search.searchContent(
          query,
          filter: TypeFilters.channel,
        );
        final List<SearchChannel> channels = results
            .whereType<SearchChannel>()
            .where((SearchChannel c) => c.thumbnails.isNotEmpty)
            .take(_perQuery)
            .toList();
        if (channels.isNotEmpty) return channels;
      } catch (_) {
        // Fall through and retry once before giving up on this genre.
      }
    }
    return const <SearchChannel>[];
  }

  /// Round-robins one channel per genre per round (skipping ones already
  /// seen), so a genre that returned results is guaranteed a place near the
  /// front of the list — before [_wallSize] ever gets a chance to cut it out.
  List<SearchChannel> _interleave(List<List<SearchChannel>> batches) {
    final Set<String> seen = <String>{};
    final List<SearchChannel> result = <SearchChannel>[];
    int round = 0;
    bool addedAny;
    do {
      addedAny = false;
      for (final List<SearchChannel> batch in batches) {
        if (round >= batch.length) continue;
        addedAny = true;
        final SearchChannel c = batch[round];
        if (seen.add(c.id.value)) result.add(c);
      }
      round++;
    } while (addedAny);
    return result;
  }

  Future<_CacheEntry?> _readCache() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? raw = prefs.getString(_cacheDataKey);
      final int? savedAtMillis = prefs.getInt(_cacheTimeKey);
      if (raw == null || savedAtMillis == null) return null;

      final List<dynamic> json = jsonDecode(raw) as List<dynamic>;
      final List<_ArtistRecord> records = json
          .map(
            (dynamic e) => _ArtistRecord.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      if (records.isEmpty) return null;

      return _CacheEntry(
        records: records,
        savedAt: DateTime.fromMillisecondsSinceEpoch(savedAtMillis),
      );
    } catch (_) {
      // A corrupt or unreadable cache is no worse than no cache.
      return null;
    }
  }

  Future<void> _writeCache(List<_ArtistRecord> records) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _cacheDataKey,
        jsonEncode(records.map((_ArtistRecord r) => r.toJson()).toList()),
      );
      await prefs.setInt(_cacheTimeKey, DateTime.now().millisecondsSinceEpoch);
    } catch (_) {
      // Disk write failing just means we lose the speed-up next launch —
      // not worth surfacing to the UI.
    }
  }
}

class _CacheEntry {
  const _CacheEntry({required this.records, required this.savedAt});
  final List<_ArtistRecord> records;
  final DateTime savedAt;
}

/// The handful of fields we actually need from a [SearchChannel], kept
/// separately from [Channel] so it can round-trip through JSON for the disk
/// cache. [Channel.seed] isn't stored — it's cheap to rederive from [id]
/// (see [_seedFrom]), so a cached wall regenerates identical placeholder
/// tints without spending any bytes on them.
class _ArtistRecord {
  const _ArtistRecord({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  final String id;
  final String name;
  final String description;
  final String image;

  static Channel toChannel(_ArtistRecord r) => Channel(
    name: r.name,
    host: r.name,
    seed: _seedFrom(r.id),
    image: r.image,
    description: r.description,
  );

  Map<String, String> toJson() => <String, String>{
    'id': id,
    'name': name,
    'description': description,
    'image': image,
  };

  factory _ArtistRecord.fromJson(Map<String, dynamic> json) => _ArtistRecord(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    image: json['image'] as String,
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