import 'package:teste_bus2/data/services/api_provider.dart';
import 'package:teste_bus2/data/services/api_service.dart';
import 'package:teste_bus2/models/user.dart';

abstract class UserRepositoryProtocol {
  void getUser({required Success success, required Failure failure});
}

class UserRepository extends UserRepositoryProtocol {
  final ApiService apiService;

  UserRepository({required this.apiService});

  @override
  void getUser({required Success success, required Failure failure}) {
    apiService.getUser(
      success: (response) {
        try {
          final user = User.fromMap(response['results'][0]);
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
