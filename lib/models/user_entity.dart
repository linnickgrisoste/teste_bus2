import 'dob_entity.dart';
import 'id_entity.dart';
import 'location_entity.dart';
import 'login_entity.dart';
import 'name_entity.dart';
import 'picture_entity.dart';
import 'registered_entity.dart';

class UserEntity {
  final IdEntity id;
  final String phone;
  final String email;
  final String gender;
  final NameEntity name;
  final LocationEntity location;
  final LoginEntity login;
  final DobEntity dob;
  final RegisteredEntity registered;
  final String cell;
  final PictureEntity picture;
  final String nat;

  UserEntity({
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
}
