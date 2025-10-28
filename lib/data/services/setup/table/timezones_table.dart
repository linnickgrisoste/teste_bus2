import '../enum/database_types_enum.dart';
import 'table.dart';

class TimezonesTable extends Table {
  @override
  String get create =>
      'CREATE TABLE $tableName '
      '($idColumn ${DBType.integer} NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '$offsetColumn ${DBType.text} NOT NULL, '
      '$descriptionColumn ${DBType.text} NOT NULL);';

  static const String tableName = 'timezones';

  static const String idColumn = 'id';
  static const String offsetColumn = 'offset';
  static const String descriptionColumn = 'description';
}
