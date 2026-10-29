import 'package:flutter_test/flutter_test.dart';

import 'package:pragma_dynamic_icon/main.dart';

void main() {
  testWidgets('muestra el selector de iconos dinámicos', (tester) async {
    await tester.pumpWidget(const PragmaDynamicIconApp());
    await tester.pump();

    expect(find.text('Icono dinámico'), findsWidgets);
    expect(find.text('Predeterminado'), findsOneWidget);
    expect(find.text('Oscuro'), findsOneWidget);
    expect(find.text('Claro'), findsOneWidget);
  });
}
