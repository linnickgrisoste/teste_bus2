import '../enum/database_types_enum.dart';
import 'table.dart';

class CoordinatesTable extends Table {
  @override
  String get create =>
      'CREATE TABLE $tableName '
      '($idColumn ${DBType.integer} NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '$latitudeColumn ${DBType.text} NOT NULL, '
      '$longitudeColumn ${DBType.text} NOT NULL);';

  static const String tableName = 'coordinates';

  static const String idColumn = 'id';
  static const String latitudeColumn = 'latitude';
  static const String longitudeColumn = 'longitude';
}
