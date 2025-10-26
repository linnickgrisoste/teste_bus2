class Coordinates {
  final String latitude;
  final String longitude;

  Coordinates({required this.latitude, required this.longitude});

  Coordinates.fromMap(Map<String, dynamic> map) : latitude = map['latitude'] ?? '', longitude = map['longitude'] ?? '';

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }
}
