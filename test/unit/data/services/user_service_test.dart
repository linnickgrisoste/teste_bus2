import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teste_bus2/data/services/setup/api_provider.dart';
import 'package:teste_bus2/data/services/setup/endpoint.dart';
import 'package:teste_bus2/data/services/user_service.dart';

class MockApiProvider extends Mock implements ApiProvider {}

class FakeEndpoint extends Fake implements Endpoint {}

void main() {
  late UserService userService;
  late MockApiProvider mockApiProvider;

  setUpAll(() {
    registerFallbackValue(FakeEndpoint());
  });

  setUp(() {
    mockApiProvider = MockApiProvider();
    userService = UserService(apiProvider: mockApiProvider);
  });

  group('UserService', () {
    test('deve_chamar_api_provider_com_endpoint_correto', () {
      var capturedEndpoint;

      when(
        () => mockApiProvider.request(
          endpoint: any(named: 'endpoint'),
          success: any(named: 'success'),
          failure: any(named: 'failure'),
        ),
      ).thenAnswer((invocation) async {
        capturedEndpoint = invocation.namedArguments[#endpoint];
      });

      userService.getUser(success: (_) {}, failure: (_) {});

      verify(
        () => mockApiProvider.request(
          endpoint: any(named: 'endpoint'),
          success: any(named: 'success'),
          failure: any(named: 'failure'),
        ),
      ).called(1);

      expect(capturedEndpoint, isNotNull);
      final endpoint = capturedEndpoint as Endpoint;
      expect(endpoint.path, '/api');
      expect(endpoint.method, 'GET');
      expect(endpoint.queryParameters, {'results': 1});
    });

    test('deve_executar_callback_de_sucesso', () {
      var successCalled = false;
      final mockResponse = {
        'results': [{}],
      };

      when(
        () => mockApiProvider.request(
          endpoint: any(named: 'endpoint'),
          success: any(named: 'success'),
          failure: any(named: 'failure'),
        ),
      ).thenAnswer((invocation) async {
        final success = invocation.namedArguments[#success] as Success;
        success(mockResponse);
      });

      userService.getUser(
        success: (response) {
          successCalled = true;
          expect(response, mockResponse);
        },
        failure: (_) {},
      );

      expect(successCalled, isTrue);
    });

    test('deve_executar_callback_de_falha', () {
      var failureCalled = false;
      final mockError = Exception('API Error');

      when(
        () => mockApiProvider.request(
          endpoint: any(named: 'endpoint'),
          success: any(named: 'success'),
          failure: any(named: 'failure'),
        ),
      ).thenAnswer((invocation) async {
        final failure = invocation.namedArguments[#failure] as Failure;
        failure(mockError);
      });

      userService.getUser(
        success: (_) {},
        failure: (error) {
          failureCalled = true;
          expect(error, mockError);
        },
      );

      expect(failureCalled, isTrue);
    });
  });
}
