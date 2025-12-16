import 'remote_config_service.dart';

/// Feature Flag 관리 서비스
///
/// Remote Config를 기반으로 기능 플래그를 관리합니다.
/// 점진적 릴리즈, A/B 테스팅, 긴급 기능 비활성화 등에 활용됩니다.
class FeatureFlagService {
  FeatureFlagService._();
  static final FeatureFlagService _instance = FeatureFlagService._();
  static FeatureFlagService get instance => _instance;

  final RemoteConfigService _remoteConfig = RemoteConfigService.instance;

  // ============================================
  // Feature Flag 키 정의
  // ============================================

  /// 새로운 홈 화면 UI 사용 여부
  static const String flagNewHomeUI = 'flag_new_home_ui';

  /// 다크 모드 지원 여부
  static const String flagDarkModeEnabled = 'flag_dark_mode_enabled';

  /// 베타 기능 표시 여부
  static const String flagShowBetaFeatures = 'flag_show_beta_features';

  /// 새로운 결제 시스템 사용 여부
  static const String flagNewPaymentSystem = 'flag_new_payment_system';

  /// 리뷰 요청 팝업 표시 여부
  static const String flagShowReviewPrompt = 'flag_show_review_prompt';

  /// 광고 표시 여부
  static const String flagAdsEnabled = 'flag_ads_enabled';

  // ============================================
  // Feature Flag Getter
  // ============================================

  /// 새로운 홈 화면 UI 활성화 여부
  bool get isNewHomeUIEnabled => _remoteConfig.getBool(flagNewHomeUI);

  /// 다크 모드 지원 여부
  bool get isDarkModeEnabled => _remoteConfig.getBool(flagDarkModeEnabled);

  /// 베타 기능 표시 여부
  bool get showBetaFeatures => _remoteConfig.getBool(flagShowBetaFeatures);

  /// 새로운 결제 시스템 사용 여부
  bool get useNewPaymentSystem => _remoteConfig.getBool(flagNewPaymentSystem);

  /// 리뷰 요청 팝업 표시 여부
  bool get showReviewPrompt => _remoteConfig.getBool(flagShowReviewPrompt);

  /// 광고 표시 여부
  bool get isAdsEnabled => _remoteConfig.getBool(flagAdsEnabled);

  // ============================================
  // 동적 Feature Flag 접근
  // ============================================

  /// 특정 기능이 활성화되어 있는지 확인
  bool isFeatureEnabled(String flagKey) {
    return _remoteConfig.getBool(flagKey);
  }

  /// 조건부 기능 실행
  ///
  /// ```dart
  /// featureFlagService.executeIfEnabled(
  ///   FeatureFlagService.flagNewPaymentSystem,
  ///   onEnabled: () => navigateToNewPayment(),
  ///   onDisabled: () => navigateToOldPayment(),
  /// );
  /// ```
  void executeIfEnabled(
    String flagKey, {
    required void Function() onEnabled,
    void Function()? onDisabled,
  }) {
    if (isFeatureEnabled(flagKey)) {
      onEnabled();
    } else {
      onDisabled?.call();
    }
  }

  /// 조건부 위젯 반환
  ///
  /// ```dart
  /// featureFlagService.widgetIfEnabled(
  ///   FeatureFlagService.flagNewHomeUI,
  ///   enabled: NewHomeWidget(),
  ///   disabled: OldHomeWidget(),
  /// );
  /// ```
  T widgetIfEnabled<T>(
    String flagKey, {
    required T enabled,
    required T disabled,
  }) {
    return isFeatureEnabled(flagKey) ? enabled : disabled;
  }

  // ============================================
  // 디버깅 및 유틸리티
  // ============================================

  /// 모든 Feature Flag 상태 출력
  void printAllFlags() {
    print('=== Feature Flags ===');
    print('$flagNewHomeUI: $isNewHomeUIEnabled');
    print('$flagDarkModeEnabled: $isDarkModeEnabled');
    print('$flagShowBetaFeatures: $showBetaFeatures');
    print('$flagNewPaymentSystem: $useNewPaymentSystem');
    print('$flagShowReviewPrompt: $showReviewPrompt');
    print('$flagAdsEnabled: $isAdsEnabled');
    print('=====================');
  }

  /// Feature Flag 목록 (UI 표시용)
  Map<String, bool> getAllFlags() {
    return {
      flagNewHomeUI: isNewHomeUIEnabled,
      flagDarkModeEnabled: isDarkModeEnabled,
      flagShowBetaFeatures: showBetaFeatures,
      flagNewPaymentSystem: useNewPaymentSystem,
      flagShowReviewPrompt: showReviewPrompt,
      flagAdsEnabled: isAdsEnabled,
    };
  }
}

