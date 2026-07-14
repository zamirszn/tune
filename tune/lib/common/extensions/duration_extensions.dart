/// Formatting helpers for [Duration], used by the player progress row and
/// song tiles (e.g. "3:24").
extension DurationFormatting on Duration {
  String get mmss {
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
