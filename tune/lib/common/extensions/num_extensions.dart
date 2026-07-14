/// Compact number formatting for listener counts, play counts, etc.
/// (e.g. 1500 -> "1.5K", 2400000 -> "2.4M").
extension CompactNumber on num {
  String get compact {
    if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    }
    if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }
}
