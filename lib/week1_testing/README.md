# 1주차: 테스팅 기초

## 학습 목표
- 테스트의 필요성 이해
- Unit Test, Widget Test 작성법 습득
- Mocktail을 활용한 의존성 Mocking

## 테스트 종류

| 종류 | 대상 | 속도 | 비용 |
|------|------|------|------|
| Unit Test | 순수 함수, 비즈니스 로직 | 빠름 | 낮음 |
| Widget Test | UI 컴포넌트 | 중간 | 중간 |
| Integration Test | 전체 앱 흐름 | 느림 | 높음 |

## 파일 설명

### utils/
Unit Test 대상 순수 함수들

- `calculator.dart`: 산술 연산, 피보나치 등
- `string_utils.dart`: 이메일 검증, 비밀번호 강도, 전화번호 포맷팅

### repositories/
외부 의존성을 추상화한 Repository

- `user_repository.dart`: 사용자 데이터 CRUD 인터페이스

### services/
비즈니스 로직을 담당하는 Service Layer

- `user_service.dart`: Repository를 주입받아 사용자 관련 로직 처리

### widgets/
Widget Test 대상 UI 컴포넌트

- `counter_widget.dart`: 카운터 위젯
- `login_form_widget.dart`: 로그인 폼 (입력 검증 포함)

## 테스트 실행

```bash
# 전체 테스트 실행
flutter test

# 1주차 테스트만 실행
flutter test test/week1_testing/

# 특정 파일만 실행
flutter test test/week1_testing/calculator_test.dart

# 커버리지 포함 실행
flutter test --coverage
```

## AAA 패턴

테스트 코드 작성 시 권장되는 패턴:

```dart
test('두 숫자를 더하면 합을 반환한다', () {
  // Arrange (준비)
  final calculator = Calculator();
  const a = 2;
  const b = 3;

  // Act (실행)
  final result = calculator.add(a, b);

  // Assert (검증)
  expect(result, equals(5));
});
```

## 주요 Matcher

```dart
// 동등 비교
expect(result, equals(5));
expect(result, isTrue);
expect(result, isFalse);
expect(result, isNull);
expect(result, isNotNull);

// 컬렉션
expect(list, isEmpty);
expect(list, isNotEmpty);
expect(list, contains('item'));
expect(list, hasLength(3));

// 예외
expect(() => divide(10, 0), throwsA(isA<ArgumentError>()));
expect(() => riskyFunction(), throwsException);

// 범위
expect(value, greaterThan(5));
expect(value, lessThanOrEqualTo(10));
expect(value, inInclusiveRange(1, 10));
```

## Mocking with Mocktail

### Mock 클래스 정의

```dart
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}
```

### Mock 동작 정의

```dart
// 반환값 설정
when(() => mockRepo.getUser('1'))
    .thenAnswer((_) async => testUser);

// 예외 발생
when(() => mockRepo.getUser('invalid'))
    .thenThrow(Exception('Not found'));

// 여러 번 호출 시 다른 값 반환
when(() => mockRepo.getCount())
    .thenReturn(1)
    .thenReturn(2);
```

### 호출 검증

```dart
// 호출 확인
verify(() => mockRepo.getUser('1')).called(1);

// 호출되지 않음 확인
verifyNever(() => mockRepo.deleteUser(any()));

// 순서 검증
verifyInOrder([
  () => mockRepo.getUser('1'),
  () => mockRepo.updateUser(any()),
]);
```

## Widget Test 주요 함수

```dart
testWidgets('버튼 클릭 테스트', (tester) async {
  // 위젯 렌더링
  await tester.pumpWidget(const MyApp());

  // 요소 찾기
  expect(find.text('Hello'), findsOneWidget);
  expect(find.byType(ElevatedButton), findsNWidgets(2));
  expect(find.byKey(const Key('my_button')), findsOneWidget);

  // 인터랙션
  await tester.tap(find.byType(ElevatedButton));
  await tester.enterText(find.byType(TextField), 'input');

  // 상태 업데이트 반영
  await tester.pump();           // 한 프레임
  await tester.pumpAndSettle();  // 애니메이션 완료까지
});
```

## 과제

본인 프로젝트의 유틸 함수 2개 이상에 대해 Unit Test 작성

### 체크리스트
- [ ] 정상 케이스 테스트
- [ ] 엣지 케이스 테스트 (빈 값, null, 경계값)
- [ ] 예외 케이스 테스트
- [ ] group()으로 관련 테스트 그룹화

