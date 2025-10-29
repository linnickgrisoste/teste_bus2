import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teste_bus2/data/models/user_model.dart';
import 'package:teste_bus2/data/repositories/user_repository.dart';
import 'package:teste_bus2/data/services/local_user_service.dart';
import 'package:teste_bus2/data/services/setup/api_provider.dart';
import 'package:teste_bus2/data/services/user_service.dart';
import 'package:teste_bus2/domain/models/user_entity.dart';

import '../../../fixtures/user_fixture.dart';

class MockUserService extends Mock implements UserService {}

class MockLocalUserService extends Mock implements LocalUserServiceProtocol {}

class FakeUserEntity extends Fake implements UserEntity {}

class FakeUserModel extends Fake implements UserModel {}

void main() {
  late UserRepository repository;
  late MockUserService mockUserService;
  late MockLocalUserService mockLocalUserService;

  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
    registerFallbackValue(FakeUserModel());
  });

  setUp(() {
    mockUserService = MockUserService();
    mockLocalUserService = MockLocalUserService();
    repository = UserRepository(userService: mockUserService, localUserService: mockLocalUserService);
  });

  group('UserRepository - API', () {
    test('deve_buscar_usuario_da_api_com_sucesso', () {
      var successCalled = false;

      when(
        () => mockUserService.getUser(
          success: any(named: 'success'),
          failure: any(named: 'failure'),
        ),
      ).thenAnswer((invocation) {
        final success = invocation.namedArguments[#success] as Success;
        final mockResponse = <String, dynamic>{
          'results': [
            <String, dynamic>{'email': 'test@test.com', 'gender': 'male'},
          ],
        };
        success(mockResponse);
      });

      repository.getUser(success: (result) => successCalled = true, failure: (_) {});

      expect(successCalled, isTrue);
      verify(
        () => mockUserService.getUser(
          success: any(named: 'success'),
          failure: any(named: 'failure'),
        ),
      ).called(1);
    });
  });

  group('UserRepository - Local', () {
    test('deve_salvar_usuario_localmente_com_sucesso', () async {
      final user = UserFixture.createUser();
      when(() => mockLocalUserService.saveUser(any())).thenAnswer((_) async => 1);

      final result = await repository.saveLocalUser(user);

      expect(result, isTrue);
      verify(() => mockLocalUserService.saveUser(any())).called(1);
    });

    test('deve_retornar_false_ao_falhar_salvar_usuario', () async {
      final user = UserFixture.createUser();
      when(() => mockLocalUserService.saveUser(any())).thenThrow(Exception('Erro'));

      final result = await repository.saveLocalUser(user);

      expect(result, isFalse);
    });

    test('deve_verificar_se_usuario_esta_salvo', () async {
      when(() => mockLocalUserService.isUserSaved(any())).thenAnswer((_) async => true);

      final result = await repository.isLocalUserSaved('test@email.com');

      expect(result, isTrue);
      verify(() => mockLocalUserService.isUserSaved('test@email.com')).called(1);
    });

    test('deve_retornar_false_ao_verificar_usuario_nao_salvo', () async {
      when(() => mockLocalUserService.isUserSaved(any())).thenAnswer((_) async => false);

      final result = await repository.isLocalUserSaved('test@email.com');

      expect(result, isFalse);
    });

    test('deve_deletar_usuario_com_sucesso', () async {
      when(() => mockLocalUserService.deleteUser(any())).thenAnswer((_) async => 1);

      final result = await repository.deleteLocalUser('test@email.com');

      expect(result, isTrue);
      verify(() => mockLocalUserService.deleteUser('test@email.com')).called(1);
    });

    test('deve_retornar_false_ao_falhar_deletar_usuario', () async {
      when(() => mockLocalUserService.deleteUser(any())).thenThrow(Exception('Erro'));

      final result = await repository.deleteLocalUser('test@email.com');

      expect(result, isFalse);
    });

    test('deve_retornar_lista_de_usuarios_salvos', () async {
      final users = UserFixture.createUserModelList(3);
      when(() => mockLocalUserService.getAllSavedUsers()).thenAnswer((_) async => users);

      final result = await repository.getAllLocalUsers();

      expect(result.length, 3);
      verify(() => mockLocalUserService.getAllSavedUsers()).called(1);
    });

    test('deve_retornar_lista_vazia_ao_falhar_buscar_usuarios', () async {
      when(() => mockLocalUserService.getAllSavedUsers()).thenThrow(Exception('Erro'));

      final result = await repository.getAllLocalUsers();

      expect(result, isEmpty);
    });
  });
}
