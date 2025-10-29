import 'package:equatable/equatable.dart';
import 'package:teste_bus2/core/app_status.dart';

class UserDetailState extends Equatable {
  final AppStatus status;
  final bool isSaved;
  final String? errorMessage;

  const UserDetailState({required this.status, required this.isSaved, this.errorMessage});

  factory UserDetailState.initial() => const UserDetailState(status: AppStatus.initial, isSaved: false);

  bool get isLoading => status == AppStatus.loading;

  @override
  List<Object?> get props => [status, isSaved, errorMessage];

  UserDetailState copyWith({AppStatus? status, bool? isSaved, String? errorMessage}) {
    return UserDetailState(
      status: status ?? this.status,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
