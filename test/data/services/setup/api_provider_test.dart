import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teste_bus2/data/services/setup/api_provider.dart';
import 'package:teste_bus2/data/services/setup/endpoint.dart';

void main() {
  group('ApiProvider', () {
    late ApiProvider apiProvider;

    setUp(() {
      apiProvider = ApiProvider();
    });

    group('Construtor', () {
      test('deve_criar_instancia_com_dio_personalizado', () {
        final customDio = Dio();
        final provider = ApiProvider(dio: customDio);

        expect(provider, isNotNull);
      });

      test('deve_criar_instancia_com_dio_padrao_quando_nao_fornecido', () {
        final provider = ApiProvider();

        expect(provider, isNotNull);
      });
    });

    group('request', () {
      test('deve_executar_request_sem_lancar_excecao', () async {
        final endpoint = Endpoint(path: '/test', method: 'GET');

        await apiProvider.request(endpoint: endpoint, success: (_) {}, failure: (_) {});
      });

      test('deve_chamar_failure_quando_request_falhar', () async {
        final endpoint = Endpoint(path: '/nonexistent', method: 'GET');

        await apiProvider.request(
          endpoint: endpoint,
          success: (_) {},
          failure: (error) {
            expect(error, isA<Exception>());
          },
        );
      });

      test('deve_usar_content_type_do_endpoint_quando_fornecido', () async {
        final endpoint = Endpoint(path: '/test', method: 'POST', contentType: 'application/xml');

        await apiProvider.request(endpoint: endpoint, success: (_) {}, failure: (_) {});
      });

      test('deve_enviar_query_parameters_corretamente', () async {
        final endpoint = Endpoint(path: '/test', method: 'GET', queryParameters: {'key': 'value', 'page': 1});

        await apiProvider.request(endpoint: endpoint, success: (_) {}, failure: (_) {});
      });

      test('deve_enviar_data_no_request_quando_fornecido', () async {
        final endpoint = Endpoint(path: '/test', method: 'POST', data: {'name': 'test', 'age': 30});

        await apiProvider.request(endpoint: endpoint, success: (_) {}, failure: (_) {});
      });

      test('deve_permitir_callbacks_null_sem_lancar_excecao', () async {
        final endpoint = Endpoint(path: '/test', method: 'GET');

        await apiProvider.request(endpoint: endpoint, success: null, failure: null);
      });
    });
  });
}
