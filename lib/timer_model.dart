import 'dart:async';

import 'package:flutter/foundation.dart';

enum Phase { work, shortBreak, longBreak }

/// In-memory pomodoro state machine.
///
/// 25-minute focus sessions with 5-minute short breaks. After every
/// [sessionsPerLongBreak] completed focus sessions the next break is a
/// long one. All state is in memory; nothing is persisted.
class PomodoroTimer extends ChangeNotifier {
  static const int workMinutes = 25;
  static const int shortBreakMinutes = 5;
  static const int longBreakMinutes = 20;
  static const int sessionsPerLongBreak = 4;

  Timer? _ticker;
  Phase _phase = Phase.work;
  int _remaining = workMinutes * 60;
  int _completedSessions = 0;
  bool _running = false;

  Phase get phase => _phase;
  bool get isRunning => _running;
  int get completedSessions => _completedSessions;
  int get remainingSeconds => _remaining;
  int get totalSeconds => _phaseMinutes * 60;

  int get _phaseMinutes => switch (_phase) {
        Phase.work => workMinutes,
        Phase.shortBreak => shortBreakMinutes,
        Phase.longBreak => longBreakMinutes,
      };

  void start() {
    if (_running) return;
    _running = true;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    notifyListeners();
  }

  void pause() {
    _ticker?.cancel();
    _ticker = null;
    _running = false;
    notifyListeners();
  }

  /// Stops the countdown and returns to a fresh 25-minute focus phase.
  /// The session counter is preserved.
  void reset() {
    pause();
    _phase = Phase.work;
    _remaining = workMinutes * 60;
    notifyListeners();
  }

  /// Skips to the next phase without counting the current one as done.
  void skip() => _complete(countSession: false);

  void _tick() {
    if (_remaining > 0) {
      _remaining--;
      notifyListeners();
    }
    if (_remaining == 0) {
      _complete(countSession: _phase == Phase.work);
    }
  }

  void _complete({required bool countSession}) {
    pause();
    if (countSession) _completedSessions++;
    _phase = _nextPhase();
    _remaining = _phaseMinutes * 60;
    notifyListeners();
  }

  Phase _nextPhase() {
    if (_phase == Phase.work) {
      return _completedSessions % sessionsPerLongBreak == 0
          ? Phase.longBreak
          : Phase.shortBreak;
    }
    return Phase.work;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
