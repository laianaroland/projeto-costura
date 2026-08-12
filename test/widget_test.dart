import 'package:flutter_test/flutter_test.dart';

import 'package:costureira_app/main.dart';

void main() {
  testWidgets('App boots to the welcome screen', (tester) async {
    await tester.pumpWidget(const CostureiraApp());
    await tester.pumpAndSettle();

    expect(find.text('Uma costureira boa, aqui do lado.'), findsOneWidget);
    expect(find.text('Começar'), findsOneWidget);
  });

  testWidgets('Choosing "Preciso de costura" leads to client signup', (tester) async {
    await tester.pumpWidget(const CostureiraApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Começar'));
    await tester.tap(find.text('Começar'));
    await tester.pumpAndSettle();
    expect(find.text('Como você vai usar?'), findsOneWidget);

    await tester.tap(find.text('Preciso de costura'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Buscar costureiras'));
    await tester.pumpAndSettle();
    expect(find.text('Seu cadastro'), findsOneWidget);
  });
}
