/// A user's "I'm usually here on {weekday} between {start} and {end}" record.
///
/// The substrate that makes 30 hand-recruited users feel like a scene per
/// the brief. The user never sees the word "recurring" or "intent" — these
/// hydrate the NOW screen as live ("on the wall now") if the current time
/// is inside the window, or expected ("usually Tuesdays") if it isn't yet.
class RecurringIntent {
  final String id;
  final String userId;
  final String cragId;

  /// Dart's DateTime.weekday convention: 1=Mon ... 7=Sun.
  final int weekday;

  /// Minutes since midnight.
  final int startMinute;
  final int endMinute;

  final bool active;

  const RecurringIntent({
    required this.id,
    required this.userId,
    required this.cragId,
    required this.weekday,
    required this.startMinute,
    required this.endMinute,
    this.active = true,
  });

  RecurringIntent copyWith({bool? active}) => RecurringIntent(
        id: id,
        userId: userId,
        cragId: cragId,
        weekday: weekday,
        startMinute: startMinute,
        endMinute: endMinute,
        active: active ?? this.active,
      );

  /// True if `now` falls inside the [startMinute, endMinute) window on the
  /// intent's weekday.
  bool isLiveAt(DateTime now) {
    if (now.weekday != weekday || !active) return false;
    final m = now.hour * 60 + now.minute;
    return m >= startMinute && m < endMinute;
  }

  /// True if the intent is later today and hasn't started yet.
  bool isExpectedAt(DateTime now) {
    if (now.weekday != weekday || !active) return false;
    final m = now.hour * 60 + now.minute;
    return startMinute > m;
  }
}
