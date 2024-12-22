import 'package:permission_handler/permission_handler.dart';

import 'platform_service.dart';

PlatformService createPlatformService() => MobilePlatformService();

class MobilePlatformService implements PlatformService {
  @override
  String? get audioUrl => null;

  @override
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.status;
    if (status.isDenied) {
      final result = await Permission.microphone.request();
      return result.isGranted;
    }
    return true;
  }

  @override
  Future<void> stopMediaStream() async {
    // Not needed for mobile
  }

  @override
  Future<void> startMediaStream() async {
    // Not needed for mobile
  }
}
