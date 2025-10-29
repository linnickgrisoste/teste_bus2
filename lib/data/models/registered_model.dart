import 'package:teste_bus2/domain/models/registered_entity.dart';

class RegisteredModel extends RegisteredEntity {
  RegisteredModel({required super.date, required super.age});

  factory RegisteredModel.fromMap(Map<String, dynamic> map) {
    return RegisteredModel(date: map['date'] ?? '', age: map['age'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'age': age};
  }
}
