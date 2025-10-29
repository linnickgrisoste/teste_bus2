import 'package:teste_bus2/data/models/user_model.dart';
import 'package:teste_bus2/data/services/local_user_service.dart';
import 'package:teste_bus2/data/services/setup/api_provider.dart';
import 'package:teste_bus2/data/services/user_service.dart';
import 'package:teste_bus2/models/user_entity.dart';

abstract class UserRepositoryProtocol {
  void getUser({required Success success, required Failure failure});
  Future<bool> saveLocalUser(UserModel user);
  Future<bool> isLocalUserSaved(String email);
  Future<bool> deleteLocalUser(String email);
  Future<List<UserModel>> getAllLocalUsers();
}

class UserRepository extends UserRepositoryProtocol {
  final UserService userService;
  final LocalUserServiceProtocol localUserService;

  UserRepository({required this.userService, required this.localUserService});

  /// MARK: API Methods
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

  /// MARK: Local Methods
  @override
  Future<bool> deleteLocalUser(String email) async {
    try {
      final result = await localUserService.deleteUser(email);
      return result > 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isLocalUserSaved(String email) async {
    try {
      return await localUserService.isUserSaved(email);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> saveLocalUser(UserEntity user) async {
    try {
      await localUserService.saveUser(UserModel.fromEntity(user));
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<UserModel>> getAllLocalUsers() async {
    try {
      return await localUserService.getAllSavedUsers();
    } catch (e) {
      return [];
    }
  }
}
