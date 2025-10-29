import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste_bus2/core/app_status.dart';
import 'package:teste_bus2/data/repositories/user_repository.dart';
import 'package:teste_bus2/ui/saved_users/view_model/saved_users_state.dart';

class SavedUsersCubit extends Cubit<SavedUsersState> {
  final UserRepositoryProtocol _userRepository;

  SavedUsersCubit({required UserRepositoryProtocol userRepository})
    : _userRepository = userRepository,
      super(SavedUsersState.initial());

  Future<void> loadSavedUsers() async {
    emit(state.copyWith(status: AppStatus.loading));

    try {
      final users = await _userRepository.getAllLocalUsers();
      emit(state.copyWith(status: AppStatus.success, users: users));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error, errorMessage: 'Erro ao carregar usuários salvos'));
    }
  }

  Future<void> deleteUser(String email) async {
    final success = await _userRepository.deleteLocalUser(email);

    if (success) {
      await loadSavedUsers();
    } else {
      emit(state.copyWith(status: AppStatus.error, errorMessage: 'Erro ao remover usuário'));
    }
  }
}
