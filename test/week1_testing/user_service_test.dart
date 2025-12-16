import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:advanced_class/week1_testing/repositories/user_repository.dart';
import 'package:advanced_class/week1_testing/services/user_service.dart';

/// 1주차: 테스팅 기초 - Mocking 테스트 예제
///
/// Mocktail을 사용하여 UserRepository를 Mock하고
/// UserService의 비즈니스 로직을 테스트합니다.

// Mock 클래스 정의
// Mock -> UserRepository에 있는 함수들을 실제로 사용하는 것 처럼 테스트 할 때 필요
class MockUserRepository extends Mock implements UserRepository {}

// Fallback 클래스 정의
class FakeUser extends Fake implements User {} // Fake -> User라는 타입만 테스트 할 때 필요

void main() {
  late MockUserRepository mockRepository;
  late UserService userService;

  // 테스트용 더미 데이터
  final testUser = User(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    createdAt: DateTime(2024, 1, 1),
  );

  setUpAll(() {
    // 전체 테스트가 시작되기 전에 딱 1번 실행되서 세팅 모든 테스트에 다 적용되는 세팅
    // Mocktail에 User 타입 등록
    registerFallbackValue(FakeUser());
  });

  setUp(() {
    mockRepository = MockUserRepository();
    userService = UserService(userRepository: mockRepository);
  });

  group('UserService', () {
    group('getUser', () {
      test('유효한 ID로 사용자를 조회할 수 있다', () async {
        // Arrange: Mock의 동작을 정의
        when(
          () => mockRepository.getUser('1'),
        ).thenAnswer((_) async => testUser);

        // Act
        final result = await userService.getUser('1');

        // Assert
        expect(result, equals(testUser));
        verify(() => mockRepository.getUser('1')).called(1);
      });

      test('빈 ID로 조회하면 ArgumentError를 던진다', () async {
        // Act & Assert
        expect(() => userService.getUser(''), throwsA(isA<ArgumentError>()));

        // Repository가 호출되지 않았는지 확인
        verifyNever(() => mockRepository.getUser(any()));
      });
    });

    group('createUser', () {
      test('유효한 정보로 사용자를 생성할 수 있다', () async {
        // Arrange
        when(
          () => mockRepository.createUser(any(), any()),
        ).thenAnswer((_) async => testUser);

        // Act
        final result = await userService.createUser(
          'New User',
          'new111@example.com',
        );

        // Assert
        expect(result, equals(testUser));
        verify(
          () => mockRepository.createUser('New User', 'new111@example.com'),
        ).called(1);
      });

      test('빈 이름으로 생성하면 ArgumentError를 던진다', () async {
        expect(
          () => userService.createUser('', 'test@example.com'),
          throwsA(isA<ArgumentError>()),
        );

        verifyNever(() => mockRepository.createUser(any(), any()));
      });

      test('유효하지 않은 이메일로 생성하면 ArgumentError를 던진다', () async {
        expect(
          () => userService.createUser('User', 'invalid-email'),
          throwsA(isA<ArgumentError>()),
        );

        verifyNever(() => mockRepository.createUser(any(), any()));
      });

      test('이메일을 소문자로 변환하여 저장한다', () async {
        when(
          () => mockRepository.createUser(any(), any()),
        ).thenAnswer((_) async => testUser);

        await userService.createUser('User', 'TEST@EXAMPLE.COM');

        verify(
          () => mockRepository.createUser('User', 'test@example.com'),
        ).called(1);
      });
    });

    group('updateUserName', () {
      test('사용자 이름을 변경할 수 있다', () async {
        // Arrange
        final updatedUser = testUser.copyWith(name: 'Updated Name');

        when(
          () => mockRepository.getUser('1'),
        ).thenAnswer((_) async => testUser);
        when(
          () => mockRepository.updateUser(any()),
        ).thenAnswer((_) async => updatedUser);

        // Act
        final result = await userService.updateUserName('1', 'Updated Name');

        // Assert
        expect(result.name, equals('Updated Name'));
        verify(() => mockRepository.getUser('1')).called(1);
        verify(() => mockRepository.updateUser(any())).called(1);
      });

      test('빈 이름으로 변경하면 ArgumentError를 던진다', () async {
        expect(
          () => userService.updateUserName('1', ''),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('getAllUsers', () {
      test('모든 사용자 목록을 가져온다', () async {
        final users = [testUser, testUser.copyWith(id: '2', name: 'User 2')];

        when(() => mockRepository.getAllUsers()).thenAnswer((_) async => users);

        final result = await userService.getAllUsers();

        expect(result.length, equals(2));
        verify(() => mockRepository.getAllUsers()).called(1);
      });
    });

    group('deleteUser', () {
      test('사용자를 삭제할 수 있다', () async {
        when(() => mockRepository.deleteUser('1')).thenAnswer((_) async => {});

        await userService.deleteUser('1');

        verify(() => mockRepository.deleteUser('1')).called(1);
      });

      test('빈 ID로 삭제하면 ArgumentError를 던진다', () async {
        expect(() => userService.deleteUser(''), throwsA(isA<ArgumentError>()));
      });
    });

    group('findUserByEmail', () {
      test('이메일로 사용자를 찾을 수 있다', () async {
        final users = [testUser];

        when(() => mockRepository.getAllUsers()).thenAnswer((_) async => users);

        final result = await userService.findUserByEmail('test@example.com');

        expect(result, equals(testUser));
      });

      test('유효하지 않은 이메일은 null을 반환한다', () async {
        final result = await userService.findUserByEmail('invalid');

        expect(result, isNull);
        verifyNever(() => mockRepository.getAllUsers());
      });

      test('사용자를 찾지 못하면 null을 반환한다', () async {
        when(() => mockRepository.getAllUsers()).thenAnswer((_) async => []);

        final result = await userService.findUserByEmail(
          'notfound@example.com',
        );

        expect(result, isNull);
      });
    });
  });
}
