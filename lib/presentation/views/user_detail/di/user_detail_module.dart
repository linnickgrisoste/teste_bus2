import 'package:teste_bus2/data/repositories/user_repository.dart';
import 'package:teste_bus2/presentation/views/user_detail/cubit/user_detail_cubit.dart';
import 'package:teste_bus2/support/service_locator/app_module.dart';
import 'package:teste_bus2/support/service_locator/service_locator.dart';

class UserDetailModule implements AppModule {
  @override
  void registerDependencies() {
    ServiceLocator.registerFactory<UserDetailCubit>(() {
      return UserDetailCubit(userRepository: ServiceLocator.get<UserRepositoryProtocol>());
    });
  }
}
