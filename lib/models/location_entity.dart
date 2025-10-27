import 'coordinates_entity.dart';
import 'street_entity.dart';
import 'timezone_entity.dart';

class LocationEntity {
  final StreetEntity street;
  final String city;
  final String state;
  final String country;
  final String postcode;
  final CoordinatesEntity coordinates;
  final TimezoneEntity timezone;

  LocationEntity({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
    required this.coordinates,
    required this.timezone,
  });
}
