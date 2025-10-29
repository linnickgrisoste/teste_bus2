import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste_bus2/core/app_status.dart';
import 'package:teste_bus2/data/models/user_model.dart';
import 'package:teste_bus2/data/repositories/user_repository.dart';
import 'package:teste_bus2/domain/models/user_entity.dart';
import 'package:teste_bus2/ui/user_detail/view_model/user_detail_state.dart';

class UserDetailCubit extends Cubit<UserDetailState> {
  final UserRepositoryProtocol _userRepository;

  UserDetailCubit({required UserRepositoryProtocol userRepository})
    : _userRepository = userRepository,
      super(UserDetailState.initial());

  Future<void> checkIfUserIsSaved(String email) async {
    emit(state.copyWith(status: AppStatus.loading));

    final isSaved = await _userRepository.isLocalUserSaved(email);

    emit(state.copyWith(status: AppStatus.initial, isSaved: isSaved));
  }

  Future<void> toggleUserPersistence(UserEntity user) async {
    emit(state.copyWith(status: AppStatus.loading));

    if (state.isSaved) {
      await _deleteUser(user.email);
    } else {
      await _saveUser(user);
    }
  }

  Future<void> _saveUser(UserEntity user) async {
    final success = await _userRepository.saveLocalUser(UserModel.fromEntity(user));

    if (success) {
      emit(state.copyWith(status: AppStatus.success, isSaved: true));
    } else {
      emit(state.copyWith(status: AppStatus.error, errorMessage: 'Erro ao salvar usuário'));
    }
  }

  Future<void> _deleteUser(String email) async {
    final success = await _userRepository.deleteLocalUser(email);

    if (success) {
      emit(state.copyWith(status: AppStatus.success, isSaved: false));
    } else {
      emit(state.copyWith(status: AppStatus.error, errorMessage: 'Erro ao remover usuário'));
    }
  }
}
