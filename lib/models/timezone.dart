class Timezone {
  final String offset;
  final String description;

  Timezone({required this.offset, required this.description});

  Timezone.fromMap(Map<String, dynamic> map) : offset = map['offset'] ?? '', description = map['description'] ?? '';

  Map<String, dynamic> toJson() {
    return {'offset': offset, 'description': description};
  }
}
