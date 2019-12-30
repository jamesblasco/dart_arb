import 'dart:async';
import 'dart:io';

import 'package:args/args.dart' as args;
import 'package:path/path.dart' as path;

import 'arb_file_manager.dart';
import 'models/arb_document.dart';
import 'models/arb_project.dart';
import 'models/arb_resource.dart';

Future<void> main(List<String> arguments) async {
  final args.ArgParser parser = args.ArgParser();
  parser.addFlag(
    'help',
    defaultsTo: false,
    negatable: false,
    help: 'Print this help message.',
  );
  parser.addOption(
    'arb-dir',
    defaultsTo: path.join('lib', 'l10n'),
    help: 'The directory where all localization files should reside. For '
        'example, the template and translated arb files should be located here. '
        'Also, the generated output messages Dart files for each locale and the '
        'generated localizations classes will be created here.',
  );
  parser.addOption(
    'output-localization-file',
    defaultsTo: 'app',
    help: 'The filename for the output localization and localizations '
        'delegate classes.',
  );

  final args.ArgResults results = parser.parse(arguments);
  if (results['help'] == true) {
    print(parser.usage);
    exit(0);
  }

  final String arbPathString = results['arb-dir'] as String;
  final String outputFileString = results['output-localization-file'] as String;
  ArbFileManager().saveArbProject(
      ArbProject(outputFileString, documents: [
        ArbDocument('en', resources: {
          'ID': ArbResource('ID', 'value'),
        }),
        ArbDocument('es', resources: {
          'ID': ArbResource('ID', 'value'),
        })
      ]),
      directory: arbPathString);
}
