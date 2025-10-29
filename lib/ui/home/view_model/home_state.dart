import 'package:equatable/equatable.dart';
import 'package:teste_bus2/core/app_status.dart';
import 'package:teste_bus2/domain/models/user_entity.dart';

class HomeState extends Equatable {
  final AppStatus status;
  final String errorMessage;
  final List<UserEntity> users;
  const HomeState({required this.status, required this.users, required this.errorMessage});

  factory HomeState.initial() => HomeState(status: AppStatus.initial, users: [], errorMessage: '');

  bool get isEmpty => status == AppStatus.success && users.isEmpty;
  bool get isLoading => status == AppStatus.loading;

  @override
  List<Object?> get props => [status, users, errorMessage];

  HomeState copyWith({AppStatus? status, List<UserEntity>? users, String? errorMessage}) {
    return HomeState(
      errorMessage: errorMessage ?? this.errorMessage,
      users: users ?? this.users,
      status: status ?? this.status,
    );
  }
}
