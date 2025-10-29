import 'package:teste_bus2/data/models/dob_model.dart';
import 'package:teste_bus2/data/models/id_model.dart';
import 'package:teste_bus2/data/models/location_model.dart';
import 'package:teste_bus2/data/models/login_model.dart';
import 'package:teste_bus2/data/models/name_model.dart';
import 'package:teste_bus2/data/models/picture_model.dart';
import 'package:teste_bus2/data/models/registered_model.dart';
import 'package:teste_bus2/models/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.phone,
    required super.email,
    required super.gender,
    required super.name,
    required super.location,
    required super.login,
    required super.dob,
    required super.registered,
    required super.cell,
    required super.picture,
    required super.nat,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      gender: map['gender'] ?? '',
      name: NameModel.fromMap(map['name'] ?? {}),
      location: LocationModel.fromMap(map['location'] ?? {}),
      email: map['email'] ?? '',
      login: LoginModel.fromMap(map['login'] ?? {}),
      dob: DobModel.fromMap(map['dob'] ?? {}),
      registered: RegisteredModel.fromMap(map['registered'] ?? {}),
      phone: map['phone'] ?? '',
      cell: map['cell'] ?? '',
      id: IdModel.fromMap(map['id'] ?? {}),
      picture: PictureModel.fromMap(map['picture'] ?? {}),
      nat: map['nat'] ?? '',
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      gender: entity.gender,
      name: entity.name,
      location: entity.location,
      email: entity.email,
      login: entity.login,
      dob: entity.dob,
      registered: entity.registered,
      phone: entity.phone,
      cell: entity.cell,
      id: entity.id,
      picture: entity.picture,
      nat: entity.nat,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'name': (name as NameModel).toJson(),
      'location': (location as LocationModel).toJson(),
      'email': email,
      'login': (login as LoginModel).toJson(),
      'dob': (dob as DobModel).toJson(),
      'registered': (registered as RegisteredModel).toJson(),
      'phone': phone,
      'cell': cell,
      'id': (id as IdModel).toJson(),
      'picture': (picture as PictureModel).toJson(),
      'nat': nat,
    };
  }
}
