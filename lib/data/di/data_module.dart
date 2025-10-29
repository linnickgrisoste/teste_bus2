import 'package:teste_bus2/data/repositories/user_repository.dart';
import 'package:teste_bus2/data/services/local_user_service.dart';
import 'package:teste_bus2/data/services/setup/database_provider.dart';
import 'package:teste_bus2/data/services/user_service.dart';
import 'package:teste_bus2/di/app_module.dart';
import 'package:teste_bus2/di/service_locator.dart';

class DataModule implements AppModule {
  @override
  void registerDependencies() {
    /// MARK: Database
    ServiceLocator.registerSingleton<DatabaseProvider>(DatabaseProvider.instance);

    /// MARK: Services
    ServiceLocator.registerLazySingleton<UserService>(() => UserService());
    ServiceLocator.registerLazySingleton<LocalUserServiceProtocol>(
      () => LocalUserService(databaseProvider: ServiceLocator.get()),
    );

    /// MARK: Repositories
    ServiceLocator.registerLazySingleton<UserRepositoryProtocol>(
      () => UserRepository(userService: ServiceLocator.get(), localUserService: ServiceLocator.get()),
    );
  }
}
