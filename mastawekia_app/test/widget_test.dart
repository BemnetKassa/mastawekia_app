// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mastawekia_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MastawekiaApp());
    expect(find.byType(MastawekiaApp), findsOneWidget);
  });
}
