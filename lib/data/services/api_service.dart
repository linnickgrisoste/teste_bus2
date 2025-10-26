import 'package:teste_bus2/data/services/api_provider.dart';
import 'package:teste_bus2/data/services/setup/endpoint.dart';

class ApiService {
  final _apiProvider = ApiProvider();

  ///MARK: Users
  void getUser({required Success success, required Failure failure}) {
    final endpoint = Endpoint(path: '/api', method: 'GET', queryParameters: {'results': 1});

    _apiProvider.request(endpoint: endpoint, success: success, failure: failure);
  }
}
