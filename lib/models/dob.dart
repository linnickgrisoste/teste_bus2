class Dob {
  final String date;
  final int age;

  Dob({required this.date, required this.age});

  Dob.fromMap(Map<String, dynamic> map) : date = map['date'] ?? '', age = map['age'] ?? 0;

  Map<String, dynamic> toJson() {
    return {'date': date, 'age': age};
  }
}
