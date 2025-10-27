import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste_bus2/core/ticker/ticker_manager.dart';
import 'package:teste_bus2/data/models/user_model.dart';
import 'package:teste_bus2/data/repositories/user_repository.dart';
import 'package:teste_bus2/presentation/cubits/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepositoryProtocol userRepository;
  final TickerManagerProtocol tickerManager;
  final List<UserModel> _users = [];

  UserCubit({required this.userRepository, required this.tickerManager}) : super(UserInitial());

  void startUserFetching(TickerProvider vsync) {
    tickerManager.onTick = fetchUsers;
    tickerManager.start(vsync);
  }

  Future<void> fetchUsers() async {
    if (_users.isEmpty) {
      emit(const UserLoading());
    }

    userRepository.getUser(
      success: (user) {
        _users.add(user);
        emit(UserSuccess(List.from(_users)));
      },
      failure: (error) {
        emit(UserError('Erro ao carregar usuários: ${error.toString()}'));
      },
    );
  }

  void clearUsers() {
    _users.clear();
    emit(UserInitial());
  }

  @override
  Future<void> close() {
    tickerManager.dispose();
    return super.close();
  }
}
