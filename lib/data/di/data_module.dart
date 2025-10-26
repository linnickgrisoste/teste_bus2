import 'package:teste_bus2/data/repositories/user_repository.dart';
import 'package:teste_bus2/data/services/api_service.dart';
import 'package:teste_bus2/support/service_locator/app_module.dart';
import 'package:teste_bus2/support/service_locator/service_locator.dart';

class DataModule implements AppModule {
  @override
  void registerDependencies() {
    ServiceLocator.registerLazySingleton<ApiService>(() => ApiService());

    ServiceLocator.registerLazySingleton<UserRepositoryProtocol>(
      () => UserRepository(apiService: ServiceLocator.get()),
    );
  }
}
