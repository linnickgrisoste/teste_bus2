import 'package:teste_bus2/models/dob_entity.dart';

class DobModel extends DobEntity {
  DobModel({required super.date, required super.age});

  factory DobModel.fromMap(Map<String, dynamic> map) {
    return DobModel(date: map['date'] ?? '', age: map['age'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'age': age};
  }
}
