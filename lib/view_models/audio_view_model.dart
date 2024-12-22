import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../services/platform_service.dart';
import '../services/platform_service_web.dart'
    if (dart.library.io) '../services/platform_service_mobile.dart';

class AudioViewModel extends ChangeNotifier {
  final PlatformService _platformService;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _recordDuration = Duration.zero;
  Timer? _recordingTimer;
  String? _path;
  Duration _position = Duration.zero;

  AudioViewModel({PlatformService? platformService})
      : _platformService = platformService ?? createPlatformService() {
    _initAudioPlayer();
  }

  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get recordDuration => _recordDuration;
  String? get path => _path;
  Duration get position => _position;

  void _initAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((d) {
      _duration = d;
      notifyListeners();
    });
    _audioPlayer.onPositionChanged.listen((p) {
      _position = p;
      notifyListeners();
    });
  }

  Future<void> startRecording() async {
    final hasPermission = await _platformService.requestMicrophonePermission();
    if (!hasPermission) return;

    await _platformService.startMediaStream();
    _isRecording = true;
    _recordDuration = Duration.zero;

    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _recordDuration = Duration(seconds: timer.tick);
      notifyListeners();
    });

    notifyListeners();
  }

  Future<void> stopRecording() async {
    _recordingTimer?.cancel();
    await _platformService.stopMediaStream();
    _isRecording = false;
    _path = _platformService.audioUrl;
    notifyListeners();
  }

  Future<void> playRecording() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      _isPlaying = false;
    } else if (_path != null) {
      await _audioPlayer.play(UrlSource(_path!));
      _isPlaying = true;
    }
    notifyListeners();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
