import 'package:flutter_test/flutter_test.dart';
import 'package:advanced_class/week1_testing/utils/calculator.dart';

/// 1주차: 테스팅 기초 - Unit Test 예제
///
/// Calculator 클래스의 단위 테스트입니다.
/// AAA 패턴 (Arrange-Act-Assert)을 따릅니다.
void main() {
  // group()으로 관련 테스트를 묶습니다
  group('Calculator', () {
    late Calculator calculator;

    // 각 테스트 전에 실행되는 setUp
    setUp(() {
      calculator = Calculator();
    });

    // ===================
    // 기본 산술 연산 테스트
    // ===================
    group('기본 연산', () {
      test('add: 두 양수를 더하면 합을 반환한다', () {
        // Arrange (준비)
        const a = 5;
        const b = 10;

        // Act (실행)
        final result = calculator.add(a, b);

        // Assert (검증)
        expect(result, equals(16));
      });

      test('add: 음수와 양수를 더하면 올바른 결과를 반환한다', () {
        expect(calculator.add(-5, 3), equals(-2));
      });

      test('subtract: 두 숫자를 빼면 차를 반환한다', () {
        expect(calculator.subtract(10, 4), equals(6));
      });

      test('multiply: 두 숫자를 곱하면 곱을 반환한다', () {
        expect(calculator.multiply(3, 4), equals(12));
      });

      test('multiply: 0을 곱하면 0을 반환한다', () {
        expect(calculator.multiply(100, 0), equals(0));
      });

      test('divide: 두 숫자를 나누면 몫을 반환한다', () {
        expect(calculator.divide(10, 2), equals(5.0));
      });

      test('divide: 0으로 나누면 ArgumentError를 던진다', () {
        // throwsA()와 isA<>()를 사용하여 예외 테스트
        expect(() => calculator.divide(10, 0), throwsA(isA<ArgumentError>()));
      });
    });

    // ===================
    // 유틸리티 함수 테스트
    // ===================
    group('유틸리티 함수', () {
      test('isEven: 짝수면 true를 반환한다', () {
        expect(calculator.isEven(4), isTrue);
        expect(calculator.isEven(0), isTrue);
        expect(calculator.isEven(-2), isTrue);
      });

      test('isEven: 홀수면 false를 반환한다', () {
        expect(calculator.isEven(3), isFalse);
        expect(calculator.isEven(1), isFalse);
        expect(calculator.isEven(-1), isFalse);
      });

      test('isPrime: 소수면 true를 반환한다', () {
        expect(calculator.isPrime(2), isTrue);
        expect(calculator.isPrime(3), isTrue);
        expect(calculator.isPrime(5), isTrue);
        expect(calculator.isPrime(7), isTrue);
        expect(calculator.isPrime(11), isTrue);
      });

      test('isPrime: 소수가 아니면 false를 반환한다', () {
        expect(calculator.isPrime(0), isFalse);
        expect(calculator.isPrime(1), isFalse);
        expect(calculator.isPrime(4), isFalse);
        expect(calculator.isPrime(9), isFalse);
      });
    });

    // ===================
    // 피보나치 테스트
    // ===================
    group('fibonacci', () {
      test('n이 0이면 0을 반환한다', () {
        expect(calculator.fibonacci(0), equals(0));
      });

      test('n이 1이면 1을 반환한다', () {
        expect(calculator.fibonacci(1), equals(1));
      });

      test('피보나치 수열을 올바르게 계산한다', () {
        // 0, 1, 1, 2, 3, 5, 8, 13, 21, 34
        expect(calculator.fibonacci(5), equals(5));
        expect(calculator.fibonacci(10), equals(55));
      });

      test('음수 입력에 대해 0을 반환한다', () {
        expect(calculator.fibonacci(-1), equals(0));
      });
    });
  });
}
