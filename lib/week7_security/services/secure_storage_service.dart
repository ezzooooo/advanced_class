import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 7주차: 앱 보안 - Secure Storage 서비스
///
/// flutter_secure_storage를 활용한 민감 정보 안전 저장
///
/// 저장 방식:
/// - Android: EncryptedSharedPreferences (AES 암호화)
/// - iOS: Keychain

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  // Android 옵션 (AES 암호화)
  static const _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  // iOS 옵션 (앱 삭제 시 데이터 유지 여부)
  static const _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: _androidOptions,
    iOptions: _iosOptions,
  );

  // ===============================
  // 저장소 키 상수
  // ===============================

  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyApiKey = 'api_key';

  // ===============================
  // 토큰 관리
  // ===============================

  /// 액세스 토큰 저장
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _keyAccessToken, value: token);
    debugPrint('🔐 Access token saved');
  }

  /// 액세스 토큰 조회
  Future<String?> getAccessToken() async {
    return _storage.read(key: _keyAccessToken);
  }

  /// 리프레시 토큰 저장
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _keyRefreshToken, value: token);
    debugPrint('🔐 Refresh token saved');
  }

  /// 리프레시 토큰 조회
  Future<String?> getRefreshToken() async {
    return _storage.read(key: _keyRefreshToken);
  }

  /// 모든 토큰 저장 (로그인 시)
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
  }

  /// 모든 토큰 삭제 (로그아웃 시)
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _keyAccessToken),
      _storage.delete(key: _keyRefreshToken),
    ]);
    debugPrint('🔐 Tokens cleared');
  }

  // ===============================
  // 사용자 정보
  // ===============================

  /// 사용자 ID 저장
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _keyUserId, value: userId);
  }

  /// 사용자 ID 조회
  Future<String?> getUserId() async {
    return _storage.read(key: _keyUserId);
  }

  // ===============================
  // API 키
  // ===============================

  /// API 키 저장
  Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: _keyApiKey, value: apiKey);
  }

  /// API 키 조회
  Future<String?> getApiKey() async {
    return _storage.read(key: _keyApiKey);
  }

  // ===============================
  // 범용 메서드
  // ===============================

  /// 커스텀 키로 값 저장
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// 커스텀 키로 값 조회
  Future<String?> read(String key) async {
    return _storage.read(key: key);
  }

  /// 특정 키 삭제
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// 모든 데이터 삭제
  Future<void> deleteAll() async {
    await _storage.deleteAll();
    debugPrint('🔐 All secure storage data cleared');
  }

  /// 모든 키 조회
  Future<Map<String, String>> readAll() async {
    return _storage.readAll();
  }

  /// 키 존재 여부 확인
  Future<bool> containsKey(String key) async {
    return _storage.containsKey(key: key);
  }
}
