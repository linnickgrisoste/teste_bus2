import 'package:sqflite/sqflite.dart';
import 'package:teste_bus2/data/models/coordinates_model.dart';
import 'package:teste_bus2/data/models/dob_model.dart';
import 'package:teste_bus2/data/models/id_model.dart';
import 'package:teste_bus2/data/models/login_model.dart';
import 'package:teste_bus2/data/models/name_model.dart';
import 'package:teste_bus2/data/models/picture_model.dart';
import 'package:teste_bus2/data/models/registered_model.dart';
import 'package:teste_bus2/data/models/street_model.dart';
import 'package:teste_bus2/data/models/timezone_model.dart';
import 'package:teste_bus2/data/models/user_model.dart';
import 'package:teste_bus2/data/services/setup/database_provider.dart';

abstract class LocalUserServiceProtocol {
  Future<int> saveUser(UserModel user);
  Future<bool> isUserSaved(String email);
  Future<int> deleteUser(String email);
  Future<List<UserModel>> getAllSavedUsers();
}

class LocalUserService implements LocalUserServiceProtocol {
  final DatabaseProvider databaseProvider;

  LocalUserService({required this.databaseProvider});

  Database get _db => databaseProvider.database;

  @override
  Future<int> saveUser(UserModel user) async {
    return await _db.transaction((txn) async {
      // Inserir entidades relacionadas e capturar IDs
      final nameId = await txn.insert('names', (user.name as NameModel).toJson());
      final coordinatesId = await txn.insert('coordinates', (user.location.coordinates as CoordinatesModel).toJson());
      final timezoneId = await txn.insert('timezones', (user.location.timezone as TimezoneModel).toJson());
      final streetId = await txn.insert('streets', (user.location.street as StreetModel).toJson());
      final loginId = await txn.insert('logins', (user.login as LoginModel).toJson());
      final dobId = await txn.insert('dobs', (user.dob as DobModel).toJson());
      final registeredId = await txn.insert('registered', (user.registered as RegisteredModel).toJson());
      final pictureId = await txn.insert('pictures', (user.picture as PictureModel).toJson());
      final userIdRef = await txn.insert('user_ids', (user.id as IdModel).toJson());

      // Inserir location com as foreign keys
      final locationId = await txn.insert('locations', {
        'street_id': streetId,
        'city': user.location.city,
        'state': user.location.state,
        'country': user.location.country,
        'postcode': user.location.postcode,
        'coordinates_id': coordinatesId,
        'timezone_id': timezoneId,
      });

      // Inserir user com todas as foreign keys
      final userId = await txn.insert('users', {
        'user_id_ref': userIdRef,
        'gender': user.gender,
        'email': user.email,
        'phone': user.phone,
        'cell': user.cell,
        'nat': user.nat,
        'name_id': nameId,
        'location_id': locationId,
        'login_id': loginId,
        'dob_id': dobId,
        'registered_id': registeredId,
        'picture_id': pictureId,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      return userId;
    });
  }

  @override
  Future<List<UserModel>> getAllSavedUsers() async {
    final results = await _db.rawQuery('''
      SELECT 
        u.gender, u.email, u.phone, u.cell, u.nat,
        n.title as name_title, n.first as name_first, n.last as name_last,
        l.city as location_city, l.state as location_state, 
        l.country as location_country, l.postcode as location_postcode,
        s.number as street_number, s.name as street_name,
        c.latitude as coordinates_latitude, c.longitude as coordinates_longitude,
        t.offset as timezone_offset, t.description as timezone_description,
        lg.uuid as login_uuid, lg.username as login_username, 
        lg.password as login_password, lg.salt as login_salt, 
        lg.md5 as login_md5, lg.sha1 as login_sha1, lg.sha256 as login_sha256,
        d.date as dob_date, d.age as dob_age,
        r.date as registered_date, r.age as registered_age,
        ui.name as id_name, ui.value as id_value,
        p.large as picture_large, p.medium as picture_medium, p.thumbnail as picture_thumbnail
      FROM users u
      INNER JOIN names n ON u.name_id = n.id
      INNER JOIN locations l ON u.location_id = l.id
      INNER JOIN streets s ON l.street_id = s.id
      INNER JOIN coordinates c ON l.coordinates_id = c.id
      INNER JOIN timezones t ON l.timezone_id = t.id
      INNER JOIN logins lg ON u.login_id = lg.id
      INNER JOIN dobs d ON u.dob_id = d.id
      INNER JOIN registered r ON u.registered_id = r.id
      INNER JOIN user_ids ui ON u.user_id_ref = ui.id
      INNER JOIN pictures p ON u.picture_id = p.id
      ORDER BY u.created_at DESC
    ''');

    return results.map((row) => UserModel.fromMap(_buildUserMap(row))).toList();
  }

  Map<String, dynamic> _buildUserMap(Map<String, dynamic> row) {
    return {
      'gender': row['gender'],
      'email': row['email'],
      'phone': row['phone'],
      'cell': row['cell'],
      'nat': row['nat'],
      'name': {'title': row['name_title'], 'first': row['name_first'], 'last': row['name_last']},
      'location': {
        'city': row['location_city'],
        'state': row['location_state'],
        'country': row['location_country'],
        'postcode': row['location_postcode'],
        'street': {'number': row['street_number'], 'name': row['street_name']},
        'coordinates': {'latitude': row['coordinates_latitude'], 'longitude': row['coordinates_longitude']},
        'timezone': {'offset': row['timezone_offset'], 'description': row['timezone_description']},
      },
      'login': {
        'uuid': row['login_uuid'],
        'username': row['login_username'],
        'password': row['login_password'],
        'salt': row['login_salt'],
        'md5': row['login_md5'],
        'sha1': row['login_sha1'],
        'sha256': row['login_sha256'],
      },
      'dob': {'date': row['dob_date'], 'age': row['dob_age']},
      'registered': {'date': row['registered_date'], 'age': row['registered_age']},
      'id': {'name': row['id_name'], 'value': row['id_value']},
      'picture': {
        'large': row['picture_large'],
        'medium': row['picture_medium'],
        'thumbnail': row['picture_thumbnail'],
      },
    };
  }

  @override
  Future<bool> isUserSaved(String email) async {
    final result = await _db.query('users', where: 'email = ?', whereArgs: [email], limit: 1);

    return result.isNotEmpty;
  }

  @override
  Future<int> deleteUser(String email) async {
    return await _db.delete('users', where: 'email = ?', whereArgs: [email]);
  }
}
