import 'package:flutter_test/flutter_test.dart';
import 'package:magazine_infos/main.dart';

void main() {
  testWidgets('Magazine Infos affiche AppBar', (WidgetTester tester) async {
    // Construire l'application
    await tester.pumpWidget(const MonAppli());

    // Vérifie si le texte "Magazine Infos" existe dans l'AppBar
    expect(find.text('Magazine Infos'), findsOneWidget);
  });
}
