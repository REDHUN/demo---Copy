import 'dart:html' as html;
import 'dart:typed_data';

import 'web_utils.dart';

WebUtils createWebUtils() => WebUtilsWeb();

class WebUtilsWeb implements WebUtils {
  @override
  Future<List<int>> getBlobAsBytes(dynamic blob) async {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(blob as html.Blob);
    await reader.onLoad.first;
    return (reader.result as Uint8List).toList();
  }

  @override
  Future<String> createObjectUrl(dynamic blob) {
    return Future.value(html.Url.createObjectUrlFromBlob(blob as html.Blob));
  }
}
