import 'dob.dart';
import 'id.dart';
import 'location.dart';
import 'login.dart';
import 'name.dart';
import 'picture.dart';
import 'registered.dart';

class User {
  final Id id;
  final String phone;
  final String email;
  final String gender;
  final Name name;
  final Location location;
  final Login login;
  final Dob dob;
  final Registered registered;
  final String cell;
  final Picture picture;
  final String nat;

  User({
    required this.gender,
    required this.name,
    required this.location,
    required this.email,
    required this.login,
    required this.dob,
    required this.registered,
    required this.phone,
    required this.cell,
    required this.id,
    required this.picture,
    required this.nat,
  });

  User.fromMap(Map<String, dynamic> map)
    : gender = map['gender'] ?? '',
      name = Name.fromMap(map['name'] ?? {}),
      location = Location.fromMap(map['location'] ?? {}),
      email = map['email'] ?? '',
      login = Login.fromMap(map['login'] ?? {}),
      dob = Dob.fromMap(map['dob'] ?? {}),
      registered = Registered.fromMap(map['registered'] ?? {}),
      phone = map['phone'] ?? '',
      cell = map['cell'] ?? '',
      id = Id.fromMap(map['id'] ?? {}),
      picture = Picture.fromMap(map['picture'] ?? {}),
      nat = map['nat'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'name': name.toJson(),
      'location': location.toJson(),
      'email': email,
      'login': login.toJson(),
      'dob': dob.toJson(),
      'registered': registered.toJson(),
      'phone': phone,
      'cell': cell,
      'id': id.toJson(),
      'picture': picture.toJson(),
      'nat': nat,
    };
  }
}
