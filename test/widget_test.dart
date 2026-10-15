import 'package:flutter_test/flutter_test.dart';
import 'package:resqgo/main.dart';

void main() {
  testWidgets('ResQGo app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ResQGoApp());
    await tester.pump(const Duration(seconds: 3));
    expect(find.byType(ResQGoApp), findsOneWidget);
  });
}
