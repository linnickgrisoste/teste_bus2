import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teste_bus2/core/app_status.dart';
import 'package:teste_bus2/data/repositories/user_repository.dart';
import 'package:teste_bus2/ui/saved_users/view_model/saved_users_cubit.dart';
import 'package:teste_bus2/ui/saved_users/view_model/saved_users_state.dart';

import '../../fixtures/user_fixture.dart';

class MockUserRepository extends Mock implements UserRepositoryProtocol {}

void main() {
  late MockUserRepository mockUserRepository;
  late SavedUsersCubit cubit;

  setUp(() {
    mockUserRepository = MockUserRepository();
    cubit = SavedUsersCubit(userRepository: mockUserRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('SavedUsersCubit -', () {
    test('deve_ter_estado_inicial_correto', () {
      expect(cubit.state, SavedUsersState.initial());
      expect(cubit.state.status, AppStatus.initial);
      expect(cubit.state.users, isEmpty);
      expect(cubit.state.errorMessage, '');
    });

    blocTest<SavedUsersCubit, SavedUsersState>(
      'deve_carregar_usuarios_salvos_com_sucesso',
      build: () {
        final users = UserFixture.createUserModelList(3);
        when(() => mockUserRepository.getAllLocalUsers()).thenAnswer((_) async => users);
        return cubit;
      },
      act: (cubit) => cubit.loadSavedUsers(),
      verify: (cubit) {
        expect(cubit.state.status, AppStatus.success);
        expect(cubit.state.users.length, 3);
      },
    );

    blocTest<SavedUsersCubit, SavedUsersState>(
      'deve_retornar_lista_vazia_quando_nao_houver_usuarios_salvos',
      build: () {
        when(() => mockUserRepository.getAllLocalUsers()).thenAnswer((_) async => []);
        return cubit;
      },
      act: (cubit) => cubit.loadSavedUsers(),
      expect: () => [
        SavedUsersState(status: AppStatus.loading, users: const [], errorMessage: ''),
        SavedUsersState(status: AppStatus.success, users: const [], errorMessage: ''),
      ],
    );

    blocTest<SavedUsersCubit, SavedUsersState>(
      'deve_emitir_erro_quando_falhar_ao_carregar_usuarios',
      build: () {
        when(() => mockUserRepository.getAllLocalUsers()).thenThrow(Exception('Erro ao acessar banco'));
        return cubit;
      },
      act: (cubit) => cubit.loadSavedUsers(),
      expect: () => [
        SavedUsersState(status: AppStatus.loading, users: const [], errorMessage: ''),
        SavedUsersState(status: AppStatus.error, users: const [], errorMessage: 'Erro ao carregar usuários salvos'),
      ],
    );

    blocTest<SavedUsersCubit, SavedUsersState>(
      'deve_deletar_usuario_com_sucesso_e_recarregar_lista',
      build: () {
        final users = UserFixture.createUserModelList(2);
        when(() => mockUserRepository.deleteLocalUser(any())).thenAnswer((_) async => true);
        when(() => mockUserRepository.getAllLocalUsers()).thenAnswer((_) async => users);
        return cubit;
      },
      act: (cubit) => cubit.deleteUser('test@example.com'),
      verify: (cubit) {
        verify(() => mockUserRepository.deleteLocalUser('test@example.com')).called(1);
        verify(() => mockUserRepository.getAllLocalUsers()).called(1);
        expect(cubit.state.status, AppStatus.success);
        expect(cubit.state.users.length, 2);
      },
    );

    blocTest<SavedUsersCubit, SavedUsersState>(
      'deve_emitir_erro_quando_falhar_ao_deletar_usuario',
      build: () {
        when(() => mockUserRepository.deleteLocalUser(any())).thenAnswer((_) async => false);
        return cubit;
      },
      act: (cubit) => cubit.deleteUser('test@example.com'),
      expect: () => [
        SavedUsersState(status: AppStatus.error, users: const [], errorMessage: 'Erro ao remover usuário'),
      ],
      verify: (_) {
        verify(() => mockUserRepository.deleteLocalUser('test@example.com')).called(1);
        verifyNever(() => mockUserRepository.getAllLocalUsers());
      },
    );
  });

  group('SavedUsersState -', () {
    test('deve_verificar_isEmpty_quando_sucesso_e_lista_vazia', () {
      final state = SavedUsersState(status: AppStatus.success, users: const [], errorMessage: '');
      expect(state.isEmpty, isTrue);
    });

    test('deve_verificar_isEmpty_quando_tem_usuarios', () {
      final state = SavedUsersState(status: AppStatus.success, users: UserFixture.createUserList(1), errorMessage: '');
      expect(state.isEmpty, isFalse);
    });

    test('deve_retornar_total_de_usuarios_correto', () {
      final state = SavedUsersState(status: AppStatus.success, users: UserFixture.createUserList(5), errorMessage: '');
      expect(state.totalUsers, 5);
    });

    test('deve_copiar_estado_corretamente', () {
      final state = SavedUsersState.initial();
      final newState = state.copyWith(
        status: AppStatus.success,
        users: UserFixture.createUserList(3),
        errorMessage: 'teste',
      );

      expect(newState.status, AppStatus.success);
      expect(newState.users.length, 3);
      expect(newState.errorMessage, 'teste');
    });
  });
}
