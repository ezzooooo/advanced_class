import 'package:flutter_test/flutter_test.dart';

import 'package:advanced_class/main.dart';

void main() {
  testWidgets('HomePage displays all week cards', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that all 7 weeks are displayed
    expect(find.text('테스팅 기초'), findsOneWidget);
    expect(find.text('앱 성능 최적화'), findsOneWidget);
    expect(find.text('CI/CD 파이프라인'), findsOneWidget);
    expect(find.text('앱 스토어 배포'), findsOneWidget);
    expect(find.text('Push Notification'), findsOneWidget);
    expect(find.text('앱 모니터링'), findsOneWidget);
    expect(find.text('앱 보안 & 고급 기법'), findsOneWidget);

    // Verify app title
    expect(find.text('Advanced Class'), findsOneWidget);
  });
}
