class Id {
  final String name;
  final String value;

  Id({required this.name, required this.value});

  Id.fromMap(Map<String, dynamic> map) : name = map['name'] ?? '', value = map['value'] ?? '';

  Map<String, dynamic> toJson() {
    return {'name': name, 'value': value};
  }
}
