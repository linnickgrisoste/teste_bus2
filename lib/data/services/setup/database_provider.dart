import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:teste_bus2/data/services/setup/table/coordinates_table.dart';
import 'package:teste_bus2/data/services/setup/table/dobs_table.dart';
import 'package:teste_bus2/data/services/setup/table/locations_table.dart';
import 'package:teste_bus2/data/services/setup/table/logins_table.dart';
import 'package:teste_bus2/data/services/setup/table/names_table.dart';
import 'package:teste_bus2/data/services/setup/table/pictures_table.dart';
import 'package:teste_bus2/data/services/setup/table/registered_table.dart';
import 'package:teste_bus2/data/services/setup/table/streets_table.dart';
import 'package:teste_bus2/data/services/setup/table/table.dart';
import 'package:teste_bus2/data/services/setup/table/timezones_table.dart';
import 'package:teste_bus2/data/services/setup/table/user_ids_table.dart';
import 'package:teste_bus2/data/services/setup/table/users_table.dart';

abstract class DatabaseProviderProtocol {
  Database get database;

  Future<void> initialize();
  Future<void> close();
}

class DatabaseProvider implements DatabaseProviderProtocol {
  DatabaseProvider._();

  static final DatabaseProvider instance = DatabaseProvider._();

  late Database _db;
  final currentVersion = 1;

  bool _isInitialized = false;

  List<Table> get tables => [
    NamesTable(),
    CoordinatesTable(),
    TimezonesTable(),
    StreetsTable(),
    LocationsTable(),
    LoginsTable(),
    DobsTable(),
    RegisteredTable(),
    PicturesTable(),
    UserIdsTable(),
    UsersTable(),
  ];

  @override
  Database get database {
    if (!_isInitialized) {
      throw Exception('Database not initialized');
    }

    return _db;
  }

  @override
  Future<void> initialize() async {
    final databasesPath = await getDatabasesPath();

    final path = join(databasesPath, 'bus_2.db');

    _db = await openDatabase(path, version: currentVersion, onCreate: _onCreate);

    _isInitialized = true;
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    for (final table in tables) {
      batch.execute(table.create);
    }
    await batch.commit();
  }

  @override
  Future<void> close() async {
    if (_isInitialized) {
      await _db.close();
      _isInitialized = false;
    }
  }
}
