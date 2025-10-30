import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teste_bus2/ui/core/ui/fade_slide_in.dart';

void main() {
  group('FadeSlideIn -', () {
    testWidgets('nao_deve_animar_quando_enabled_false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FadeSlideIn(enabled: false, child: Text('Child'))),
        ),
      );

      expect(find.text('Child'), findsOneWidget);
      expect(find.byType(Animate), findsNothing);
    });

    testWidgets('deve_criar_Animate_com_delay_configurado', (tester) async {
      const delay = Duration(milliseconds: 150);
      const duration = Duration(milliseconds: 320);
      const beginOffsetY = 0.25;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FadeSlideIn(
              enabled: true,
              delay: delay,
              duration: duration,
              beginOffsetY: beginOffsetY,
              curve: Curves.easeOutCubic,
              child: Text('Animado'),
            ),
          ),
        ),
      );

      final animate = tester.widget<Animate>(find.byType(Animate));

      // verifica delay propagado para o Animate
      expect(animate.delay, delay);

      // Garante que a animação completa sem exceções
      await tester.pump(delay);
      await tester.pump(duration);
      await tester.pumpAndSettle();

      expect(find.text('Animado'), findsOneWidget);
    });
  });
}
