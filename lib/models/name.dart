class Name {
  final String title;
  final String first;
  final String last;

  Name({required this.title, required this.first, required this.last});

  Name.fromMap(Map<String, dynamic> map)
    : title = map['title'] ?? '',
      first = map['first'] ?? '',
      last = map['last'] ?? '';

  Map<String, dynamic> toJson() {
    return {'title': title, 'first': first, 'last': last};
  }
}
