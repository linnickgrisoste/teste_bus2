import 'package:teste_bus2/models/timezone_entity.dart';

class TimezoneModel extends TimezoneEntity {
  TimezoneModel({required super.offset, required super.description});

  factory TimezoneModel.fromMap(Map<String, dynamic> map) {
    return TimezoneModel(offset: map['offset'] ?? '', description: map['description'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'offset': offset, 'description': description};
  }
}
