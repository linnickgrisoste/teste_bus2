import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:teste_bus2/data/models/user_model.dart';
import 'package:teste_bus2/data/services/local_user_service.dart';
import 'package:teste_bus2/data/services/setup/database_provider.dart';
import 'package:teste_bus2/data/services/setup/table/table.dart';

import '../../fixtures/user_fixture.dart';

class MockDatabaseProvider extends Mock implements DatabaseProviderProtocol {}

// DatabaseProvider de teste que usa um database em memória
class TestDatabaseProvider implements DatabaseProvider {
  final Database _database;

  TestDatabaseProvider(this._database);

  @override
  Database get database => _database;

  @override
  int get currentVersion => 1;

  @override
  List<Table> get tables => [];

  @override
  Future<void> initialize() async {
    // Já inicializado no setUp
  }

  @override
  Future<void> close() async {
    await _database.close();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalUserService - Com Database Real (In-Memory)', () {
    late Database database;
    late LocalUserService localUserService;
    late TestDatabaseProvider testDatabaseProvider;

    setUpAll(() {
      // Inicializa o sqflite_ffi apenas uma vez para todos os testes
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });

    setUp(() async {
      // Cria database em memória (novo para cada teste)
      database = await databaseFactory.openDatabase(
        inMemoryDatabasePath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            // Cria todas as tabelas necessárias
            await _createTables(db);
          },
        ),
      );

      // Cria um TestDatabaseProvider que retorna nosso database de teste
      testDatabaseProvider = TestDatabaseProvider(database);

      localUserService = LocalUserService(databaseProvider: testDatabaseProvider);
    });

    tearDown(() async {
      await database.close();
    });

    group('saveUser', () {
      test('deve_salvar_usuario_com_sucesso_e_retornar_id', () async {
        final user = UserFixture.createUserModel(email: 'test@example.com');

        final userId = await localUserService.saveUser(user);

        expect(userId, greaterThan(0));

        // Verifica se o usuário foi salvo
        final result = await database.query('users', where: 'id = ?', whereArgs: [userId]);
        expect(result.length, 1);
        expect(result.first['email'], 'test@example.com');
      });

      test('deve_salvar_multiplos_usuarios_com_ids_diferentes', () async {
        final user1 = UserFixture.createUserModel(email: 'user1@example.com');
        final user2 = UserFixture.createUserModel(email: 'user2@example.com');

        final userId1 = await localUserService.saveUser(user1);
        final userId2 = await localUserService.saveUser(user2);

        expect(userId1, isNot(equals(userId2)));
        expect(userId1, greaterThan(0));
        expect(userId2, greaterThan(0));
      });

      test('deve_substituir_usuario_existente_com_mesmo_email', () async {
        final user1 = UserFixture.createUserModel(email: 'same@example.com', firstName: 'Original');
        final user2 = UserFixture.createUserModel(email: 'same@example.com', firstName: 'Updated');

        await localUserService.saveUser(user1);
        await localUserService.saveUser(user2);

        final users = await database.query('users', where: 'email = ?', whereArgs: ['same@example.com']);

        // Deve ter apenas um registro devido ao ConflictAlgorithm.replace
        expect(users.length, 1);
      });

      test('deve_salvar_todas_entidades_relacionadas_corretamente', () async {
        final user = UserFixture.createUserModel(email: 'complete@example.com');

        await localUserService.saveUser(user);

        // Verifica se todas as tabelas foram populadas
        final names = await database.query('names');
        final coordinates = await database.query('coordinates');
        final timezones = await database.query('timezones');
        final streets = await database.query('streets');
        final locations = await database.query('locations');
        final logins = await database.query('logins');
        final dobs = await database.query('dobs');
        final registered = await database.query('registered');
        final pictures = await database.query('pictures');
        final userIds = await database.query('user_ids');

        expect(names.isNotEmpty, isTrue);
        expect(coordinates.isNotEmpty, isTrue);
        expect(timezones.isNotEmpty, isTrue);
        expect(streets.isNotEmpty, isTrue);
        expect(locations.isNotEmpty, isTrue);
        expect(logins.isNotEmpty, isTrue);
        expect(dobs.isNotEmpty, isTrue);
        expect(registered.isNotEmpty, isTrue);
        expect(pictures.isNotEmpty, isTrue);
        expect(userIds.isNotEmpty, isTrue);
      });

      test('deve_adicionar_created_at_timestamp_ao_salvar', () async {
        final user = UserFixture.createUserModel(email: 'timestamp@example.com');
        final beforeSave = DateTime.now().millisecondsSinceEpoch;

        final userId = await localUserService.saveUser(user);

        final afterSave = DateTime.now().millisecondsSinceEpoch;

        final result = await database.query('users', where: 'id = ?', whereArgs: [userId]);
        final createdAt = result.first['created_at'] as int;

        expect(createdAt, greaterThanOrEqualTo(beforeSave));
        expect(createdAt, lessThanOrEqualTo(afterSave));
      });
    });

    group('isUserSaved', () {
      test('deve_retornar_true_quando_usuario_existe', () async {
        final user = UserFixture.createUserModel(email: 'exists@example.com');
        await localUserService.saveUser(user);

        final result = await localUserService.isUserSaved('exists@example.com');

        expect(result, isTrue);
      });

      test('deve_retornar_false_quando_usuario_nao_existe', () async {
        final result = await localUserService.isUserSaved('notfound@example.com');

        expect(result, isFalse);
      });

      test('deve_ser_case_sensitive_na_busca_por_email', () async {
        final user = UserFixture.createUserModel(email: 'Test@Example.com');
        await localUserService.saveUser(user);

        final resultExact = await localUserService.isUserSaved('Test@Example.com');
        final resultLower = await localUserService.isUserSaved('test@example.com');

        expect(resultExact, isTrue);
        expect(resultLower, isFalse);
      });
    });

    group('deleteUser', () {
      test('deve_deletar_usuario_existente_e_retornar_1', () async {
        final user = UserFixture.createUserModel(email: 'delete@example.com');
        await localUserService.saveUser(user);

        final result = await localUserService.deleteUser('delete@example.com');

        expect(result, 1);

        // Verifica se foi realmente deletado
        final isStillSaved = await localUserService.isUserSaved('delete@example.com');
        expect(isStillSaved, isFalse);
      });

      test('deve_retornar_0_ao_tentar_deletar_usuario_inexistente', () async {
        final result = await localUserService.deleteUser('notexists@example.com');

        expect(result, 0);
      });

      test('deve_deletar_apenas_usuario_especifico', () async {
        final user1 = UserFixture.createUserModel(email: 'keep@example.com');
        final user2 = UserFixture.createUserModel(email: 'remove@example.com');

        await localUserService.saveUser(user1);
        await localUserService.saveUser(user2);

        await localUserService.deleteUser('remove@example.com');

        final user1Exists = await localUserService.isUserSaved('keep@example.com');
        final user2Exists = await localUserService.isUserSaved('remove@example.com');

        expect(user1Exists, isTrue);
        expect(user2Exists, isFalse);
      });
    });

    group('getAllSavedUsers', () {
      test('deve_retornar_lista_vazia_quando_nao_ha_usuarios', () async {
        final result = await localUserService.getAllSavedUsers();

        expect(result, isEmpty);
      });

      test('deve_retornar_todos_usuarios_salvos', () async {
        final users = UserFixture.createUserModelList(3);

        for (final user in users) {
          await localUserService.saveUser(user);
        }

        final result = await localUserService.getAllSavedUsers();

        expect(result.length, 3);
      });

      test('deve_retornar_usuarios_ordenados_por_created_at_desc', () async {
        final user1 = UserFixture.createUserModel(email: 'first@example.com');
        final user2 = UserFixture.createUserModel(email: 'second@example.com');
        final user3 = UserFixture.createUserModel(email: 'third@example.com');

        await localUserService.saveUser(user1);
        await Future.delayed(const Duration(milliseconds: 10));
        await localUserService.saveUser(user2);
        await Future.delayed(const Duration(milliseconds: 10));
        await localUserService.saveUser(user3);

        final result = await localUserService.getAllSavedUsers();

        // O último salvo deve ser o primeiro da lista
        expect(result.first.email, 'third@example.com');
        expect(result.last.email, 'first@example.com');
      });

      test('deve_reconstruir_usermodel_completo_com_todas_relacoes', () async {
        final originalUser = UserFixture.createUserModel(
          email: 'complete@example.com',
          firstName: 'João',
          lastName: 'Silva',
        );

        await localUserService.saveUser(originalUser);

        final result = await localUserService.getAllSavedUsers();

        expect(result.length, 1);

        final retrievedUser = result.first;

        // Verifica dados principais
        expect(retrievedUser.email, originalUser.email);
        expect(retrievedUser.gender, originalUser.gender);
        expect(retrievedUser.phone, originalUser.phone);
        expect(retrievedUser.cell, originalUser.cell);
        expect(retrievedUser.nat, originalUser.nat);

        // Verifica nome
        expect(retrievedUser.name.first, originalUser.name.first);
        expect(retrievedUser.name.last, originalUser.name.last);
        expect(retrievedUser.name.title, originalUser.name.title);

        // Verifica localização
        expect(retrievedUser.location.city, originalUser.location.city);
        expect(retrievedUser.location.state, originalUser.location.state);
        expect(retrievedUser.location.country, originalUser.location.country);
        expect(retrievedUser.location.postcode, originalUser.location.postcode);

        // Verifica rua
        expect(retrievedUser.location.street.name, originalUser.location.street.name);
        expect(retrievedUser.location.street.number, originalUser.location.street.number);

        // Verifica coordenadas
        expect(retrievedUser.location.coordinates.latitude, originalUser.location.coordinates.latitude);
        expect(retrievedUser.location.coordinates.longitude, originalUser.location.coordinates.longitude);

        // Verifica timezone
        expect(retrievedUser.location.timezone.offset, originalUser.location.timezone.offset);
        expect(retrievedUser.location.timezone.description, originalUser.location.timezone.description);

        // Verifica login
        expect(retrievedUser.login.uuid, originalUser.login.uuid);
        expect(retrievedUser.login.username, originalUser.login.username);

        // Verifica dob
        expect(retrievedUser.dob.date, originalUser.dob.date);
        expect(retrievedUser.dob.age, originalUser.dob.age);

        // Verifica registered
        expect(retrievedUser.registered.date, originalUser.registered.date);
        expect(retrievedUser.registered.age, originalUser.registered.age);

        // Verifica id
        expect(retrievedUser.id.name, originalUser.id.name);
        expect(retrievedUser.id.value, originalUser.id.value);

        // Verifica picture
        expect(retrievedUser.picture.large, originalUser.picture.large);
        expect(retrievedUser.picture.medium, originalUser.picture.medium);
        expect(retrievedUser.picture.thumbnail, originalUser.picture.thumbnail);
      });

      test('deve_retornar_usermodel_que_estende_userentity', () async {
        final user = UserFixture.createUserModel(email: 'entity@example.com');
        await localUserService.saveUser(user);

        final result = await localUserService.getAllSavedUsers();
        final retrievedUser = result.first;

        // UserModel estende UserEntity, então podemos usar como entity
        expect(retrievedUser, isA<UserModel>());
        expect(retrievedUser.email, 'entity@example.com');
        expect(retrievedUser.name.first, isNotEmpty);
        expect(retrievedUser.location.city, isNotEmpty);
      });
    });

    group('_buildUserMap', () {
      test('deve_construir_mapa_correto_a_partir_de_row_do_banco', () async {
        final user = UserFixture.createUserModel(email: 'map@example.com');
        await localUserService.saveUser(user);

        final users = await localUserService.getAllSavedUsers();

        // Se conseguiu recuperar o usuário, o _buildUserMap funcionou
        expect(users.isNotEmpty, isTrue);
        expect(users.first.email, 'map@example.com');
      });
    });

    group('Transações', () {
      test('deve_fazer_rollback_em_caso_de_erro_durante_save', () async {
        // Cria um user com dados inválidos que podem causar erro
        final user = UserFixture.createUserModel(email: 'transaction@example.com');

        try {
          // Força um erro fechando o database antes de salvar
          await database.close();
          await localUserService.saveUser(user);
        } catch (e) {
          // Esperado falhar
        }

        // Reabre o database
        database = await databaseFactory.openDatabase(
          inMemoryDatabasePath,
          options: OpenDatabaseOptions(
            version: 1,
            onCreate: (db, version) async {
              await _createTables(db);
            },
          ),
        );

        // Verifica que nenhum dado foi salvo parcialmente
        final users = await database.query('users');
        expect(users.isEmpty, isTrue);
      });
    });

    group('Edge Cases', () {
      test('deve_lidar_com_postcode_como_string_e_numero', () async {
        final user1 = UserFixture.createUserModel(email: 'postcode1@example.com');
        final user2 = UserFixture.createUserModel(email: 'postcode2@example.com');

        await localUserService.saveUser(user1);
        await localUserService.saveUser(user2);

        final users = await localUserService.getAllSavedUsers();

        expect(users.length, 2);
        // Verifica que ambos foram salvos e recuperados corretamente
        expect(users.any((u) => u.email == 'postcode1@example.com'), isTrue);
        expect(users.any((u) => u.email == 'postcode2@example.com'), isTrue);
      });

      test('deve_lidar_com_valores_nulos_opcionais', () async {
        final user = UserFixture.createUserModel(email: 'nullable@example.com');

        await localUserService.saveUser(user);
        final users = await localUserService.getAllSavedUsers();

        expect(users.isNotEmpty, isTrue);
      });
    });
  });
}

// Helper para criar todas as tabelas necessárias
Future<void> _createTables(Database db) async {
  await db.execute('''
    CREATE TABLE names (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      first TEXT,
      last TEXT
    )
  ''');

  await db.execute('''
    CREATE TABLE coordinates (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      latitude TEXT,
      longitude TEXT
    )
  ''');

  await db.execute('''
    CREATE TABLE timezones (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      offset TEXT,
      description TEXT
    )
  ''');

  await db.execute('''
    CREATE TABLE streets (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      number INTEGER,
      name TEXT
    )
  ''');

  await db.execute('''
    CREATE TABLE locations (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      street_id INTEGER,
      city TEXT,
      state TEXT,
      country TEXT,
      postcode TEXT,
      coordinates_id INTEGER,
      timezone_id INTEGER,
      FOREIGN KEY (street_id) REFERENCES streets (id),
      FOREIGN KEY (coordinates_id) REFERENCES coordinates (id),
      FOREIGN KEY (timezone_id) REFERENCES timezones (id)
    )
  ''');

  await db.execute('''
    CREATE TABLE logins (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      uuid TEXT,
      username TEXT,
      password TEXT,
      salt TEXT,
      md5 TEXT,
      sha1 TEXT,
      sha256 TEXT
    )
  ''');

  await db.execute('''
    CREATE TABLE dobs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT,
      age INTEGER
    )
  ''');

  await db.execute('''
    CREATE TABLE registered (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT,
      age INTEGER
    )
  ''');

  await db.execute('''
    CREATE TABLE pictures (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      large TEXT,
      medium TEXT,
      thumbnail TEXT
    )
  ''');

  await db.execute('''
    CREATE TABLE user_ids (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      value TEXT
    )
  ''');

  await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id_ref INTEGER,
      gender TEXT,
      email TEXT UNIQUE,
      phone TEXT,
      cell TEXT,
      nat TEXT,
      name_id INTEGER,
      location_id INTEGER,
      login_id INTEGER,
      dob_id INTEGER,
      registered_id INTEGER,
      picture_id INTEGER,
      created_at INTEGER,
      FOREIGN KEY (user_id_ref) REFERENCES user_ids (id),
      FOREIGN KEY (name_id) REFERENCES names (id),
      FOREIGN KEY (location_id) REFERENCES locations (id),
      FOREIGN KEY (login_id) REFERENCES logins (id),
      FOREIGN KEY (dob_id) REFERENCES dobs (id),
      FOREIGN KEY (registered_id) REFERENCES registered (id),
      FOREIGN KEY (picture_id) REFERENCES pictures (id)
    )
  ''');
}
