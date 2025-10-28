import '../enum/database_types_enum.dart';
import 'coordinates_table.dart';
import 'streets_table.dart';
import 'table.dart';
import 'timezones_table.dart';

class LocationsTable extends Table {
  @override
  String get create =>
      'CREATE TABLE $tableName '
      '($idColumn ${DBType.integer} NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '$streetIdColumn ${DBType.integer} NOT NULL, '
      '$cityColumn ${DBType.text} NOT NULL, '
      '$stateColumn ${DBType.text} NOT NULL, '
      '$countryColumn ${DBType.text} NOT NULL, '
      '$postcodeColumn ${DBType.text} NOT NULL, '
      '$coordinatesIdColumn ${DBType.integer} NOT NULL, '
      '$timezoneIdColumn ${DBType.integer} NOT NULL, '
      'FOREIGN KEY($streetIdColumn) REFERENCES ${StreetsTable.tableName}(${StreetsTable.idColumn}) ON DELETE CASCADE, '
      'FOREIGN KEY($coordinatesIdColumn) REFERENCES ${CoordinatesTable.tableName}(${CoordinatesTable.idColumn}) ON DELETE CASCADE, '
      'FOREIGN KEY($timezoneIdColumn) REFERENCES ${TimezonesTable.tableName}(${TimezonesTable.idColumn}) ON DELETE CASCADE);';

  static const String tableName = 'locations';

  static const String idColumn = 'id';
  static const String streetIdColumn = 'street_id';
  static const String cityColumn = 'city';
  static const String stateColumn = 'state';
  static const String countryColumn = 'country';
  static const String postcodeColumn = 'postcode';
  static const String coordinatesIdColumn = 'coordinates_id';
  static const String timezoneIdColumn = 'timezone_id';
}
