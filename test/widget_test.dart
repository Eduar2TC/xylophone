import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:xylophone/providers/notes_provider.dart';
import 'package:xylophone/ui/screens/xylophone_app_screen.dart';

void main() {
  testWidgets('Xylophone tiles add/remove test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => NotesProvider(),
        child: const MaterialApp(
          home: XylophoneApp(),
        ),
      ),
    );

    // Verifica que hay al menos un tile al inicio
    expect(find.text('C'), findsWidgets);

    // Elimina todos los tiles
    for (int i = 0; i < 8; i++) {
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
    }

    // Verifica que aparece el mensaje de "No more tiles" (ajusta el texto según tu app)
    expect(find.textContaining('No more'), findsOneWidget);

    // Añade un tile
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verifica que aparece el tile 'C' de nuevo
    expect(find.text('C'), findsWidgets);
  });
}
