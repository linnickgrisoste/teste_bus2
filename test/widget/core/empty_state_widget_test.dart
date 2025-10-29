import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teste_bus2/ui/core/ui/empty_state_widget.dart';

void main() {
  group('EmptyStateWidget -', () {
    testWidgets('deve_exibir_titulo_e_icone', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'Nenhum item encontrado',
            ),
          ),
        ),
      );

      expect(find.text('Nenhum item encontrado'), findsOneWidget);
      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });

    testWidgets('deve_exibir_subtitulo_quando_fornecido', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'Nenhum item',
              subtitle: 'Adicione itens para começar',
            ),
          ),
        ),
      );

      expect(find.text('Adicione itens para começar'), findsOneWidget);
    });

    testWidgets('nao_deve_exibir_subtitulo_quando_nao_fornecido', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'Nenhum item',
            ),
          ),
        ),
      );

      // Deve ter apenas 2 textos: o título
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('deve_aplicar_cor_customizada_ao_icone', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'Teste',
              iconColor: Colors.blue,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.inbox));
      expect(icon.color, Colors.blue);
    });

    testWidgets('deve_aplicar_cor_de_fundo_customizada_ao_container', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'Teste',
              iconBackgroundColor: Colors.red,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(EmptyStateWidget),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.red);
    });

    testWidgets('deve_usar_cores_padroes_quando_nao_fornecidas', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'Teste',
            ),
          ),
        ),
      );

      // Verifica que o widget foi renderizado sem erros
      expect(find.byType(EmptyStateWidget), findsOneWidget);
    });

    testWidgets('deve_estar_centralizado', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'Teste',
            ),
          ),
        ),
      );

      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('deve_ter_icone_com_tamanho_64', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'Teste',
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.inbox));
      expect(icon.size, 64);
    });
  });
}

