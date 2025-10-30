import 'package:flutter_test/flutter_test.dart';
import 'package:teste_bus2/core/ticker/ticker_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TickerManager', () {
    test('deve_ter_estado_inicial_correto', () {
      final tickerManager = TickerManager(fetchInterval: const Duration(seconds: 1));

      expect(tickerManager.isActive, isFalse);
      expect(tickerManager.onTick, isNull);

      tickerManager.dispose();
    });

    testWidgets('deve_ativar_ticker_ao_iniciar', (tester) async {
      final tickerManager = TickerManager(fetchInterval: const Duration(seconds: 1));

      tickerManager.start(tester);

      expect(tickerManager.isActive, isTrue);

      tickerManager.dispose();
    });

    testWidgets('deve_parar_ticker_ao_chamar_stop', (tester) async {
      final tickerManager = TickerManager(fetchInterval: const Duration(seconds: 1));

      tickerManager.start(tester);
      expect(tickerManager.isActive, isTrue);

      tickerManager.stop();
      expect(tickerManager.isActive, isFalse);

      tickerManager.dispose();
    });

    testWidgets('deve_limpar_ticker_ao_fazer_dispose', (tester) async {
      final tickerManager = TickerManager(fetchInterval: const Duration(seconds: 1));

      tickerManager.start(tester);
      expect(tickerManager.isActive, isTrue);

      tickerManager.dispose();
      expect(tickerManager.isActive, isFalse);
    });

    testWidgets('deve_respeitar_intervalo_de_fetch', (tester) async {
      final tickerManager = TickerManager(fetchInterval: const Duration(milliseconds: 100));

      expect(tickerManager.fetchInterval, const Duration(milliseconds: 100));

      tickerManager.dispose();
    });

    testWidgets('deve_permitir_reassociar_callback_onTick', (tester) async {
      final tickerManager = TickerManager(fetchInterval: const Duration(seconds: 1));

      tickerManager.onTick = () {};
      expect(tickerManager.onTick, isNotNull);

      tickerManager.onTick = null;
      expect(tickerManager.onTick, isNull);

      tickerManager.dispose();
    });
  });
}
