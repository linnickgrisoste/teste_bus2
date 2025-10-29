import 'package:teste_bus2/core/ticker/ticker_manager.dart';
import 'package:teste_bus2/data/repositories/user_repository.dart';
import 'package:teste_bus2/presentation/views/home/cubit/home_cubit.dart';
import 'package:teste_bus2/support/service_locator/app_module.dart';
import 'package:teste_bus2/support/service_locator/service_locator.dart';

class HomeModule implements AppModule {
  @override
  void registerDependencies() {
    ServiceLocator.registerLazySingleton<TickerManagerProtocol>(() {
      return TickerManager(fetchInterval: const Duration(seconds: 5));
    });
    ServiceLocator.registerFactory<HomeCubit>(() {
      return HomeCubit(
        userRepository: ServiceLocator.get<UserRepositoryProtocol>(),
        tickerManager: ServiceLocator.get<TickerManagerProtocol>(),
      );
    });
  }
}
