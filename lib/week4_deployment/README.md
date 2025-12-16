# 4주차: 앱 스토어 배포

## 학습 목표
- Play Store 배포 프로세스 이해
- Keystore 생성 및 관리
- AAB 빌드 방법
- 앱 메타데이터 준비

## Android 배포 체크리스트

### 1. 앱 기본 정보 설정

#### android/app/build.gradle.kts
```kotlin
android {
    namespace = "com.example.advanced_class"
    
    defaultConfig {
        applicationId = "com.example.advanced_class"
        minSdk = 21
        targetSdk = 34
        versionCode = 1          // 매 업로드마다 증가
        versionName = "1.0.0"
    }
}
```

### 2. Keystore 생성

```bash
# Keystore 생성 (한 번만 실행)
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# 생성된 파일: upload-keystore.jks
# ⚠️ 이 파일과 비밀번호는 절대 분실하면 안 됩니다!
```

### 3. key.properties 파일 생성

`android/key.properties` (git에 포함하지 않음!)
```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=../upload-keystore.jks
```

### 4. Release 빌드

```bash
# APK 빌드
flutter build apk --release

# AAB 빌드 (Play Store 업로드용)
flutter build appbundle --release
```

## Play Console 등록 순서

1. **개발자 계정 생성**
   - https://play.google.com/console
   - 25달러 일회성 등록비

2. **앱 생성**
   - 앱 이름, 기본 언어 설정
   - 앱 액세스 권한 선택

3. **스토어 등록 정보**
   - 앱 아이콘 (512x512)
   - 그래픽 이미지 (1024x500)
   - 스크린샷 (최소 2장)
   - 앱 설명, 간단한 설명

4. **콘텐츠 등급**
   - 설문지 작성으로 등급 획득

5. **타겟 잠재고객**
   - 연령대 선택

6. **개인정보처리방침**
   - URL 제공 필수

7. **앱 출시**
   - 내부 테스트 → 비공개 테스트 → 프로덕션

## 주요 리젝 사유 및 대응

| 사유 | 대응 방법 |
|------|----------|
| 개인정보처리방침 없음 | URL 추가 |
| 앱 충돌 | Crashlytics로 원인 파악 |
| 기능 미작동 | 테스트 계정 제공 |
| 메타데이터 정책 위반 | 키워드 스팸, 오해의 소지 제거 |
| 권한 과다 요청 | 필요한 권한만 요청 |

## 버전 관리 전략

```yaml
# pubspec.yaml
version: 1.0.0+1
#        ^   ^
#        |   +-- versionCode (빌드 번호) - 매 업로드마다 증가
#        +------ versionName (버전 이름) - 사용자에게 표시
```

### Semantic Versioning
- **Major (1.x.x)**: 큰 변경, 하위 호환성 없음
- **Minor (x.1.x)**: 새 기능 추가, 하위 호환
- **Patch (x.x.1)**: 버그 수정

