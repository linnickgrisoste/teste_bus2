import '../enum/database_types_enum.dart';
import 'table.dart';

class StreetsTable extends Table {
  @override
  String get create =>
      'CREATE TABLE $tableName '
      '($idColumn ${DBType.integer} NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '$numberColumn ${DBType.integer} NOT NULL, '
      '$nameColumn ${DBType.text} NOT NULL);';

  static const String tableName = 'streets';

  static const String idColumn = 'id';
  static const String numberColumn = 'number';
  static const String nameColumn = 'name';
}
