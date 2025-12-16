import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:advanced_class/week1_testing/widgets/counter_widget.dart';

/// 1주차: 테스팅 기초 - Widget Test 예제
///
/// WidgetTester를 사용하여 UI 컴포넌트를 테스트합니다.
void main() {
  group('CounterWidget', () {
    // Helper: 테스트용 앱 래핑
    Widget createTestWidget({
      int initialValue = 0,
      ValueChanged<int>? onValueChanged,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: CounterWidget(
            initialValue: initialValue,
            onValueChanged: onValueChanged,
          ),
        ),
      );
    }

    testWidgets('초기값이 올바르게 표시된다', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(initialValue: 5));

      // Assert
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('증가 버튼을 누르면 카운터가 증가한다', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // 초기값 확인
      expect(find.text('0'), findsOneWidget);

      // 증가 버튼 탭
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pump(); // 상태 변경 후 리빌드

      // 결과 확인
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('감소 버튼을 누르면 카운터가 감소한다', (tester) async {
      await tester.pumpWidget(createTestWidget(initialValue: 5));

      await tester.tap(find.byKey(const Key('decrement_button')));
      await tester.pump();

      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('리셋 버튼을 누르면 카운터가 0이 된다', (tester) async {
      await tester.pumpWidget(createTestWidget(initialValue: 10));

      expect(find.text('10'), findsOneWidget);

      await tester.tap(find.byKey(const Key('reset_button')));
      await tester.pump();

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('값이 변경되면 콜백이 호출된다', (tester) async {
      int? callbackValue;

      await tester.pumpWidget(
        createTestWidget(onValueChanged: (value) => callbackValue = value),
      );

      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pump();

      expect(callbackValue, equals(1));
    });

    testWidgets('여러 번 탭해도 올바르게 동작한다', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // 3번 증가
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byKey(const Key('increment_button')));
        await tester.pump();
      }

      expect(find.text('3'), findsOneWidget);

      // 1번 감소
      await tester.tap(find.byKey(const Key('decrement_button')));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('음수 값도 표시할 수 있다', (tester) async {
      await tester.pumpWidget(createTestWidget(initialValue: 0));

      await tester.tap(find.byKey(const Key('decrement_button')));
      await tester.pump();

      expect(find.text('-1'), findsOneWidget);
    });

    testWidgets('UI 요소들이 올바르게 렌더링된다', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // 필수 UI 요소 확인
      expect(find.text('카운터'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.text('리셋'), findsNWidgets(1));
    });
  });
}
