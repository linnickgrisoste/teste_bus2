import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teste_bus2/core/app_status.dart';
import 'package:teste_bus2/core/ticker/ticker_manager.dart';
import 'package:teste_bus2/data/repositories/user_repository.dart';
import 'package:teste_bus2/domain/models/user_entity.dart';
import 'package:teste_bus2/ui/home/view_model/home_cubit.dart';
import 'package:teste_bus2/ui/home/view_model/home_state.dart';

import '../../fixtures/user_fixture.dart';

class MockUserRepository extends Mock implements UserRepositoryProtocol {}

class MockTickerManager extends Mock implements TickerManagerProtocol {}

class MockTickerProvider extends Mock implements TickerProvider {}

class FakeTickerProvider extends Fake implements TickerProvider {}

void main() {
  late MockUserRepository mockUserRepository;
  late MockTickerManager mockTickerManager;
  late HomeCubit cubit;

  setUpAll(() {
    registerFallbackValue(FakeTickerProvider());
  });

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockTickerManager = MockTickerManager();
    cubit = HomeCubit(userRepository: mockUserRepository, tickerManager: mockTickerManager);
  });

  tearDown(() {
    cubit.close();
  });

  group('HomeCubit -', () {
    test('deve_ter_estado_inicial_correto', () {
      expect(cubit.state, HomeState.initial());
      expect(cubit.state.status, AppStatus.initial);
      expect(cubit.state.users, isEmpty);
      expect(cubit.state.errorMessage, '');
    });

    blocTest<HomeCubit, HomeState>(
      'deve_buscar_usuario_com_sucesso',
      build: () {
        when(
          () => mockUserRepository.getUser(
            success: any(named: 'success'),
            failure: any(named: 'failure'),
          ),
        ).thenAnswer((invocation) {
          final success = invocation.namedArguments[#success] as Function(UserEntity);
          success(UserFixture.createUser());
        });
        return cubit;
      },
      act: (cubit) => cubit.fetchUsers(),
      verify: (cubit) {
        expect(cubit.state.status, AppStatus.success);
        expect(cubit.state.users.length, 1);
      },
    );

    blocTest<HomeCubit, HomeState>(
      'deve_adicionar_multiplos_usuarios_mantendo_lista_existente',
      build: () {
        when(
          () => mockUserRepository.getUser(
            success: any(named: 'success'),
            failure: any(named: 'failure'),
          ),
        ).thenAnswer((invocation) {
          final success = invocation.namedArguments[#success] as Function(UserEntity);
          success(UserFixture.createUser());
        });
        return cubit;
      },
      act: (cubit) async {
        await cubit.fetchUsers();
        await cubit.fetchUsers();
      },
      verify: (cubit) {
        expect(cubit.state.users.length, 2);
      },
    );

    blocTest<HomeCubit, HomeState>(
      'deve_emitir_erro_quando_falhar_busca',
      build: () {
        when(
          () => mockUserRepository.getUser(
            success: any(named: 'success'),
            failure: any(named: 'failure'),
          ),
        ).thenAnswer((invocation) {
          final failure = invocation.namedArguments[#failure] as Function(Exception);
          failure(Exception('Erro de rede'));
        });
        return cubit;
      },
      act: (cubit) => cubit.fetchUsers(),
      expect: () => [
        HomeState(status: AppStatus.loading, users: const [], errorMessage: ''),
        HomeState(
          status: AppStatus.error,
          users: const [],
          errorMessage: 'Erro ao carregar usuários: Exception: Erro de rede',
        ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'deve_limpar_lista_de_usuarios',
      build: () => cubit,
      seed: () => HomeState(status: AppStatus.success, users: UserFixture.createUserList(3), errorMessage: ''),
      act: (cubit) => cubit.clearUsers(),
      expect: () => [HomeState(status: AppStatus.initial, users: const [], errorMessage: '')],
    );

    test('deve_configurar_ticker_manager_ao_iniciar', () {
      final mockTickerProvider = MockTickerProvider();
      when(() => mockTickerManager.start(any())).thenReturn(null);
      when(() => mockTickerManager.onTick = any()).thenReturn(null);

      cubit.startUserFetching(mockTickerProvider);

      verify(() => mockTickerManager.start(mockTickerProvider)).called(1);
      verify(() => mockTickerManager.onTick = any()).called(1);
    });

    test('deve_dispor_ticker_manager_ao_fechar', () async {
      when(() => mockTickerManager.dispose()).thenReturn(null);

      await cubit.close();

      verify(() => mockTickerManager.dispose()).called(1);
    });
  });

  group('HomeState -', () {
    test('deve_verificar_isEmpty_quando_sucesso_e_lista_vazia', () {
      final state = HomeState(status: AppStatus.success, users: const [], errorMessage: '');
      expect(state.isEmpty, isTrue);
    });

    test('deve_verificar_isEmpty_quando_tem_usuarios', () {
      final state = HomeState(status: AppStatus.success, users: UserFixture.createUserList(1), errorMessage: '');
      expect(state.isEmpty, isFalse);
    });

    test('deve_verificar_isLoading', () {
      final state = HomeState(status: AppStatus.loading, users: const [], errorMessage: '');
      expect(state.isLoading, isTrue);
    });

    test('deve_copiar_estado_corretamente', () {
      final state = HomeState.initial();
      final newState = state.copyWith(status: AppStatus.success, users: UserFixture.createUserList(2));

      expect(newState.status, AppStatus.success);
      expect(newState.users.length, 2);
      expect(newState.errorMessage, '');
    });
  });
}
