# 6주차: Remote Config & Feature Flags

## 학습 목표
- Firebase Remote Config로 앱 설정 동적 관리
- Feature Flag 패턴으로 기능 제어
- 강제 업데이트 로직 구현

## Firebase 설정

### 1. 패키지 설치

```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^3.0.0
  firebase_remote_config: ^5.0.0
  package_info_plus: ^8.0.0  # 버전 체크용
```

### 2. Firebase Console 설정

1. Firebase Console → Remote Config 메뉴
2. "매개변수 추가" 클릭
3. 다음 매개변수들 추가:

| 키 | 데이터 타입 | 기본값 | 설명 |
|---|---|---|---|
| `minimum_app_version` | String | `1.0.0` | 강제 업데이트 기준 버전 |
| `maintenance_mode` | Boolean | `false` | 서버 점검 모드 |
| `maintenance_message` | String | `점검 중입니다` | 점검 메시지 |
| `welcome_message` | String | `환영합니다!` | 환영 메시지 |
| `new_feature_enabled` | Boolean | `false` | 새 기능 활성화 |

## 주요 파일

### services/remote_config_service.dart
- Remote Config 초기화
- 기본값 설정
- Fetch & Activate
- Getter 메서드들

### services/feature_flag_service.dart
- Feature Flag 키 정의
- 조건부 기능 실행
- 조건부 위젯 반환

### services/force_update_service.dart
- 버전 비교 로직
- 강제 업데이트 판단
- 점검 모드 체크

## main.dart 설정

```dart
import 'package:firebase_core/firebase_core.dart';
import 'week6_remote_config/services/remote_config_service.dart';
import 'week6_remote_config/services/force_update_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Remote Config 초기화
  await RemoteConfigService.instance.initialize();
  
  // 강제 업데이트 서비스 초기화
  await ForceUpdateService.instance.initialize();
  
  runApp(const MyApp());
}
```

## 사용 예시

### 1. Remote Config 값 사용

```dart
final remoteConfig = RemoteConfigService.instance;

// 환영 메시지 표시
Text(remoteConfig.welcomeMessage);

// API URL 가져오기
final apiUrl = remoteConfig.apiBaseUrl;

// 최대 업로드 크기 체크
if (fileSize > remoteConfig.maxUploadSizeMB * 1024 * 1024) {
  showError('파일 크기 초과');
}
```

### 2. Feature Flag 사용

```dart
final featureFlags = FeatureFlagService.instance;

// 조건부 위젯
featureFlags.widgetIfEnabled(
  FeatureFlagService.flagNewHomeUI,
  enabled: NewHomeScreen(),
  disabled: OldHomeScreen(),
);

// 조건부 실행
featureFlags.executeIfEnabled(
  FeatureFlagService.flagNewPaymentSystem,
  onEnabled: () => navigateToNewPayment(),
  onDisabled: () => navigateToOldPayment(),
);

// 직접 체크
if (featureFlags.isNewHomeUIEnabled) {
  // 새로운 UI 로직
}
```

### 3. 강제 업데이트 체크

```dart
// 앱 시작 시 체크 (Splash 또는 Home에서)
void checkForUpdates(BuildContext context) {
  final result = ForceUpdateService.instance.checkForUpdates();
  
  switch (result.status) {
    case UpdateStatus.ok:
      // 정상 진행
      break;
    case UpdateStatus.forceUpdate:
      ForceUpdateDialog.show(
        context,
        result: result,
        onUpdate: () => launchUrl(storeUrl),
      );
      break;
    case UpdateStatus.maintenance:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MaintenanceScreen(message: result.message),
        ),
      );
      break;
  }
}
```

## 실무 활용 시나리오

### 1. 긴급 기능 비활성화
버그가 발견된 기능을 앱 업데이트 없이 즉시 비활성화

```dart
// Firebase Console에서 flag_new_payment_system = false 설정
// 앱에서 자동으로 기존 결제 시스템 사용
```

### 2. 점진적 릴리즈 (Rollout)
새 기능을 일부 사용자에게만 먼저 공개

```dart
// Firebase Console의 조건 기능 사용
// - 랜덤 사용자 10%에게만 new_feature_enabled = true
// - 점진적으로 50%, 100%로 확대
```

### 3. A/B 테스팅
다른 UI/UX를 테스트하여 최적의 경험 선택

```dart
// Firebase Console에서 Experiments 설정
// - Variant A: welcome_message = "안녕하세요!"
// - Variant B: welcome_message = "반갑습니다!"
// 전환율 비교 후 최적안 선택
```

### 4. 강제 업데이트
중요 보안 패치 또는 API 변경 시 기존 버전 차단

```dart
// Firebase Console에서 minimum_app_version = "2.0.0" 설정
// 1.x.x 버전 사용자는 업데이트 필수
```

## Fetch 간격 설정

```dart
// 개발 중: 짧은 간격
minimumFetchInterval: Duration.zero

// 스테이징: 1분
minimumFetchInterval: Duration(minutes: 1)

// 프로덕션: 12시간 (비용 절감)
minimumFetchInterval: Duration(hours: 12)
```

## 디버깅

### Remote Config 값 확인
```dart
RemoteConfigService.instance.printAllValues();
FeatureFlagService.instance.printAllFlags();
```

### Firebase Console에서 테스트
1. Remote Config → 조건 → 디버그 기기 추가
2. 디바이스 ID로 특정 기기에만 테스트 값 적용

## 주의사항

1. **기본값 필수**: 네트워크 오류 시 앱이 동작할 수 있도록 기본값 설정
2. **캐싱 고려**: fetch 간격이 있으므로 즉시 반영되지 않을 수 있음
3. **타입 일치**: Console과 앱의 데이터 타입 일치 확인
4. **앱 시작 시 fetch**: 최신 값을 위해 앱 시작 시 fetch 호출

## 실습 과제

1. Firebase Console에서 Remote Config 매개변수 추가
2. `minimum_app_version`을 변경하여 강제 업데이트 테스트
3. Feature Flag로 특정 기능 On/Off 제어 구현

