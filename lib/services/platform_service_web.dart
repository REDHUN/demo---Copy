import 'dart:html' as html;

import 'platform_service.dart';

PlatformService createPlatformService() => WebPlatformService();

class WebPlatformService implements PlatformService, WebPlatformInterface {
  html.MediaStream? _mediaStream;
  html.MediaRecorder? _mediaRecorder;
  List<html.Blob> _chunks = [];
  String? _audioUrl;

  @override
  Future<bool> requestMicrophonePermission() async {
    try {
      _mediaStream = await html.window.navigator.mediaDevices
          ?.getUserMedia({'audio': true});
      return _mediaStream != null;
    } catch (e) {
      print('Error requesting web permission: $e');
      return false;
    }
  }

  @override
  Future<void> startMediaStream() async {
    await stopMediaStream();

    _chunks = [];
    _mediaStream =
        await html.window.navigator.mediaDevices?.getUserMedia({'audio': true});
    _mediaRecorder = html.MediaRecorder(_mediaStream!);

    _mediaRecorder!.addEventListener('dataavailable', (event) {
      final blob = (event as html.BlobEvent).data!;
      _chunks.add(blob);
    });

    _mediaRecorder!.start();
  }

  @override
  Future<void> stopMediaStream() async {
    _mediaRecorder?.stop();
    _mediaRecorder = null;

    _mediaStream?.getTracks().forEach((track) {
      track.stop();
      track.enabled = false;
    });
    _mediaStream = null;

    await Future.delayed(const Duration(milliseconds: 100));

    if (_chunks.isNotEmpty) {
      final blob = html.Blob(_chunks, 'audio/webm');
      _audioUrl = html.Url.createObjectUrlFromBlob(blob);
    }
  }

  @override
  String? get audioUrl => _audioUrl;

  html.Blob? get audioBlob =>
      _chunks.isNotEmpty ? html.Blob(_chunks, 'audio/webm') : null;
}
