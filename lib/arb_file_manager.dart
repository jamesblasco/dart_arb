import 'dart:io';

import 'models/arb_document.dart';
import 'models/arb_project.dart';

class ArbFileManager {
  void saveArbProject(ArbProject project, {String directory = "."}) {
    var targetDir = Directory(directory);
    targetDir.createSync(recursive: true);
    project.documents.forEach(
        (document) => _saveArbDocument(project.fileName, document, targetDir));
  }

  ArbDocument loadArbDocument(String filePath) {
    final file = File(filePath);
    final content = file.readAsStringSync();
    return ArbDocument.decode(content);
  }

  void _saveArbDocument(
      String fileName, ArbDocument document, Directory directory) {
    final filePath =
        "${directory.path}/${fileName}_${document.locale}.arb";

    final file = File(filePath);
    file.createSync();
    file.writeAsString(document.encode());
  }
}
