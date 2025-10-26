import 'coordinates.dart';
import 'street.dart';
import 'timezone.dart';

class Location {
  final Street street;
  final String city;
  final String state;
  final String country;
  final String postcode;
  final Coordinates coordinates;
  final Timezone timezone;

  Location({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
    required this.coordinates,
    required this.timezone,
  });

  Location.fromMap(Map<String, dynamic> map)
    : street = Street.fromMap(map['street'] ?? {}),
      city = map['city'] ?? '',
      state = map['state'] ?? '',
      country = map['country'] ?? '',
      postcode = map['postcode']?.toString() ?? '',
      coordinates = Coordinates.fromMap(map['coordinates'] ?? {}),
      timezone = Timezone.fromMap(map['timezone'] ?? {});

  Map<String, dynamic> toJson() {
    return {
      'street': street.toJson(),
      'city': city,
      'state': state,
      'country': country,
      'postcode': postcode,
      'coordinates': coordinates.toJson(),
      'timezone': timezone.toJson(),
    };
  }
}
