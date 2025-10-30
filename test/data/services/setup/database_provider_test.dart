import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:teste_bus2/data/services/setup/database_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DatabaseProvider', () {
    late DatabaseProvider databaseProvider;

    setUpAll(() {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });

    setUp(() {
      databaseProvider = DatabaseProvider.instance;
    });

    tearDown(() async {
      try {
        await databaseProvider.close();
      } catch (e) {
        // Ignora se não estiver inicializado
      }
    });

    group('Construtor', () {
      test('deve_ser_singleton', () {
        final instance1 = DatabaseProvider.instance;
        final instance2 = DatabaseProvider.instance;

        expect(instance1, same(instance2));
      });

      test('deve_ter_currentVersion_correta', () {
        expect(databaseProvider.currentVersion, 1);
      });
    });

    group('tables', () {
      test('deve_retornar_lista_com_todas_tabelas_necessarias', () {
        final tables = databaseProvider.tables;

        expect(tables, isNotEmpty);
        expect(tables.length, greaterThanOrEqualTo(10));
      });
    });

    group('database getter', () {
      test('deve_lancar_excecao_quando_nao_inicializado', () {
        expect(
          () => databaseProvider.database,
          throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Database not initialized'))),
        );
      });

      test('deve_retornar_database_apos_inicializar', () async {
        await databaseProvider.initialize();

        final db = databaseProvider.database;
        expect(db, isNotNull);
        expect(db.isOpen, isTrue);
      });
    });

    group('initialize', () {
      test('deve_inicializar_database_e_criar_tabelas', () async {
        await databaseProvider.initialize();

        final db = databaseProvider.database;
        expect(db.isOpen, isTrue);

        final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name");
        expect(tables.isNotEmpty, isTrue);
        expect(tables.any((row) => row['name'] == 'users'), isTrue);
      });

      test('deve_permitir_chamar_initialize_multiplas_vezes', () async {
        await databaseProvider.initialize();
        final db1 = databaseProvider.database;

        await databaseProvider.initialize();
        final db2 = databaseProvider.database;

        expect(db1, isNotNull);
        expect(db2, isNotNull);
      });
    });

    group('close', () {
      test('deve_fechar_database_e_impedir_acesso', () async {
        await databaseProvider.initialize();
        expect(databaseProvider.database.isOpen, isTrue);

        await databaseProvider.close();

        expect(() => databaseProvider.database, throwsA(isA<Exception>()));
      });

      test('deve_permitir_chamar_close_multiplas_vezes', () async {
        await databaseProvider.initialize();
        await databaseProvider.close();

        expect(() => databaseProvider.close(), returnsNormally);
      });

      test('nao_deve_fechar_quando_nao_inicializado', () async {
        expect(() => databaseProvider.close(), returnsNormally);
      });
    });

    group('Integração', () {
      test('deve_permitir_ciclo_completo_initialize_close', () async {
        await databaseProvider.initialize();
        expect(databaseProvider.database.isOpen, isTrue);

        await databaseProvider.close();

        await databaseProvider.initialize();
        expect(databaseProvider.database.isOpen, isTrue);

        await databaseProvider.close();
      });

      test('deve_criar_estrutura_completa_do_banco', () async {
        await databaseProvider.initialize();

        final db = databaseProvider.database;
        final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name");
        final tableNames = tables.map((row) => row['name'] as String).toList();

        expect(tableNames.contains('names'), isTrue);
        expect(tableNames.contains('users'), isTrue);
        expect(tableNames.contains('locations'), isTrue);
        expect(tableNames.contains('coordinates'), isTrue);
        expect(tableNames.contains('timezones'), isTrue);
        expect(tableNames.contains('streets'), isTrue);
        expect(tableNames.contains('logins'), isTrue);
        expect(tableNames.contains('dobs'), isTrue);
        expect(tableNames.contains('registered'), isTrue);
        expect(tableNames.contains('pictures'), isTrue);
        expect(tableNames.contains('user_ids'), isTrue);
      });
    });
  });
}
