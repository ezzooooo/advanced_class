import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:advanced_class/week1_testing/widgets/login_form_widget.dart';

/// 1주차: 테스팅 기초 - 폼 Widget Test 예제
void main() {
  group('LoginFormWidget', () {
    Widget createTestWidget({
      void Function(String email, String password)? onLogin,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: LoginFormWidget(onLogin: onLogin)),
        ),
      );
    }

    testWidgets('폼이 올바르게 렌더링된다', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // '로그인' 텍스트가 타이틀과 버튼에 각각 있으므로 2개 찾음
      expect(find.text('로그인'), findsNWidgets(2));
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);
    });

    testWidgets('이메일을 입력하지 않으면 에러 메시지가 표시된다', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // 로그인 버튼 탭
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      expect(find.text('이메일을 입력해주세요'), findsOneWidget);
    });

    testWidgets('유효하지 않은 이메일 형식이면 에러 메시지가 표시된다', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // 잘못된 이메일 입력
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'invalid-email',
      );
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      expect(find.text('유효한 이메일 형식이 아닙니다'), findsOneWidget);
    });

    testWidgets('비밀번호를 입력하지 않으면 에러 메시지가 표시된다', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // 이메일만 입력
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      expect(find.text('비밀번호를 입력해주세요'), findsOneWidget);
    });

    testWidgets('비밀번호가 8자 미만이면 에러 메시지가 표시된다', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(find.byKey(const Key('password_field')), 'short');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      expect(find.text('비밀번호는 8자 이상이어야 합니다'), findsOneWidget);
    });

    testWidgets('유효한 입력으로 로그인하면 콜백이 호출된다', (tester) async {
      String? loginEmail;
      String? loginPassword;

      await tester.pumpWidget(
        createTestWidget(
          onLogin: (email, password) {
            loginEmail = email;
            loginPassword = password;
          },
        ),
      );

      // 유효한 입력
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );
      await tester.tap(find.byKey(const Key('login_button')));

      // 로딩 상태 확인
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // 로딩 완료 대기
      await tester.pumpAndSettle();

      expect(loginEmail, equals('test@example.com'));
      expect(loginPassword, equals('password123'));
    });

    testWidgets('로딩 중에는 버튼이 비활성화된다', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // 로딩 중 버튼 상태 확인
      final button = tester.widget<ElevatedButton>(
        find.byKey(const Key('login_button')),
      );
      expect(button.onPressed, isNull); // 비활성화됨

      // 타이머 완료 대기
      await tester.pumpAndSettle();
    });
  });
}
