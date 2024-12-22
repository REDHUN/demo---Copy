import 'web_utils_web.dart' if (dart.library.io) 'web_utils_stub.dart';

abstract class WebUtils {
  static WebUtils instance = createWebUtils();

  Future<List<int>> getBlobAsBytes(dynamic blob);
  Future<String> createObjectUrl(dynamic blob);
}
