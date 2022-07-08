import 'package:flutter/material.dart';

class AudioPlayer with ChangeNotifier {
  bool _playing = false;
  late AnimationController _controller;

  Duration _songDuration = const Duration(milliseconds: 0);
  Duration _current = const Duration(milliseconds: 0);

  String get totalDuration => printDuration(_songDuration);
  String get currentDuration => printDuration(_current);

  AnimationController get controller => _controller;
  bool get playing => _playing;
  Duration get songDuration => _songDuration;
  Duration get current => _current;
  double get porcentaje => (_songDuration.inSeconds > 0)
      ? _current.inSeconds / _songDuration.inSeconds
      : 0;

  set controller(AnimationController value) {
    _controller = value;
  }

  set playing(bool value) {
    _playing = value;
    notifyListeners();
  }

  set songDuration(Duration value) {
    _songDuration = value;
    notifyListeners();
  }

  set current(Duration value) {
    _current = value;
    notifyListeners();
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) => (n >= 10) ? '$n' : '0$n';

    String twoDigitsMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitsSeconds = twoDigits(duration.inSeconds.remainder(60));

    return '$twoDigitsMinutes:$twoDigitsSeconds';
  }
}
