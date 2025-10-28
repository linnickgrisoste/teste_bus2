import '../enum/database_types_enum.dart';
import 'table.dart';

class LoginsTable extends Table {
  @override
  String get create =>
      'CREATE TABLE $tableName '
      '($idColumn ${DBType.integer} NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '$uuidColumn ${DBType.text} NOT NULL, '
      '$usernameColumn ${DBType.text} NOT NULL, '
      '$passwordColumn ${DBType.text} NOT NULL, '
      '$saltColumn ${DBType.text} NOT NULL, '
      '$md5Column ${DBType.text} NOT NULL, '
      '$sha1Column ${DBType.text} NOT NULL, '
      '$sha256Column ${DBType.text} NOT NULL);';

  static const String tableName = 'logins';

  static const String idColumn = 'id';
  static const String uuidColumn = 'uuid';
  static const String usernameColumn = 'username';
  static const String passwordColumn = 'password';
  static const String saltColumn = 'salt';
  static const String md5Column = 'md5';
  static const String sha1Column = 'sha1';
  static const String sha256Column = 'sha256';
}
