import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teste_bus2/ui/core/ui/error_state_widget.dart';

void main() {
  group('ErrorStateWidget -', () {
    testWidgets('deve_exibir_mensagem_de_erro', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              errorMessage: 'Erro de teste',
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.text('Erro de teste'), findsOneWidget);
    });

    testWidgets('deve_exibir_titulo_padrao_quando_nao_fornecido', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              errorMessage: 'Erro de teste',
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.text('Ops! Algo deu errado'), findsOneWidget);
    });

    testWidgets('deve_exibir_titulo_customizado_quando_fornecido', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              errorMessage: 'Erro de teste',
              title: 'Erro Customizado',
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.text('Erro Customizado'), findsOneWidget);
      expect(find.text('Ops! Algo deu errado'), findsNothing);
    });

    testWidgets('deve_exibir_texto_padrao_no_botao_quando_nao_fornecido', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              errorMessage: 'Erro de teste',
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.text('Tentar Novamente'), findsOneWidget);
    });

    testWidgets('deve_exibir_texto_customizado_no_botao', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              errorMessage: 'Erro de teste',
              retryButtonText: 'Tentar Outra Vez',
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.text('Tentar Outra Vez'), findsOneWidget);
      expect(find.text('Tentar Novamente'), findsNothing);
    });

    testWidgets('deve_chamar_callback_ao_clicar_no_botao', (tester) async {
      var callbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              errorMessage: 'Erro de teste',
              onRetry: () => callbackCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(callbackCalled, isTrue);
    });

    testWidgets('deve_exibir_icone_de_erro', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              errorMessage: 'Erro de teste',
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('deve_estar_centralizado', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              errorMessage: 'Erro de teste',
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Center), findsWidgets);
    });
  });
}

