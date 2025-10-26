import 'package:teste_bus2/core/ticker/ticker_manager.dart';
import 'package:teste_bus2/presentation/cubits/user_cubit.dart';
import 'package:teste_bus2/support/service_locator/app_module.dart';
import 'package:teste_bus2/support/service_locator/service_locator.dart';

class HomeModule implements AppModule {
  @override
  void registerDependencies() {
    ServiceLocator.registerLazySingleton<TickerManagerProtocol>(() {
      return TickerManager(fetchInterval: const Duration(seconds: 5));
    });
    ServiceLocator.registerFactory<UserCubit>(() {
      return UserCubit(userRepository: ServiceLocator.get(), tickerManager: ServiceLocator.get());
    });
  }
}
