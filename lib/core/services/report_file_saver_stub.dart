import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:share_plus/share_plus.dart';

Future<void> saveReportFile(
  Uint8List bytes, {
  required String fileName,
  required String mimeType,
}) async {
  await Share.shareXFiles([
    XFile.fromData(bytes, name: fileName, mimeType: mimeType),
  ], subject: 'Laporan Keuangan AturDompet');
}
