import 'platform_service_web.dart'
    if (dart.library.io) 'platform_service_mobile.dart';

export 'web_platform_interface.dart';

abstract class PlatformService {
  static PlatformService instance = createPlatformService();

  Future<bool> requestMicrophonePermission();
  Future<void> stopMediaStream();
  Future<void> startMediaStream();
  String? get audioUrl;
}
