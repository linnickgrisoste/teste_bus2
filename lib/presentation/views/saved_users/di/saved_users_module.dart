import 'package:teste_bus2/data/repositories/user_repository.dart';
import 'package:teste_bus2/presentation/views/saved_users/cubit/saved_users_cubit.dart';
import 'package:teste_bus2/support/service_locator/app_module.dart';
import 'package:teste_bus2/support/service_locator/service_locator.dart';

class SavedUsersModule implements AppModule {
  @override
  void registerDependencies() {
    ServiceLocator.registerFactory<SavedUsersCubit>(() {
      return SavedUsersCubit(userRepository: ServiceLocator.get<UserRepositoryProtocol>());
    });
  }
}
