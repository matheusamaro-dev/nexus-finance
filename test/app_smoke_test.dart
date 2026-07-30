import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_finance/app/nexus_finance_app.dart';

void main() {
  testWidgets('exibe a identidade do Nexus Finance', (tester) async {
    await tester.pumpWidget(const NexusFinanceApp());

    expect(find.text('NEXUS FINANCE'), findsOneWidget);
    expect(find.text('Olá, Matheus'), findsOneWidget);
    expect(find.text('Saldo projetado'), findsOneWidget);
  });
}
