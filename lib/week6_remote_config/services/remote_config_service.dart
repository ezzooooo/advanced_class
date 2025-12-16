import 'package:firebase_remote_config/firebase_remote_config.dart';

/// Firebase Remote Config를 관리하는 서비스
///
/// 앱 업데이트 없이 서버에서 설정값을 동적으로 변경할 수 있습니다.
class RemoteConfigService {
  RemoteConfigService._();
  static final RemoteConfigService _instance = RemoteConfigService._();
  static RemoteConfigService get instance => _instance;

  late final FirebaseRemoteConfig _remoteConfig;

  /// Remote Config 키 상수
  static const String keyMinimumVersion = 'minimum_app_version';
  static const String keyMaintenanceMode = 'maintenance_mode';
  static const String keyMaintenanceMessage = 'maintenance_message';
  static const String keyNewFeatureEnabled = 'new_feature_enabled';
  static const String keyWelcomeMessage = 'welcome_message';
  static const String keyMaxUploadSize = 'max_upload_size_mb';
  static const String keyApiBaseUrl = 'api_base_url';

  /// Remote Config 초기화
  Future<void> initialize() async {
    _remoteConfig = FirebaseRemoteConfig.instance;

    // 설정: fetch 간격, 타임아웃 등
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        // 개발 중에는 짧게, 프로덕션에서는 12시간 이상 권장
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    // 기본값 설정 (네트워크 오류 시 사용)
    await _setDefaults();

    // 초기 fetch 및 활성화
    await fetchAndActivate();
  }

  /// 로컬 기본값 설정
  Future<void> _setDefaults() async {
    await _remoteConfig.setDefaults({
      keyMinimumVersion: '1.0.0',
      keyMaintenanceMode: false,
      keyMaintenanceMessage: '서버 점검 중입니다. 잠시 후 다시 시도해주세요.',
      keyNewFeatureEnabled: false,
      keyWelcomeMessage: '앱에 오신 것을 환영합니다!',
      keyMaxUploadSize: 10,
      keyApiBaseUrl: 'https://api.example.com',
    });
  }

  /// 원격 설정값 가져오기 및 활성화
  Future<bool> fetchAndActivate() async {
    try {
      // 원격에서 설정값 가져오기
      final bool updated = await _remoteConfig.fetchAndActivate();
      return updated;
    } catch (e) {
      print('Remote Config fetch 실패: $e');
      return false;
    }
  }

  // ============================================
  // Getter 메서드들
  // ============================================

  /// 최소 앱 버전 (강제 업데이트 판단용)
  String get minimumVersion => _remoteConfig.getString(keyMinimumVersion);

  /// 점검 모드 여부
  bool get isMaintenanceMode => _remoteConfig.getBool(keyMaintenanceMode);

  /// 점검 메시지
  String get maintenanceMessage =>
      _remoteConfig.getString(keyMaintenanceMessage);

  /// 새 기능 활성화 여부
  bool get isNewFeatureEnabled => _remoteConfig.getBool(keyNewFeatureEnabled);

  /// 환영 메시지
  String get welcomeMessage => _remoteConfig.getString(keyWelcomeMessage);

  /// 최대 업로드 크기 (MB)
  int get maxUploadSizeMB => _remoteConfig.getInt(keyMaxUploadSize);

  /// API Base URL
  String get apiBaseUrl => _remoteConfig.getString(keyApiBaseUrl);

  // ============================================
  // 유틸리티 메서드들
  // ============================================

  /// 특정 키의 값 가져오기 (동적 접근)
  String getString(String key) => _remoteConfig.getString(key);
  bool getBool(String key) => _remoteConfig.getBool(key);
  int getInt(String key) => _remoteConfig.getInt(key);
  double getDouble(String key) => _remoteConfig.getDouble(key);

  /// 마지막 fetch 시간
  DateTime get lastFetchTime => _remoteConfig.lastFetchTime;

  /// 마지막 fetch 상태
  RemoteConfigFetchStatus get lastFetchStatus => _remoteConfig.lastFetchStatus;

  /// 모든 설정값 출력 (디버깅용)
  void printAllValues() {
    print('=== Remote Config Values ===');
    print('minimumVersion: $minimumVersion');
    print('isMaintenanceMode: $isMaintenanceMode');
    print('maintenanceMessage: $maintenanceMessage');
    print('isNewFeatureEnabled: $isNewFeatureEnabled');
    print('welcomeMessage: $welcomeMessage');
    print('maxUploadSizeMB: $maxUploadSizeMB');
    print('apiBaseUrl: $apiBaseUrl');
    print('lastFetchTime: $lastFetchTime');
    print('lastFetchStatus: $lastFetchStatus');
    print('============================');
  }
}
