import '../enum/database_types_enum.dart';
import 'table.dart';

class PicturesTable extends Table {
  @override
  String get create =>
      'CREATE TABLE $tableName '
      '($idColumn ${DBType.integer} NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '$largeColumn ${DBType.text} NOT NULL, '
      '$mediumColumn ${DBType.text} NOT NULL, '
      '$thumbnailColumn ${DBType.text} NOT NULL);';

  static const String tableName = 'pictures';

  static const String idColumn = 'id';
  static const String largeColumn = 'large';
  static const String mediumColumn = 'medium';
  static const String thumbnailColumn = 'thumbnail';
}
