import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teste_bus2/core/app_status.dart';
import 'package:teste_bus2/data/models/user_model.dart';
import 'package:teste_bus2/data/repositories/user_repository.dart';
import 'package:teste_bus2/ui/user_detail/view_model/user_detail_cubit.dart';
import 'package:teste_bus2/ui/user_detail/view_model/user_detail_state.dart';

import '../../fixtures/user_fixture.dart';

class MockUserRepository extends Mock implements UserRepositoryProtocol {}

class FakeUserModel extends Fake implements UserModel {}

void main() {
  late MockUserRepository mockUserRepository;
  late UserDetailCubit cubit;

  setUpAll(() {
    registerFallbackValue(FakeUserModel());
  });

  setUp(() {
    mockUserRepository = MockUserRepository();
    cubit = UserDetailCubit(userRepository: mockUserRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('UserDetailCubit -', () {
    test('deve_ter_estado_inicial_correto', () {
      expect(cubit.state, UserDetailState.initial());
      expect(cubit.state.status, AppStatus.initial);
      expect(cubit.state.isSaved, isFalse);
      expect(cubit.state.errorMessage, isNull);
    });

    blocTest<UserDetailCubit, UserDetailState>(
      'deve_verificar_se_usuario_esta_salvo',
      build: () {
        when(() => mockUserRepository.isLocalUserSaved(any())).thenAnswer((_) async => true);
        return cubit;
      },
      act: (cubit) => cubit.checkIfUserIsSaved('test@example.com'),
      expect: () => [
        const UserDetailState(status: AppStatus.loading, isSaved: false),
        const UserDetailState(status: AppStatus.initial, isSaved: true),
      ],
      verify: (_) {
        verify(() => mockUserRepository.isLocalUserSaved('test@example.com')).called(1);
      },
    );

    blocTest<UserDetailCubit, UserDetailState>(
      'deve_verificar_se_usuario_nao_esta_salvo',
      build: () {
        when(() => mockUserRepository.isLocalUserSaved(any())).thenAnswer((_) async => false);
        return cubit;
      },
      act: (cubit) => cubit.checkIfUserIsSaved('test@example.com'),
      expect: () => [
        const UserDetailState(status: AppStatus.loading, isSaved: false),
        const UserDetailState(status: AppStatus.initial, isSaved: false),
      ],
    );

    blocTest<UserDetailCubit, UserDetailState>(
      'deve_salvar_usuario_quando_nao_esta_salvo',
      build: () {
        when(() => mockUserRepository.saveLocalUser(any())).thenAnswer((_) async => true);
        return cubit;
      },
      seed: () => const UserDetailState(status: AppStatus.initial, isSaved: false),
      act: (cubit) => cubit.toggleUserPersistence(UserFixture.createUser()),
      expect: () => [
        const UserDetailState(status: AppStatus.loading, isSaved: false),
        const UserDetailState(status: AppStatus.success, isSaved: true),
      ],
      verify: (_) {
        verify(() => mockUserRepository.saveLocalUser(any())).called(1);
      },
    );

    blocTest<UserDetailCubit, UserDetailState>(
      'deve_remover_usuario_quando_esta_salvo',
      build: () {
        when(() => mockUserRepository.deleteLocalUser(any())).thenAnswer((_) async => true);
        return cubit;
      },
      seed: () => const UserDetailState(status: AppStatus.initial, isSaved: true),
      act: (cubit) => cubit.toggleUserPersistence(UserFixture.createUser()),
      expect: () => [
        const UserDetailState(status: AppStatus.loading, isSaved: true),
        const UserDetailState(status: AppStatus.success, isSaved: false),
      ],
      verify: (_) {
        verify(() => mockUserRepository.deleteLocalUser(any())).called(1);
      },
    );

    blocTest<UserDetailCubit, UserDetailState>(
      'deve_emitir_erro_quando_falhar_ao_salvar_usuario',
      build: () {
        when(() => mockUserRepository.saveLocalUser(any())).thenAnswer((_) async => false);
        return cubit;
      },
      seed: () => const UserDetailState(status: AppStatus.initial, isSaved: false),
      act: (cubit) => cubit.toggleUserPersistence(UserFixture.createUser()),
      expect: () => [
        const UserDetailState(status: AppStatus.loading, isSaved: false),
        const UserDetailState(status: AppStatus.error, isSaved: false, errorMessage: 'Erro ao salvar usuário'),
      ],
    );

    blocTest<UserDetailCubit, UserDetailState>(
      'deve_emitir_erro_quando_falhar_ao_remover_usuario',
      build: () {
        when(() => mockUserRepository.deleteLocalUser(any())).thenAnswer((_) async => false);
        return cubit;
      },
      seed: () => const UserDetailState(status: AppStatus.initial, isSaved: true),
      act: (cubit) => cubit.toggleUserPersistence(UserFixture.createUser()),
      expect: () => [
        const UserDetailState(status: AppStatus.loading, isSaved: true),
        const UserDetailState(status: AppStatus.error, isSaved: true, errorMessage: 'Erro ao remover usuário'),
      ],
    );
  });

  group('UserDetailState -', () {
    test('deve_verificar_isLoading_quando_loading', () {
      const state = UserDetailState(status: AppStatus.loading, isSaved: false);
      expect(state.isLoading, isTrue);
    });

    test('deve_verificar_isLoading_quando_nao_loading', () {
      const state = UserDetailState(status: AppStatus.success, isSaved: false);
      expect(state.isLoading, isFalse);
    });

    test('deve_copiar_estado_corretamente', () {
      const state = UserDetailState(status: AppStatus.initial, isSaved: false);
      final newState = state.copyWith(status: AppStatus.success, isSaved: true, errorMessage: 'Erro teste');

      expect(newState.status, AppStatus.success);
      expect(newState.isSaved, isTrue);
      expect(newState.errorMessage, 'Erro teste');
    });

    test('deve_manter_valores_ao_copiar_sem_parametros', () {
      const state = UserDetailState(status: AppStatus.success, isSaved: true, errorMessage: 'Mensagem');
      final newState = state.copyWith();

      expect(newState.status, AppStatus.success);
      expect(newState.isSaved, isTrue);
      expect(newState.errorMessage, 'Mensagem');
    });
  });
}
