import 'package:equatable/equatable.dart';
import 'package:teste_bus2/data/models/user_model.dart';

enum AppStatus { intial, success, error, loading }

class UserState extends Equatable {
  final AppStatus status;
  final String errorMessage;
  final List<UserModel> users;
  const UserState({required this.status, required this.users, required this.errorMessage});

  factory UserState.initial() => UserState(status: AppStatus.intial, users: [], errorMessage: '');

  bool get isEmpty => status == AppStatus.success && users.isEmpty;
  bool get isLoading => status == AppStatus.loading;

  List<UserModel> get femaleUsers => users.where((user) => user.gender == 'female').toList();

  @override
  List<Object?> get props => [status, users, errorMessage];

  UserState copyWith({AppStatus? status, List<UserModel>? users, String? errorMessage}) {
    return UserState(
      errorMessage: errorMessage ?? this.errorMessage,
      users: users ?? this.users,
      status: status ?? this.status,
    );
  }
}
