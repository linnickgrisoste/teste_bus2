import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teste_bus2/ui/core/ui/user_item.dart';

import '../../fixtures/user_fixture.dart';

void main() {
  group('UserItem -', () {
    testWidgets('deve_exibir_nome_completo_do_usuario', (tester) async {
      final user = UserFixture.createUser(firstName: 'João', lastName: 'Silva');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserItem(user: user),
          ),
        ),
      );

      expect(find.text('João Silva'), findsOneWidget);
    });

    testWidgets('deve_exibir_idade_e_nacionalidade', (tester) async {
      final user = UserFixture.createUser();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserItem(user: user),
          ),
        ),
      );

      expect(find.text('28 anos — BR'), findsOneWidget);
    });

    testWidgets('deve_chamar_callback_onTap_ao_clicar', (tester) async {
      final user = UserFixture.createUser();
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserItem(
              user: user,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('deve_exibir_botao_delete_quando_onDelete_fornecido', (tester) async {
      final user = UserFixture.createUser();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserItem(
              user: user,
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('nao_deve_exibir_botao_delete_quando_onDelete_nao_fornecido', (tester) async {
      final user = UserFixture.createUser();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserItem(user: user),
          ),
        ),
      );

      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });

    testWidgets('deve_chamar_callback_onDelete_ao_clicar_no_botao', (tester) async {
      final user = UserFixture.createUser();
      var deleted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserItem(
              user: user,
              onDelete: () => deleted = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      expect(deleted, isTrue);
    });

    testWidgets('deve_ter_CircleAvatar_com_imagem', (tester) async {
      final user = UserFixture.createUser();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserItem(user: user),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
      
      final circleAvatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(circleAvatar.radius, 28);
    });

    testWidgets('deve_ter_bordas_arredondadas', (tester) async {
      final user = UserFixture.createUser();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserItem(user: user),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(UserItem),
          matching: find.byType(Container).first,
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      final borderRadius = decoration.borderRadius as BorderRadius;
      
      expect(borderRadius.topLeft.x, 12);
      expect(borderRadius.topRight.x, 12);
      expect(borderRadius.bottomLeft.x, 12);
      expect(borderRadius.bottomRight.x, 12);
    });

    testWidgets('deve_aplicar_padding_correto', (tester) async {
      final user = UserFixture.createUser();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserItem(user: user),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(UserItem),
          matching: find.byType(Container).first,
        ),
      );

      expect(container.padding, const EdgeInsets.symmetric(horizontal: 16, vertical: 12));
    });
  });
}

