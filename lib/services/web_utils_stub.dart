import 'web_utils.dart';

WebUtils createWebUtils() => WebUtilsStub();

class WebUtilsStub implements WebUtils {
  @override
  Future<List<int>> getBlobAsBytes(dynamic blob) async => [];

  @override
  Future<String> createObjectUrl(dynamic blob) async => '';
}
