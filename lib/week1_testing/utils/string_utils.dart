/// 1주차: 테스팅 기초 - 문자열 유틸리티 함수
///
/// 다양한 문자열 처리 함수들입니다.
class StringUtils {
  /// 이메일 형식이 유효한지 확인합니다.
  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// 비밀번호 강도를 확인합니다.
  /// - 8자 이상
  /// - 대문자 포함
  /// - 소문자 포함
  /// - 숫자 포함
  PasswordStrength checkPasswordStrength(String password) {
    if (password.length < 8) return PasswordStrength.weak;

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    int score = 0;
    if (hasUppercase) score++;
    if (hasLowercase) score++;
    if (hasDigit) score++;
    if (hasSpecialChar) score++;

    if (score >= 4) return PasswordStrength.strong;
    if (score >= 2) return PasswordStrength.medium;
    return PasswordStrength.weak;
  }

  /// 전화번호 형식을 표준화합니다.
  /// 예: "01012345678" -> "010-1234-5678"
  String formatPhoneNumber(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length == 11 && digits.startsWith('010')) {
      return '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7)}';
    }

    if (digits.length == 10) {
      return '${digits.substring(0, 3)}-${digits.substring(3, 6)}-${digits.substring(6)}';
    }

    return phone; // 형식에 맞지 않으면 원본 반환
  }

  /// 문자열을 뒤집습니다.
  String reverse(String input) {
    return input.split('').reversed.join('');
  }

  /// 팰린드롬(회문)인지 확인합니다.
  bool isPalindrome(String input) {
    final cleaned = input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return cleaned == reverse(cleaned);
  }

  /// 단어 수를 셉니다.
  int countWords(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }
}

enum PasswordStrength { weak, medium, strong }
