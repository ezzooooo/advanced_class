/// 1주차: 테스팅 기초 - Unit Test 대상 클래스
///
/// 비즈니스 로직을 담은 계산기 클래스입니다.
/// 순수 함수로 구성되어 테스트하기 쉽습니다.
class Calculator {
  /// 두 숫자를 더합니다.
  int add(int a, int b) => a + b;

  /// 두 숫자를 뺍니다.
  int subtract(int a, int b) => a - b;

  /// 두 숫자를 곱합니다.
  int multiply(int a, int b) => a * b;

  /// 두 숫자를 나눕니다.
  /// [b]가 0이면 [ArgumentError]를 던집니다.
  double divide(int a, int b) {
    if (b == 0) {
      throw ArgumentError('0으로 나눌 수 없습니다.');
    }
    return a / b;
  }

  /// 숫자가 짝수인지 확인합니다.
  bool isEven(int number) => number % 2 == 0;

  /// 숫자가 소수인지 확인합니다.
  bool isPrime(int number) {
    if (number < 2) return false;
    for (int i = 2; i * i <= number; i++) {
      if (number % i == 0) return false;
    }
    return true;
  }

  /// 피보나치 수열의 n번째 값을 반환합니다.
  int fibonacci(int n) {
    if (n <= 0) return 0;
    if (n == 1) return 1;

    int prev = 0;
    int curr = 1;
    for (int i = 2; i <= n; i++) {
      final temp = curr;
      curr = prev + curr;
      prev = temp;
    }
    return curr;
  }
}
