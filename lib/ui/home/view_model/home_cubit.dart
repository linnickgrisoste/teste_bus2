import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste_bus2/core/app_status.dart';
import 'package:teste_bus2/core/ticker/ticker_manager.dart';
import 'package:teste_bus2/data/repositories/user_repository.dart';
import 'package:teste_bus2/ui/home/view_model/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserRepositoryProtocol _userRepository;
  final TickerManagerProtocol _tickerManager;

  HomeCubit({required UserRepositoryProtocol userRepository, required TickerManagerProtocol tickerManager})
    : _tickerManager = tickerManager,
      _userRepository = userRepository,
      super(HomeState.initial());

  void startUserFetching(TickerProvider vsync) {
    _tickerManager.onTick = fetchUsers;
    _tickerManager.start(vsync);
  }

  Future<void> fetchUsers() async {
    emit(state.copyWith(status: AppStatus.loading));
    _userRepository.getUser(
      success: (user) {
        emit(state.copyWith(status: AppStatus.success, users: [...state.users, user]));
      },
      failure: (error) {
        emit(state.copyWith(status: AppStatus.error, errorMessage: 'Erro ao carregar usuários: ${error.toString()}'));
      },
    );
  }

  void clearUsers() {
    emit(state.copyWith(status: AppStatus.initial, users: []));
  }

  @override
  Future<void> close() {
    _tickerManager.dispose();
    return super.close();
  }
}
