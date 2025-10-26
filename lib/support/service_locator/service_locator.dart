import 'package:get_it/get_it.dart';
import 'package:teste_bus2/data/di/data_module.dart';
import 'package:teste_bus2/presentation/views/home/di/home_module.dart';
import 'package:teste_bus2/support/service_locator/app_module.dart';

class ServiceLocator {
  ServiceLocator._();

  static final _provider = GetIt.instance;

  static T get<T extends Object>({dynamic param}) {
    return _provider.get<T>(param1: param);
  }

  static void registerSingleton<T extends Object>(T instance) {
    _provider.registerSingleton<T>(instance);
  }

  static void registerLazySingleton<T extends Object>(T Function() constructor) {
    _provider.registerLazySingleton<T>(constructor);
  }

  static void registerFactory<T extends Object>(T Function() constructor) {
    _provider.registerFactory<T>(constructor);
  }

  static void registerFactoryParam<T extends Object, P1>(T Function(P1) constructor) {
    _provider.registerFactoryParam<T, P1, void>((param, _) => constructor(param));
  }

  static void resetLazySingleton<T extends Object>() {
    _provider.resetLazySingleton<T>();
  }
}

void initializeDependencies() {
  final appModules = <AppModule>[DataModule(), HomeModule()];

  for (final module in appModules) {
    module.registerDependencies();
  }
}
