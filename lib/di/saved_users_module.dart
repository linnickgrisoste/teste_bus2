import 'package:teste_bus2/data/repositories/user_repository.dart';
import 'package:teste_bus2/di/app_module.dart';
import 'package:teste_bus2/di/service_locator.dart';
import 'package:teste_bus2/ui/saved_users/view_model/saved_users_cubit.dart';

class SavedUsersModule implements AppModule {
  @override
  void registerDependencies() {
    ServiceLocator.registerFactory<SavedUsersCubit>(() {
      return SavedUsersCubit(userRepository: ServiceLocator.get<UserRepositoryProtocol>());
    });
  }
}
