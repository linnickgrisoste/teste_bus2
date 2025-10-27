import 'package:teste_bus2/models/street_entity.dart';

class StreetModel extends StreetEntity {
  StreetModel({required super.number, required super.name});

  factory StreetModel.fromMap(Map<String, dynamic> map) {
    return StreetModel(number: map['number'] ?? 0, name: map['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'number': number, 'name': name};
  }
}
