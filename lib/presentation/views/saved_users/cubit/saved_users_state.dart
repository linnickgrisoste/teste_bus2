import 'package:equatable/equatable.dart';
import 'package:teste_bus2/core/app_status.dart';
import 'package:teste_bus2/data/models/user_model.dart';

class SavedUsersState extends Equatable {
  final AppStatus status;
  final List<UserModel> users;
  final String errorMessage;

  const SavedUsersState({required this.status, required this.users, required this.errorMessage});

  factory SavedUsersState.initial() => const SavedUsersState(status: AppStatus.initial, users: [], errorMessage: '');

  bool get isEmpty => status == AppStatus.success && users.isEmpty;
  int get totalUsers => users.length;

  @override
  List<Object?> get props => [status, users, errorMessage];

  SavedUsersState copyWith({AppStatus? status, List<UserModel>? users, String? errorMessage}) {
    return SavedUsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
