import '../repositories/user_repository.dart';
import '../utils/string_utils.dart';

/// 1주차: 테스팅 기초 - Service Layer
///
/// Repository를 의존성 주입받아 비즈니스 로직을 처리합니다.
/// 테스트 시 Repository를 Mock으로 대체하여 단위 테스트를 수행합니다.
class UserService {
  final UserRepository _userRepository;
  final StringUtils _stringUtils;

  UserService({
    required UserRepository userRepository,
    StringUtils? stringUtils,
  }) : _userRepository = userRepository,
       _stringUtils = stringUtils ?? StringUtils();

  /// 사용자를 조회합니다.
  Future<User> getUser(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('사용자 ID가 비어있습니다.');
    }
    return _userRepository.getUser(id);
  }

  /// 새 사용자를 생성합니다.
  /// 이메일 유효성 검사를 수행합니다.
  Future<User> createUser(String name, String email) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('이름이 비어있습니다.');
    }

    if (!_stringUtils.isValidEmail(email)) {
      throw ArgumentError('유효하지 않은 이메일 형식입니다.');
    }

    return _userRepository.createUser(name.trim(), email.toLowerCase());
  }

  /// 사용자 이름을 변경합니다.
  Future<User> updateUserName(String id, String newName) async {
    if (newName.trim().isEmpty) {
      throw ArgumentError('새 이름이 비어있습니다.');
    }

    final user = await _userRepository.getUser(id);
    final updatedUser = user.copyWith(name: newName.trim());
    return _userRepository.updateUser(updatedUser);
  }

  /// 모든 사용자 목록을 가져옵니다.
  Future<List<User>> getAllUsers() async {
    return _userRepository.getAllUsers();
  }

  /// 사용자를 삭제합니다.
  Future<void> deleteUser(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('사용자 ID가 비어있습니다.');
    }
    await _userRepository.deleteUser(id);
  }

  /// 이메일로 사용자를 검색합니다.
  Future<User?> findUserByEmail(String email) async {
    if (!_stringUtils.isValidEmail(email)) {
      return null;
    }

    final users = await _userRepository.getAllUsers();
    try {
      return users.firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
