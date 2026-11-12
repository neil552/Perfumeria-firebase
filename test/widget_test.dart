// Prueba de humo de la aplicación "Regalos & Esencias".
//
// Verifica que el árbol de widgets se construya sin excepciones y que la
// pantalla de bienvenida (ruta inicial) se muestre correctamente.

import 'package:flutter_test/flutter_test.dart';

import 'package:perfumeria/main.dart';

void main() {
  testWidgets('La pantalla de bienvenida se renderiza', (tester) async {
    await tester.pumpWidget(const RegalosEsenciasApp());
    await tester.pump();

    // El lema principal de la pantalla de bienvenida debe estar presente.
    expect(find.text('Detalles que hablan por ti'), findsOneWidget);
  });
}
