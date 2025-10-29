import 'package:teste_bus2/domain/models/coordinates_entity.dart';

class CoordinatesModel extends CoordinatesEntity {
  CoordinatesModel({required super.latitude, required super.longitude});

  factory CoordinatesModel.fromMap(Map<String, dynamic> map) {
    return CoordinatesModel(latitude: map['latitude'] ?? '', longitude: map['longitude'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }
}
