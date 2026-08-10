// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';

void main() {
  testWidgets('Controllo elementi Home Page Orto', (WidgetTester tester) async {
    // Carica la nostra OrtoApp nel simulatore di test
    await tester.pumpWidget(const OrtoApp());

    // Verifica che nella schermata ci sia il titolo corretto
    expect(find.text('Il Mio Orto & Frutteto'), findsOneWidget);

    // Verifica che esistano i pulsanti principali per l'Orto e il Frutteto
    expect(find.text('Orto'), findsOneWidget);
    expect(find.text('Frutteto'), findsOneWidget);

    // Verifica che ci sia il widget del meteo con la temperatura simulata
    expect(find.text('24°C'), findsOneWidget);
  });
}
