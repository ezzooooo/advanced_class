/// 1주차: 테스팅 기초 - Mocking 대상 인터페이스
///
/// 외부 의존성(API, DB)을 추상화한 Repository입니다.
/// 테스트 시 Mock으로 대체할 수 있습니다.

class User {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// UserRepository의 추상 인터페이스
/// 실제 구현과 Mock 구현 모두 이 인터페이스를 따릅니다.
abstract class UserRepository {
  /// 사용자 정보를 가져옵니다.
  Future<User> getUser(String id);

  /// 모든 사용자 목록을 가져옵니다.
  Future<List<User>> getAllUsers();

  /// 새 사용자를 생성합니다.
  Future<User> createUser(String name, String email);

  /// 사용자 정보를 업데이트합니다.
  Future<User> updateUser(User user);

  /// 사용자를 삭제합니다.
  Future<void> deleteUser(String id);
}

/// 실제 API를 호출하는 Repository 구현체
class ApiUserRepository implements UserRepository {
  // 실제로는 http 패키지 등을 사용하여 API 호출
  // 여기서는 예시로 간단히 구현

  @override
  Future<User> getUser(String id) async {
    // 실제 API 호출 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 500));

    return User(
      id: id,
      name: 'User $id',
      email: 'user$id@example.com',
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<List<User>> getAllUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return List.generate(
      5,
      (index) => User(
        id: '$index',
        name: 'User $index',
        email: 'user$index@example.com',
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<User> createUser(String name, String email) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<User> updateUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return user;
  }

  @override
  Future<void> deleteUser(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

