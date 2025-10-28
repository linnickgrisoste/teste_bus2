import 'package:sqflite/sqflite.dart';
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
import 'package:teste_bus2/data/services/setup/database_provider.dart';

class LocalUserService {
  final DatabaseProvider databaseProvider;

  LocalUserService({required this.databaseProvider});

  Database get _db => databaseProvider.database;

  Future<int> saveUser(UserModel user) async {
    return await _db.transaction((txn) async {
      await txn.insert('names', (user.name as NameModel).toJson());
      await txn.insert('coordinates', (user.location.coordinates as CoordinatesModel).toJson());
      await txn.insert('timezones', (user.location.timezone as TimezoneModel).toJson());
      await txn.insert('streets', (user.location.street as StreetModel).toJson());
      await txn.insert('locations', (user.location as LocationModel).toJson());
      await txn.insert('logins', (user.login as LoginModel).toJson());
      await txn.insert('dobs', (user.dob as DobModel).toJson());
      await txn.insert('registered', (user.registered as RegisteredModel).toJson());
      await txn.insert('pictures', (user.picture as PictureModel).toJson());
      await txn.insert('user_ids', (user.id as IdModel).toJson());
      final userId = await txn.insert('users', user.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);

      return userId;
    });
  }
}
