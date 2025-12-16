# 7주차: 앱 보안 & 고급 기법

## 학습 목표
- Secure Storage로 민감 정보 저장
- ProGuard/R8 난독화 설정
- 환경 분리 (dev/staging/prod)
- Flavor 기본 설정

## 주요 파일

### services/secure_storage_service.dart
flutter_secure_storage를 활용한 안전한 데이터 저장

### config/app_config.dart
--dart-define을 활용한 환경별 설정

## Secure Storage 사용법

```dart
final storage = SecureStorageService();

// 토큰 저장
await storage.saveAccessToken('eyJhbGciOiJIUzI1NiIs...');

// 토큰 조회
final token = await storage.getAccessToken();

// 토큰 삭제
await storage.clearTokens();
```

## 환경별 빌드

```bash
# 개발 환경
flutter run --dart-define=ENV=dev

# 스테이징 환경
flutter run --dart-define=ENV=staging

# 프로덕션 환경
flutter run --dart-define=ENV=prod
flutter build apk --dart-define=ENV=prod
```

## ProGuard 설정

### android/app/build.gradle.kts

```kotlin
android {
    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}
```

### android/app/proguard-rules.pro

```proguard
# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }

# flutter_secure_storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }
```

## Flavor 설정 (Android)

### android/app/build.gradle.kts

```kotlin
android {
    flavorDimensions += "environment"
    
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
        }
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
        }
        create("prod") {
            dimension = "environment"
        }
    }
}
```

### 빌드 명령어

```bash
# Dev 빌드
flutter run --flavor dev

# Staging 빌드
flutter run --flavor staging

# Production 빌드
flutter run --flavor prod
flutter build apk --flavor prod
```

## 보안 체크리스트

### 필수
- [ ] 민감 정보는 Secure Storage에 저장
- [ ] Release 빌드 시 난독화 적용
- [ ] HTTPS만 사용
- [ ] API 키는 환경 변수로 관리

### 권장
- [ ] Certificate Pinning (고급)
- [ ] Root/Jailbreak 감지
- [ ] 스크린샷 방지 (금융 앱)
- [ ] 디버거 감지

## 주의사항

### SharedPreferences vs Secure Storage

| 항목 | SharedPreferences | Secure Storage |
|------|------------------|----------------|
| 암호화 | ❌ 없음 | ✅ AES/Keychain |
| 속도 | 빠름 | 상대적으로 느림 |
| 용도 | 설정, 캐시 | 토큰, 비밀번호 |

### 절대 하면 안 되는 것
```dart
// ❌ 토큰을 SharedPreferences에 저장
final prefs = await SharedPreferences.getInstance();
await prefs.setString('token', 'secret'); // 위험!

// ❌ 프로덕션에서 토큰 로깅
print('Token: $token'); // 위험!

// ❌ 하드코딩된 API 키
const apiKey = 'sk-1234567890'; // 위험!
```

