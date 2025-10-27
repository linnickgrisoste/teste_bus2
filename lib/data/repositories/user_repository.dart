import 'package:teste_bus2/data/models/user_model.dart';
import 'package:teste_bus2/data/services/api_provider.dart';
import 'package:teste_bus2/data/services/user_service.dart';

abstract class UserRepositoryProtocol {
  void getUser({required Success success, required Failure failure});
}

class UserRepository extends UserRepositoryProtocol {
  final UserService userService;

  UserRepository({required this.userService});

  @override
  void getUser({required Success success, required Failure failure}) {
    userService.getUser(
      success: (response) {
        try {
          final user = UserModel.fromMap(response['results'][0]);
          success.call(user);
        } on Exception catch (error) {
          failure.call(error);
        }
      },
      failure: (error) {
        error.toString();
      },
    );
  }
}
