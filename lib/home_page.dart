import 'package:flutter/material.dart';

import 'timer_model.dart';

class PomodoroHomePage extends StatefulWidget {
  const PomodoroHomePage({super.key});

  @override
  State<PomodoroHomePage> createState() => _PomodoroHomePageState();
}

class _PomodoroHomePageState extends State<PomodoroHomePage> {
  final PomodoroTimer _timer = PomodoroTimer();

  @override
  void dispose() {
    _timer.dispose();
    super.dispose();
  }

  String get _phaseLabel => switch (_timer.phase) {
        Phase.work => 'Focus',
        Phase.shortBreak => 'Short break',
        Phase.longBreak => 'Long break',
      };

  String _format(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro Focus')),
      body: ListenableBuilder(
        listenable: _timer,
        builder: (context, _) {
          final scheme = Theme.of(context).colorScheme;
          final color = switch (_timer.phase) {
            Phase.work => scheme.primary,
            Phase.shortBreak => scheme.tertiary,
            Phase.longBreak => scheme.secondary,
          };
          final total = _timer.totalSeconds;
          final remaining = _timer.remainingSeconds;
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _phaseLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 240,
                          height: 240,
                          child: CircularProgressIndicator(
                            value:
                                total == 0 ? 0 : (total - remaining) / total,
                            strokeWidth: 10,
                            strokeCap: StrokeCap.round,
                            color: color,
                            backgroundColor:
                                scheme.surfaceContainerHighest,
                          ),
                        ),
                        Text(
                          _format(remaining),
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      PomodoroTimer.sessionsPerLongBreak,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          _dotIcon(index),
                          size: 18,
                          color:
                              _dotIsLit(index) ? color : scheme.outlineVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '🍅 Sessions completed: ${_timer.completedSessions}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.outlined(
                        onPressed: _timer.reset,
                        tooltip: 'Reset timer',
                        icon: const Icon(Icons.restart_alt),
                      ),
                      const SizedBox(width: 16),
                      FilledButton.icon(
                        onPressed: _timer.isRunning
                            ? _timer.pause
                            : _timer.start,
                        icon: Icon(_timer.isRunning
                            ? Icons.pause
                            : Icons.play_arrow),
                        label: Text(_timer.isRunning ? 'Pause' : 'Start'),
                      ),
                      const SizedBox(width: 16),
                      IconButton.outlined(
                        onPressed: _timer.skip,
                        tooltip: 'Skip phase',
                        icon: const Icon(Icons.skip_next),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _dotIsLit(int index) {
    if (_timer.phase == Phase.longBreak) return true;
    return index < _timer.completedSessions % PomodoroTimer.sessionsPerLongBreak;
  }

  IconData _dotIcon(int index) {
    if (_dotIsLit(index)) return Icons.check_circle;
    if (_timer.phase == Phase.work &&
        index == _timer.completedSessions % PomodoroTimer.sessionsPerLongBreak) {
      return Icons.radio_button_checked;
    }
    return Icons.radio_button_unchecked;
  }
}
