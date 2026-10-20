import 'dart:typed_data';

import 'report_file_saver_stub.dart'
    if (dart.library.html) 'report_file_saver_web.dart'
    as saver;

Future<void> saveReportFile(
  Uint8List bytes, {
  required String fileName,
  required String mimeType,
}) {
  return saver.saveReportFile(bytes, fileName: fileName, mimeType: mimeType);
}
