import '../enum/database_types_enum.dart';
import 'table.dart';

class NamesTable extends Table {
  @override
  String get create =>
      'CREATE TABLE $tableName '
      '($idColumn ${DBType.integer} NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '$titleColumn ${DBType.text} NOT NULL, '
      '$firstColumn ${DBType.text} NOT NULL, '
      '$lastColumn ${DBType.text} NOT NULL);';

  static const String tableName = 'names';

  static const String idColumn = 'id';
  static const String titleColumn = 'title';
  static const String firstColumn = 'first';
  static const String lastColumn = 'last';
}
