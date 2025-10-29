import 'package:teste_bus2/data/repositories/user_repository.dart';
import 'package:teste_bus2/di/app_module.dart';
import 'package:teste_bus2/di/service_locator.dart';
import 'package:teste_bus2/ui/user_detail/view_model/user_detail_cubit.dart';

class UserDetailModule implements AppModule {
  @override
  void registerDependencies() {
    ServiceLocator.registerFactory<UserDetailCubit>(() {
      return UserDetailCubit(userRepository: ServiceLocator.get<UserRepositoryProtocol>());
    });
  }
}
