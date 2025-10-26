class Picture {
  final String large;
  final String medium;
  final String thumbnail;

  Picture({required this.large, required this.medium, required this.thumbnail});

  Picture.fromMap(Map<String, dynamic> map)
    : large = map['large'] ?? '',
      medium = map['medium'] ?? '',
      thumbnail = map['thumbnail'] ?? '';

  Map<String, dynamic> toJson() {
    return {'large': large, 'medium': medium, 'thumbnail': thumbnail};
  }
}
