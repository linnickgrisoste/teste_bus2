import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teste_bus2/ui/core/ui/default_app_bar.dart';

void main() {
  group('DefaultAppBar -', () {
    testWidgets('deve_renderizar_titulo_corretamente', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: DefaultAppBar(title: 'Teste')),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      expect(find.text('Teste'), findsOneWidget);
    });

    testWidgets('deve_aplicar_gradiente_roxo_azul', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: DefaultAppBar(title: 'Teste')),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      final container = tester.widget<Container>(
        find.descendant(of: find.byType(DefaultAppBar), matching: find.byType(Container)),
      );

      final decoration = container.decoration as BoxDecoration;
      final gradient = decoration.gradient as LinearGradient;

      expect(gradient.colors, [const Color(0xFF5E72E4), const Color(0xFF825EE4)]);
    });

    testWidgets('deve_exibir_actions_quando_fornecidas', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: DefaultAppBar(
              title: 'Teste',
              actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('deve_centralizar_titulo_quando_centerTitle_true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: DefaultAppBar(title: 'Teste', centerTitle: true)),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.centerTitle, isTrue);
    });

    testWidgets('deve_ter_altura_padrao_de_toolbar', (tester) async {
      const defaultAppBar = DefaultAppBar(title: 'Teste');

      expect(defaultAppBar.preferredSize.height, kToolbarHeight);
    });
  });
}
