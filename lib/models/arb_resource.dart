enum ArbResourceType { text }

class ArbResource {
  String id;
  String description;
  String type;
  ArbResourceValue value;

  final Map<String, Object> attributes = Map();

  ArbResource(String id, String value,
      {this.description = '', this.type = 'text'})
      : this.id = id,
        this.value = ArbResourceValue(value) {
    attributes['placeholders'] = Map<String, Object>();
  }

  ArbResource copyWith(
          {String id, String value, String description, String type}) =>
      ArbResource(id ?? this.id, value ?? this.value,
          description: description ?? this.description,
          type: type ?? this.type);
}

class ArbResourceValue {
  String text;
  final placeholders = List<ArbResourcePlaceholder>();

  bool get hasPlaceholders => placeholders.isNotEmpty;

  ArbResourceValue(this.text) {
    var placeholders = findPlaceholders(text);
    if (placeholders.isNotEmpty) {
      this.placeholders.addAll(placeholders);
    }
  }
}

class ArbResourcePlaceholder {
  final String name;

  ArbResourcePlaceholder(this.name);
}

var _regex = RegExp("\\{(.+?)\\}");

List<ArbResourcePlaceholder> findPlaceholders(String text) {
  if (text == null || text.isEmpty) {
    return List<ArbResourcePlaceholder>();
  }

  var matches = _regex.allMatches(text);
  var placeholders = Map<String, ArbResourcePlaceholder>();
  matches.forEach((Match match) {
    var group = match.group(0);
    var placeholder = group.substring(1, group.length - 1);

    if (placeholders.containsKey(placeholder)) {
      throw Exception("Placeholder $placeholder already declared");
    }
    placeholders[placeholder] = (ArbResourcePlaceholder(placeholder));
  });
  return placeholders.values.toList();
}
