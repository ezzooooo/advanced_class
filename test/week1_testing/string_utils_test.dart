import 'package:flutter_test/flutter_test.dart';
import 'package:advanced_class/week1_testing/utils/string_utils.dart';

/// 1주차: 테스팅 기초 - 문자열 유틸리티 테스트
void main() {
  late StringUtils stringUtils;

  setUp(() {
    stringUtils = StringUtils();
  });

  group('isValidEmail', () {
    test('유효한 이메일은 true를 반환한다', () {
      expect(stringUtils.isValidEmail('test@example.com'), isTrue);
      expect(stringUtils.isValidEmail('user.name@domain.co.kr'), isTrue);
      expect(stringUtils.isValidEmail('user+tag@gmail.com'), isTrue);
    });

    test('유효하지 않은 이메일은 false를 반환한다', () {
      expect(stringUtils.isValidEmail(''), isFalse);
      expect(stringUtils.isValidEmail('invalid'), isFalse);
      expect(stringUtils.isValidEmail('missing@domain'), isFalse);
      expect(stringUtils.isValidEmail('@nodomain.com'), isFalse);
      expect(stringUtils.isValidEmail('spaces in@email.com'), isFalse);
    });
  });

  group('checkPasswordStrength', () {
    test('8자 미만은 weak를 반환한다', () {
      expect(
        stringUtils.checkPasswordStrength('Ab1!'),
        equals(PasswordStrength.weak),
      );
    });

    test('대문자, 소문자, 숫자, 특수문자 모두 포함하면 strong을 반환한다', () {
      expect(
        stringUtils.checkPasswordStrength('Password1!'),
        equals(PasswordStrength.strong),
      );
    });

    test('일부만 포함하면 medium을 반환한다', () {
      expect(
        stringUtils.checkPasswordStrength('password1'),
        equals(PasswordStrength.medium),
      );
      expect(
        stringUtils.checkPasswordStrength('Password'),
        equals(PasswordStrength.medium),
      );
    });
  });

  group('formatPhoneNumber', () {
    test('11자리 전화번호를 포맷팅한다', () {
      expect(
        stringUtils.formatPhoneNumber('01012345678'),
        equals('010-1234-5678'),
      );
    });

    test('이미 하이픈이 있는 번호도 처리한다', () {
      expect(
        stringUtils.formatPhoneNumber('010-1234-5678'),
        equals('010-1234-5678'),
      );
    });

    test('10자리 전화번호를 포맷팅한다', () {
      expect(
        stringUtils.formatPhoneNumber('0212345678'),
        equals('021-234-5678'),
      );
    });

    test('형식에 맞지 않으면 원본을 반환한다', () {
      expect(stringUtils.formatPhoneNumber('123'), equals('123'));
    });
  });

  group('reverse', () {
    test('문자열을 뒤집는다', () {
      expect(stringUtils.reverse('hello'), equals('olleh'));
      expect(stringUtils.reverse('Flutter'), equals('rettulF'));
    });

    test('빈 문자열은 빈 문자열을 반환한다', () {
      expect(stringUtils.reverse(''), equals(''));
    });
  });

  group('isPalindrome', () {
    test('회문이면 true를 반환한다', () {
      expect(stringUtils.isPalindrome('level'), isTrue);
      expect(stringUtils.isPalindrome('A man a plan a canal Panama'), isTrue);
      expect(stringUtils.isPalindrome('Was it a car or a cat I saw'), isTrue);
    });

    test('회문이 아니면 false를 반환한다', () {
      expect(stringUtils.isPalindrome('hello'), isFalse);
      expect(stringUtils.isPalindrome('Flutter'), isFalse);
    });
  });

  group('countWords', () {
    test('단어 수를 올바르게 센다', () {
      expect(stringUtils.countWords('Hello World'), equals(2));
      expect(stringUtils.countWords('One'), equals(1));
      expect(stringUtils.countWords('This is a test'), equals(4));
    });

    test('여러 공백도 올바르게 처리한다', () {
      expect(stringUtils.countWords('Hello   World'), equals(2));
    });

    test('빈 문자열은 0을 반환한다', () {
      expect(stringUtils.countWords(''), equals(0));
      expect(stringUtils.countWords('   '), equals(0));
    });
  });
}

