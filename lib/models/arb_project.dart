import 'dart:convert';

import 'package:arb/dart_arb.dart';

import 'arb_document.dart';

class ArbProject {
  final String fileName;

  List<ArbDocument> documents;
  Map<String, ArbResource> resources;
  String defaultTemplate = 'en_US';

  DateTime get lastModified => documents
      .reduce((doc1, doc2) =>
          doc1.lastModified.isAfter(doc2.lastModified) ? doc1 : doc2)
      .lastModified;

  List<String> get locales => documents.map((doc) => doc.locale).toList();

  Map<String, ArbDocument> get mapDocuments =>
      documents.asMap().map((_, doc) => MapEntry(doc.locale, doc));

  ArbProject(this.fileName, {this.documents = const []}) {
    generateResourcesFromDocs();
  }

  generateResourcesFromDocs() {
    this.resources = {};
    for (final doc in documents) {
      doc.resources.forEach((id, resource) => resources[id] = resource);
    }
    if (!locales.contains(defaultTemplate)) {
      defaultTemplate = locales.first;
    }
  }

  Map<String, Object> toJson() => {
        'fileName': fileName,
        'documents': documents.map((doc) => doc.toJson()).toList(),
        'defaultTemplate': defaultTemplate,
      };

  ArbProject.fromJson(Map<String, dynamic> json)
      : fileName = json['fileName'],
        defaultTemplate = json['defaultTemplate'],
        documents = List<dynamic>.from(json['documents'])
            .map((doc) => ArbDocument.fromJson(doc))
            .toList() {
    generateResourcesFromDocs();
  }

  String encode() {
    var encoder = new JsonEncoder.withIndent('  ');
    var arbContent = encoder.convert(this.toJson());
    return arbContent;
  }

  factory ArbProject.decode(String json) {
    var decoder = new JsonDecoder();
    ArbProject project = ArbProject.fromJson(decoder.convert(json));
    return project;
  }
}
