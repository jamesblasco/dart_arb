import 'models/arb_document.dart';
import 'models/arb_project.dart';

class ArbFileManager {
  void saveArbProject(ArbProject project, {String directory = "."}) {
    throw UnimplementedError('Not implemented for Web');
  }

  ArbDocument loadArbDocument(String filePath) {
    throw UnimplementedError('Not implemented for Web');
  }
}

class L10nException implements Exception {
  L10nException(this.message);

  final String message;
}
