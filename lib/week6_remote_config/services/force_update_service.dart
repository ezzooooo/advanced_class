import 'package:package_info_plus/package_info_plus.dart';
import 'remote_config_service.dart';

/// 강제 업데이트 서비스
///
/// Remote Config의 최소 버전과 현재 앱 버전을 비교하여
/// 강제 업데이트가 필요한지 판단합니다.
class ForceUpdateService {
  ForceUpdateService._();
  static final ForceUpdateService _instance = ForceUpdateService._();
  static ForceUpdateService get instance => _instance;

  final RemoteConfigService _remoteConfig = RemoteConfigService.instance;

  String? _currentVersion;

  /// 현재 앱 버전 초기화
  Future<void> initialize() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _currentVersion = packageInfo.version;
  }

  /// 현재 앱 버전
  String get currentVersion => _currentVersion ?? '0.0.0';

  /// Remote Config에서 가져온 최소 버전
  String get minimumVersion => _remoteConfig.minimumVersion;

  /// 강제 업데이트 필요 여부
  bool get needsForceUpdate {
    return _compareVersions(currentVersion, minimumVersion) < 0;
  }

  /// 버전 비교
  ///
  /// v1 < v2: -1
  /// v1 == v2: 0
  /// v1 > v2: 1
  int _compareVersions(String v1, String v2) {
    final parts1 = v1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final parts2 = v2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    // 버전 파트 수를 맞춤
    while (parts1.length < 3) parts1.add(0);
    while (parts2.length < 3) parts2.add(0);

    for (int i = 0; i < 3; i++) {
      if (parts1[i] < parts2[i]) return -1;
      if (parts1[i] > parts2[i]) return 1;
    }

    return 0;
  }

  /// 점검 모드 여부
  bool get isMaintenanceMode => _remoteConfig.isMaintenanceMode;

  /// 점검 메시지
  String get maintenanceMessage => _remoteConfig.maintenanceMessage;

  /// 업데이트 체크 결과
  UpdateCheckResult checkForUpdates() {
    // 1. 점검 모드 확인
    if (isMaintenanceMode) {
      return UpdateCheckResult(
        status: UpdateStatus.maintenance,
        message: maintenanceMessage,
      );
    }

    // 2. 강제 업데이트 확인
    if (needsForceUpdate) {
      return UpdateCheckResult(
        status: UpdateStatus.forceUpdate,
        message:
            '새로운 버전이 출시되었습니다.\n'
            '앱을 업데이트해주세요.\n\n'
            '현재 버전: $currentVersion\n'
            '최소 버전: $minimumVersion',
        currentVersion: currentVersion,
        minimumVersion: minimumVersion,
      );
    }

    // 3. 정상
    return UpdateCheckResult(
      status: UpdateStatus.ok,
      message: '최신 버전입니다.',
      currentVersion: currentVersion,
      minimumVersion: minimumVersion,
    );
  }
}

/// 업데이트 상태
enum UpdateStatus {
  /// 정상 (업데이트 불필요)
  ok,

  /// 강제 업데이트 필요
  forceUpdate,

  /// 서버 점검 중
  maintenance,
}

/// 업데이트 체크 결과
class UpdateCheckResult {
  final UpdateStatus status;
  final String message;
  final String? currentVersion;
  final String? minimumVersion;

  UpdateCheckResult({
    required this.status,
    required this.message,
    this.currentVersion,
    this.minimumVersion,
  });

  bool get isOk => status == UpdateStatus.ok;
  bool get needsForceUpdate => status == UpdateStatus.forceUpdate;
  bool get isMaintenance => status == UpdateStatus.maintenance;
}
