class Street {
  final int number;
  final String name;

  Street({required this.number, required this.name});

  Street.fromMap(Map<String, dynamic> map) : number = map['number'] ?? 0, name = map['name'] ?? '';

  Map<String, dynamic> toJson() {
    return {'number': number, 'name': name};
  }
}
