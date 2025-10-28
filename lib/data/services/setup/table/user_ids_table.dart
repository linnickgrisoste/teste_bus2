import '../enum/database_types_enum.dart';
import 'table.dart';

class UserIdsTable extends Table {
  @override
  String get create =>
      'CREATE TABLE $tableName '
      '($idColumn ${DBType.integer} NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '$nameColumn ${DBType.text} NOT NULL, '
      '$valueColumn ${DBType.text} NOT NULL);';

  static const String tableName = 'user_ids';

  static const String idColumn = 'id';
  static const String nameColumn = 'name';
  static const String valueColumn = 'value';
}
