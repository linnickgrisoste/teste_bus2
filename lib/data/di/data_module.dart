import 'package:teste_bus2/data/repositories/user_repository.dart';
import 'package:teste_bus2/data/services/user_service.dart';
import 'package:teste_bus2/support/service_locator/app_module.dart';
import 'package:teste_bus2/support/service_locator/service_locator.dart';

class DataModule implements AppModule {
  @override
  void registerDependencies() {
    /// MARK: Services
    ServiceLocator.registerLazySingleton<UserService>(() => UserService());

    /// MARK: Repositories
    ServiceLocator.registerLazySingleton<UserRepositoryProtocol>(
      () => UserRepository(userService: ServiceLocator.get()),
    );
  }
}
