import 'dart:convert';

import 'arb_resource.dart';

class ArbDocument {
  String locale;

  DateTime lastModified;

  Map<String, ArbResource> resources;

  ArbDocument(this.locale,
      {DateTime lastModified, Map<String, ArbResource> resources})
      : this.lastModified = lastModified ?? DateTime.now(),
        this.resources = resources ?? {};

  Map<String, Object> toJson() => {
        '@@locale': locale,
        '@@last_modified': (lastModified ?? DateTime.now()).toIso8601String(),
        ...resources.map((id, ArbResource resource) =>
            MapEntry(resource.id, resource.value.text)),
        ...resources.map((id, ArbResource resource) => MapEntry(
            "@${resource.id}",
            resource.attributes
              ..addEntries([
                MapEntry('description', resource.description),
                MapEntry('type', resource.type),
              ])))
      };

  ArbDocument.fromJson(Map<String, dynamic> _json, {String locale}) {
    resources = Map<String, ArbResource>();

    this.locale = locale;

    _json.forEach((key, value) {
      if ("@@locale" == key) {
        this.locale ??= value;
      } else if ("@@last_modified" == key) {
        lastModified = DateTime.parse(value);
      } else if (key.startsWith("@")) {
        final entry = resources[key.substring(1)];
        Map<String, Object> attributes = value;
        attributes.forEach((key, value) => {
              if (key == 'type')
                entry.type = value
              else if (key == 'description')
                entry.description = value
              else
                entry.attributes[key] = value
            });
      } else {
        var entry = ArbResource(key, value);
        resources[key] = entry;
      }
    });
  }

  String encode() {
    var encoder = new JsonEncoder.withIndent('  ');
    var arbContent = encoder.convert(this.toJson());
    return arbContent;
  }

  factory ArbDocument.decode(String json, {String locale}) {
    var decoder = new JsonDecoder();
    ArbDocument arbContent =
        ArbDocument.fromJson(decoder.convert(json), locale: locale);
    return arbContent;
  }
}
