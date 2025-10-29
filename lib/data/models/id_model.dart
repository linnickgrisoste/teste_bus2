import 'package:teste_bus2/domain/models/id_entity.dart';

class IdModel extends IdEntity {
  IdModel({required super.name, required super.value});

  factory IdModel.fromMap(Map<String, dynamic> map) {
    return IdModel(name: map['name'] ?? '', value: map['value'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'value': value};
  }
}
