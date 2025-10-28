import '../enum/database_types_enum.dart';
import 'dobs_table.dart';
import 'locations_table.dart';
import 'logins_table.dart';
import 'names_table.dart';
import 'pictures_table.dart';
import 'registered_table.dart';
import 'table.dart';
import 'user_ids_table.dart';

class UsersTable extends Table {
  @override
  String get create =>
      'CREATE TABLE $tableName '
      '($idColumn ${DBType.integer} NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '$userIdRefColumn ${DBType.integer} NOT NULL, '
      '$genderColumn ${DBType.text} NOT NULL, '
      '$emailColumn ${DBType.text} NOT NULL UNIQUE, '
      '$phoneColumn ${DBType.text} NOT NULL, '
      '$cellColumn ${DBType.text} NOT NULL, '
      '$natColumn ${DBType.text} NOT NULL, '
      '$nameIdColumn ${DBType.integer} NOT NULL, '
      '$locationIdColumn ${DBType.integer} NOT NULL, '
      '$loginIdColumn ${DBType.integer} NOT NULL, '
      '$dobIdColumn ${DBType.integer} NOT NULL, '
      '$registeredIdColumn ${DBType.integer} NOT NULL, '
      '$pictureIdColumn ${DBType.integer} NOT NULL, '
      '$createdAtColumn ${DBType.integer} NOT NULL, '
      'FOREIGN KEY($userIdRefColumn) REFERENCES ${UserIdsTable.tableName}(${UserIdsTable.idColumn}) ON DELETE CASCADE, '
      'FOREIGN KEY($nameIdColumn) REFERENCES ${NamesTable.tableName}(${NamesTable.idColumn}) ON DELETE CASCADE, '
      'FOREIGN KEY($locationIdColumn) REFERENCES ${LocationsTable.tableName}(${LocationsTable.idColumn}) ON DELETE CASCADE, '
      'FOREIGN KEY($loginIdColumn) REFERENCES ${LoginsTable.tableName}(${LoginsTable.idColumn}) ON DELETE CASCADE, '
      'FOREIGN KEY($dobIdColumn) REFERENCES ${DobsTable.tableName}(${DobsTable.idColumn}) ON DELETE CASCADE, '
      'FOREIGN KEY($registeredIdColumn) REFERENCES ${RegisteredTable.tableName}(${RegisteredTable.idColumn}) ON DELETE CASCADE, '
      'FOREIGN KEY($pictureIdColumn) REFERENCES ${PicturesTable.tableName}(${PicturesTable.idColumn}) ON DELETE CASCADE);';

  static const String tableName = 'users';

  static const String idColumn = 'id';
  static const String userIdRefColumn = 'user_id_ref';
  static const String genderColumn = 'gender';
  static const String emailColumn = 'email';
  static const String phoneColumn = 'phone';
  static const String cellColumn = 'cell';
  static const String natColumn = 'nat';
  static const String nameIdColumn = 'name_id';
  static const String locationIdColumn = 'location_id';
  static const String loginIdColumn = 'login_id';
  static const String dobIdColumn = 'dob_id';
  static const String registeredIdColumn = 'registered_id';
  static const String pictureIdColumn = 'picture_id';
  static const String createdAtColumn = 'created_at';
}
