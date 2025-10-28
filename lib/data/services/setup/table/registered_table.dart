import '../enum/database_types_enum.dart';
import 'table.dart';

class RegisteredTable extends Table {
  @override
  String get create =>
      'CREATE TABLE $tableName '
      '($idColumn ${DBType.integer} NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '$dateColumn ${DBType.text} NOT NULL, '
      '$ageColumn ${DBType.integer} NOT NULL);';

  static const String tableName = 'registered';

  static const String idColumn = 'id';
  static const String dateColumn = 'date';
  static const String ageColumn = 'age';
}
