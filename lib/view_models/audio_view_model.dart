import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../models/audio_model.dart';
import '../services/platform_service.dart';
import '../services/web_utils.dart';

class AudioViewModel extends ChangeNotifier {
  final _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final PlatformService _platformService = PlatformService.instance;
  AudioModel _audioModel = AudioModel();
  Timer? _recordingTimer;

  AudioModel get audioModel => _audioModel;

  AudioViewModel() {
    _init();
  }

  void _init() {
    _audioPlayer.onDurationChanged.listen((Duration d) {
      _audioModel = _audioModel.copyWith(duration: d);
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      _audioModel = _audioModel.copyWith(position: p);
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _audioModel = _audioModel.copyWith(isPlaying: false);
      notifyListeners();
    });

    requestPermissions();
  }

  Future<void> requestPermissions() async {
    try {
      final hasPermission =
          await _platformService.requestMicrophonePermission();
      _audioModel = _audioModel.copyWith(hasPermission: hasPermission);
      notifyListeners();
    } catch (e) {
      print('Error requesting permissions: $e');
      _audioModel = _audioModel.copyWith(hasPermission: false);
      notifyListeners();
    }
  }

  Future<void> startRecording() async {
    try {
      if (!_audioModel.hasPermission) {
        await requestPermissions();
        if (!_audioModel.hasPermission) return;
      }

      if (kIsWeb) {
        await _platformService.startMediaStream();
      }

      String path;
      if (kIsWeb) {
        path = 'recording.pcm';
      } else {
        final dir = await getTemporaryDirectory();
        path = '${dir.path}/recording.m4a';
      }

      await _audioRecorder.start(
        RecordConfig(
          encoder: kIsWeb ? AudioEncoder.pcm16bits : AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );

      _audioModel = _audioModel.copyWith(
        isRecording: true,
        recordDuration: Duration.zero,
      );

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _audioModel = _audioModel.copyWith(
          recordDuration: Duration(seconds: timer.tick),
        );
        notifyListeners();
      });

      notifyListeners();
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      _recordingTimer?.cancel();
      _recordingTimer = null;

      await _audioRecorder.stop();

      if (kIsWeb) {
        await _platformService.stopMediaStream();
      }

      String path;
      if (kIsWeb) {
        path = 'recording.pcm';
      } else {
        final dir = await getTemporaryDirectory();
        path = '${dir.path}/recording.m4a';
      }

      _audioModel = _audioModel.copyWith(
        isRecording: false,
        path: path,
        recordDuration: Duration.zero,
      );
      notifyListeners();
    } catch (e) {
      _audioModel = _audioModel.copyWith(
        isRecording: false,
        recordDuration: Duration.zero,
      );
      notifyListeners();
      print('Error stopping recording: $e');
    }
  }

  Future<void> playRecording() async {
    try {
      if (_audioModel.isPlaying) {
        await _audioPlayer.stop();
        _audioModel = _audioModel.copyWith(isPlaying: false);
      } else {
        if (kIsWeb) {
          final url = _platformService.audioUrl;
          if (url != null) {
            await _audioPlayer.play(UrlSource(url),
                mode: PlayerMode.mediaPlayer);
            _audioModel = _audioModel.copyWith(isPlaying: true);
          }
        } else {
          await _audioPlayer.play(DeviceFileSource(_audioModel.path!));
          _audioModel = _audioModel.copyWith(isPlaying: true);
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error playing recording: $e');
    }
  }

  Future<void> seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<String?> getBase64Audio() async {
    try {
      if (kIsWeb) {
        if (_platformService is WebPlatformInterface) {
          final webService = _platformService as WebPlatformInterface;
          final blob = webService.audioBlob;
          if (blob != null) {
            final bytes = await WebUtils.instance.getBlobAsBytes(blob);
            return base64Encode(bytes);
          }
        }
      } else {
        if (_audioModel.path != null) {
          final bytes = await io.File(_audioModel.path!).readAsBytes();
          return base64Encode(bytes);
        }
      }
    } catch (e) {
      print('Error converting to base64: $e');
    }
    return null;
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
