import 'package:teste_bus2/data/models/coordinates_model.dart';
import 'package:teste_bus2/data/models/dob_model.dart';
import 'package:teste_bus2/data/models/id_model.dart';
import 'package:teste_bus2/data/models/location_model.dart';
import 'package:teste_bus2/data/models/login_model.dart';
import 'package:teste_bus2/data/models/name_model.dart';
import 'package:teste_bus2/data/models/picture_model.dart';
import 'package:teste_bus2/data/models/registered_model.dart';
import 'package:teste_bus2/data/models/street_model.dart';
import 'package:teste_bus2/data/models/timezone_model.dart';
import 'package:teste_bus2/data/models/user_model.dart';
import 'package:teste_bus2/domain/models/coordinates_entity.dart';
import 'package:teste_bus2/domain/models/dob_entity.dart';
import 'package:teste_bus2/domain/models/id_entity.dart';
import 'package:teste_bus2/domain/models/location_entity.dart';
import 'package:teste_bus2/domain/models/login_entity.dart';
import 'package:teste_bus2/domain/models/name_entity.dart';
import 'package:teste_bus2/domain/models/picture_entity.dart';
import 'package:teste_bus2/domain/models/registered_entity.dart';
import 'package:teste_bus2/domain/models/street_entity.dart';
import 'package:teste_bus2/domain/models/timezone_entity.dart';
import 'package:teste_bus2/domain/models/user_entity.dart';

class UserFixture {
  static UserEntity createUser({String? email, String? firstName, String? lastName}) {
    return UserEntity(
      gender: 'female',
      name: NameEntity(title: 'Ms', first: firstName ?? 'Ana', last: lastName ?? 'Silva'),
      location: LocationEntity(
        street: StreetEntity(number: 123, name: 'Rua das Flores'),
        city: 'São Paulo',
        state: 'São Paulo',
        country: 'Brasil',
        postcode: '01234-567',
        coordinates: CoordinatesEntity(latitude: '-23.5505', longitude: '-46.6333'),
        timezone: TimezoneEntity(offset: '-03:00', description: 'Brasilia'),
      ),
      email: email ?? 'ana.silva@example.com',
      login: LoginEntity(
        uuid: 'abc123',
        username: 'ana.silva',
        password: 'password123',
        salt: 'salt',
        md5: 'md5hash',
        sha1: 'sha1hash',
        sha256: 'sha256hash',
      ),
      dob: DobEntity(date: '1995-01-15T00:00:00.000Z', age: 28),
      registered: RegisteredEntity(date: '2020-01-01T00:00:00.000Z', age: 4),
      phone: '(11) 1234-5678',
      cell: '(11) 98765-4321',
      id: IdEntity(name: 'CPF', value: '123.456.789-00'),
      picture: PictureEntity(
        large: 'https://randomuser.me/api/portraits/women/1.jpg',
        medium: 'https://randomuser.me/api/portraits/med/women/1.jpg',
        thumbnail: 'https://randomuser.me/api/portraits/thumb/women/1.jpg',
      ),
      nat: 'BR',
    );
  }

  static List<UserEntity> createUserList(int count) {
    return List.generate(
      count,
      (index) => createUser(email: 'user$index@example.com', firstName: 'User', lastName: 'Number$index'),
    );
  }

  static UserModel createUserModel({String? email, String? firstName, String? lastName}) {
    return UserModel(
      gender: 'female',
      name: NameModel(title: 'Ms', first: firstName ?? 'Ana', last: lastName ?? 'Silva'),
      location: LocationModel(
        street: StreetModel(number: 123, name: 'Rua das Flores'),
        city: 'São Paulo',
        state: 'São Paulo',
        country: 'Brasil',
        postcode: '01234-567',
        coordinates: CoordinatesModel(latitude: '-23.5505', longitude: '-46.6333'),
        timezone: TimezoneModel(offset: '-03:00', description: 'Brasilia'),
      ),
      email: email ?? 'ana.silva@example.com',
      login: LoginModel(
        uuid: 'abc123',
        username: 'ana.silva',
        password: 'password123',
        salt: 'salt',
        md5: 'md5hash',
        sha1: 'sha1hash',
        sha256: 'sha256hash',
      ),
      dob: DobModel(date: '1995-01-15T00:00:00.000Z', age: 28),
      registered: RegisteredModel(date: '2020-01-01T00:00:00.000Z', age: 4),
      phone: '(11) 1234-5678',
      cell: '(11) 98765-4321',
      id: IdModel(name: 'CPF', value: '123.456.789-00'),
      picture: PictureModel(
        large: 'https://randomuser.me/api/portraits/women/1.jpg',
        medium: 'https://randomuser.me/api/portraits/med/women/1.jpg',
        thumbnail: 'https://randomuser.me/api/portraits/thumb/women/1.jpg',
      ),
      nat: 'BR',
    );
  }

  static List<UserModel> createUserModelList(int count) {
    return List.generate(
      count,
      (index) => createUserModel(email: 'user$index@example.com', firstName: 'User', lastName: 'Number$index'),
    );
  }
}
