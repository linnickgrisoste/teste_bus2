class Registered {
  final String date;
  final int age;

  Registered({required this.date, required this.age});

  Registered.fromMap(Map<String, dynamic> map) : date = map['date'] ?? '', age = map['age'] ?? 0;

  Map<String, dynamic> toJson() {
    return {'date': date, 'age': age};
  }
}
