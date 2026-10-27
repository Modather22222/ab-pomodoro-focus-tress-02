# Pomodoro Focus

A minimal Material 3 pomodoro timer built with Flutter. It runs 25-minute focus
sessions with 5-minute short breaks, shows four cycle dots plus a running
session counter, and switches to a 20-minute long break after every 4th
completed cycle. State is in memory only (a `ChangeNotifier`), so the timer
restarts when the app is closed.

## Run

    flutter pub get
    flutter run

## Test

    flutter test
