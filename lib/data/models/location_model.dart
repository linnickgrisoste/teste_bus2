import 'package:teste_bus2/data/models/coordinates_model.dart';
import 'package:teste_bus2/data/models/street_model.dart';
import 'package:teste_bus2/data/models/timezone_model.dart';
import 'package:teste_bus2/models/location_entity.dart';

class LocationModel extends LocationEntity {
  LocationModel({
    required super.street,
    required super.city,
    required super.state,
    required super.country,
    required super.postcode,
    required super.coordinates,
    required super.timezone,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      street: StreetModel.fromMap(map['street'] ?? {}),
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      country: map['country'] ?? '',
      postcode: map['postcode']?.toString() ?? '',
      coordinates: CoordinatesModel.fromMap(map['coordinates'] ?? {}),
      timezone: TimezoneModel.fromMap(map['timezone'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': (street as StreetModel).toJson(),
      'city': city,
      'state': state,
      'country': country,
      'postcode': postcode,
      'coordinates': (coordinates as CoordinatesModel).toJson(),
      'timezone': (timezone as TimezoneModel).toJson(),
    };
  }
}
