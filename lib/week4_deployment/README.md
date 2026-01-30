# 4주차: 앱 스토어 배포

## 학습 목표

- Play Store 배포 프로세스 이해
- App Store 배포 프로세스 이해
- Keystore 생성 및 관리
- iOS 인증서 및 프로비저닝 프로파일 관리
- AAB/IPA 빌드 방법
- 앱 메타데이터 준비
- 주요 리젝 사유 및 대응 방법
- Fastlane을 이용한 배포 자동화
- CI/CD를 통한 자동 배포 설정
- 스크린샷 및 아이콘 제작 방법

### 설명 이유
Flutter는 아무래도 대기업 보다는 스타트업에서 많이 채용을 하다보니
회사에 입사해도 사수가 없는 경우가 꽤 있음.
이런 경우에 앱을 실제로 스토어에 배포하는 업무를 할 때 많이 당황했었고, 생각보다 시간이 많이 소요됐음.
여러분들은 이 학습을 통해서 그래도 조금이나마 익숙해져 있으면 좋겠다는 생각에 강의를 진행하게 됐습니다.

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

또는 빌드 스크립트 사용:

```bash
./scripts/build_release.sh [apk|appbundle|both]
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

## iOS 배포 체크리스트

### 1. 앱 기본 정보 설정

#### ios/Runner/Info.plist

```xml
<key>CFBundleDisplayName</key>
<string>앱 이름</string>
<key>CFBundleIdentifier</key>
<string>com.example.advancedClass</string>
<key>CFBundleVersion</key>
<string>$(FLUTTER_BUILD_NUMBER)</string>
<key>CFBundleShortVersionString</key>
<string>$(FLUTTER_BUILD_NAME)</string>
```

#### pubspec.yaml

```yaml
version: 1.0.0+1
#        ^   ^
#        |   +-- Build Number (CFBundleVersion)
#        +------ Version Name (CFBundleShortVersionString)
```

### 2. Apple Developer 계정 설정

1. **Apple Developer Program 가입**

   - https://developer.apple.com/programs/
   - 연간 $99 (개인/기업)

2. **인증서 및 프로비저닝 프로파일 생성**
   - Xcode에서 자동 관리 권장 (Automatic Signing)
   - 또는 수동으로 App Store Distribution 인증서 생성

### 3. Xcode 프로젝트 설정

1. **Bundle Identifier 설정**

   - Xcode → Runner → General → Bundle Identifier
   - 예: `com.example.advancedClass`

2. **Signing & Capabilities**

   - Team 선택
   - "Automatically manage signing" 체크
   - Capabilities 추가 (Push Notifications, Background Modes 등)

3. **Deployment Target**
   - 최소 iOS 버전 설정 (권장: iOS 13.0 이상)

### 4. Release 빌드

```bash
# iOS Release 빌드
flutter build ios --release

# Xcode에서 Archive 생성
# Product → Archive → Distribute App → App Store Connect
```

또는 빌드 스크립트 사용:

```bash
# 빌드만 수행
./scripts/build_ios_release.sh build

# Archive 생성
./scripts/build_ios_release.sh archive

# Archive 생성 및 업로드 (API 키 필요)
./scripts/build_ios_release.sh upload
```

명령줄에서 직접 Archive 생성:

```bash
# Archive 생성
xcodebuild -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -archivePath build/Runner.xcarchive \
  archive

# IPA 생성 및 업로드 (App Store Connect API 사용)
xcrun altool --upload-app \
  --type ios \
  --file build/Runner.ipa \
  --apiKey YOUR_API_KEY \
  --apiIssuer YOUR_ISSUER_ID
```

## App Store Connect 등록 순서

1. **개발자 계정 생성**

   - https://developer.apple.com/programs/
   - $99 연간 구독

2. **App Store Connect에서 앱 생성**

   - https://appstoreconnect.apple.com
   - 앱 이름, 기본 언어, Bundle ID 설정
   - SKU (고유 식별자) 생성

3. **앱 정보 입력**

   - 앱 아이콘 (1024x1024, 투명도 없음)
   - 스크린샷 (다양한 기기 크기)
     - iPhone 6.7" (1290x2796)
     - iPhone 6.5" (1284x2778)
     - iPad Pro 12.9" (2048x2732)
   - 앱 설명, 키워드, 카테고리

4. **가격 및 판매 범위**

   - 가격 책정
   - 판매 국가 선택

5. **개인정보처리방침 URL**

   - 필수 항목 (Play Store와 동일)

6. **앱 심사 정보**

   - 연락처 정보
   - 데모 계정 (필요시)
   - 특별 지침 (필요시)

7. **TestFlight 베타 테스트** (선택사항)

   - 내부 테스터 (최대 100명)
   - 외부 테스터 (최대 10,000명, 심사 필요)

8. **앱 제출 및 심사**
   - 빌드 선택
   - 제출 후 심사 대기 (보통 24-48시간)

## 주요 리젝 사유 및 대응 방법

### 공통 리젝 사유

#### 1. 개인정보처리방침 없음

**사유**: 앱이 개인정보를 수집하는데 개인정보처리방침 URL이 없음

**대응 방법**:

- 개인정보처리방침 페이지 작성 및 호스팅
- Play Console / App Store Connect에 URL 등록
- 템플릿 참고: `templates/PRIVACY_POLICY_TEMPLATE.md`

#### 2. 앱 충돌(Crash)

**사유**: 앱이 실행 중 크래시 발생

**대응 방법**:

- Firebase Crashlytics로 크래시 로그 수집
- 주요 기기에서 테스트 (다양한 OS 버전)
- 릴리스 빌드에서 충분한 테스트 수행
- 크래시 없는 안정적인 빌드 제출

#### 3. 기능 미작동

**사유**: 앱의 핵심 기능이 작동하지 않음

**대응 방법**:

- 테스트 계정 제공 (로그인 필요 시)
- 데모 모드 또는 샘플 데이터 제공
- 모든 기능이 정상 작동하는지 확인
- 심사 가이드에 기능 설명 추가

#### 4. 메타데이터 정책 위반

**사유**: 앱 설명, 스크린샷, 키워드가 정책 위반

**대응 방법**:

- 키워드 스팸 제거 (예: "최고의 앱, 무료, 다운로드" 등)
- 오해의 소지가 있는 표현 제거
- 실제 앱 기능과 일치하는 설명 작성
- 스크린샷이 실제 앱 화면과 일치하는지 확인

#### 5. 권한 과다 요청

**사유**: 불필요한 권한 요청

**대응 방법**:

- 필요한 권한만 요청
- 권한 사용 목적 명확히 설명
- Info.plist / AndroidManifest.xml에서 불필요한 권한 제거
- 권한 요청 시 사용자에게 이유 설명

### Play Store 특화 리젝 사유

#### 6. 타겟 SDK 버전 미준수

**사유**: 최신 타겟 SDK 버전을 사용하지 않음

**대응 방법**:

- `targetSdkVersion`을 최신 버전으로 업데이트
- 새로운 권한 모델 준수
- Scoped Storage 정책 준수

#### 7. 콘텐츠 등급 문제

**사유**: 콘텐츠 등급이 부정확하거나 부적절함

**대응 방법**:

- 콘텐츠 등급 설문 정확히 작성
- 앱 콘텐츠와 일치하는 등급 선택
- 연령 제한이 필요한 콘텐츠는 적절히 표시

#### 8. AAB 서명 문제

**사유**: App Bundle 서명 오류

**대응 방법**:

- Keystore 파일과 비밀번호 확인
- `key.properties` 설정 확인
- `flutter build appbundle --release` 재빌드

### App Store 특화 리젝 사유

#### 9. Guideline 4.0 (디자인) 위반

**사유**: 앱이 Apple의 디자인 가이드라인을 따르지 않음

**대응 방법**:

- Human Interface Guidelines 준수
- 네이티브 iOS UI 요소 사용 권장
- 일관된 디자인 언어 사용
- 적절한 아이콘 및 그래픽 사용

#### 10. Guideline 2.1 (앱 완성도) 위반

**사유**: 앱이 미완성이거나 베타 버전처럼 보임

**대응 방법**:

- 모든 기능이 완전히 구현되었는지 확인
- "베타", "테스트" 등의 문구 제거
- Placeholder 콘텐츠 제거
- 완성도 높은 UI/UX 제공

#### 11. Guideline 3.1.1 (인앱 구매) 위반

**사유**: 인앱 구매 정책 위반

**대응 방법**:

- 디지털 콘텐츠는 반드시 인앱 구매 사용
- 외부 결제 링크 제거
- 구독 정책 준수 (자동 갱신 등)

#### 12. Guideline 5.1.1 (개인정보) 위반

**사유**: 개인정보 수집 및 사용 정책 위반

**대응 방법**:

- 개인정보처리방침에 수집 항목 명시
- 사용자 동의 받기
- 데이터 수집 목적 명확히 설명
- GDPR, CCPA 등 규정 준수

#### 13. TestFlight 빌드 만료

**사유**: TestFlight 빌드가 90일 경과로 만료됨

**대응 방법**:

- 정기적으로 새 빌드 업로드
- 만료 전 업데이트 제출
- 프로덕션 빌드로 전환

## 플랫폼별 비교

| 항목              | Play Store               | App Store                    |
| ----------------- | ------------------------ | ---------------------------- |
| **등록비**        | $25 (일회성)             | $99 (연간)                   |
| **심사 시간**     | 보통 1-3일               | 보통 24-48시간               |
| **심사 엄격도**   | 보통                     | 매우 엄격                    |
| **업데이트 속도** | 빠름 (몇 시간)           | 느림 (1-2일)                 |
| **베타 테스트**   | 내부/비공개/공개 테스트  | TestFlight (내부/외부)       |
| **빌드 형식**     | AAB (App Bundle)         | IPA                          |
| **서명**          | Keystore (JKS)           | 인증서 + 프로비저닝 프로파일 |
| **자동 서명**     | 지원 안 함               | Xcode 자동 서명 지원         |
| **롤백**          | 가능                     | 불가능 (새 빌드 필요)        |
| **스테이징**      | 내부 → 비공개 → 프로덕션 | TestFlight → 프로덕션        |

## 배포 전 체크리스트

### 공통 체크리스트

- [ ] 앱이 모든 주요 기능에서 정상 작동하는지 확인
- [ ] 릴리스 빌드에서 충분한 테스트 수행
- [ ] 크래시 없이 안정적으로 동작하는지 확인
- [ ] 개인정보처리방침 URL 준비 및 등록
- [ ] 앱 아이콘 및 스크린샷 준비
- [ ] 앱 설명 및 키워드 작성 (정책 준수)
- [ ] 버전 번호 업데이트

### Play Store 체크리스트

- [ ] Keystore 파일 안전하게 보관
- [ ] `key.properties` 설정 확인
- [ ] AAB 빌드 성공 확인
- [ ] 타겟 SDK 버전 확인 (최신 권장)
- [ ] 콘텐츠 등급 설문 완료
- [ ] 내부 테스트에서 검증 완료

### App Store 체크리스트

- [ ] Apple Developer Program 가입 완료
- [ ] Bundle Identifier 설정 확인
- [ ] Xcode에서 Signing 설정 확인
- [ ] Archive 빌드 성공 확인
- [ ] TestFlight에서 베타 테스트 완료 (권장)
- [ ] Human Interface Guidelines 준수 확인
- [ ] 인앱 구매 정책 준수 (해당 시)

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

## 실제 배포 실습

### Play Store 배포 실습

#### 1단계: 개발자 계정 준비

1. Google Play Console 접속: https://play.google.com/console
2. 개발자 계정 생성 ($25 일회성 결제)
3. 계정 정보 입력 및 결제 완료

#### 2단계: 앱 생성 및 기본 설정

1. **앱 생성**

   - "앱 만들기" 클릭
   - 앱 이름 입력 (예: "Advanced Class")
   - 기본 언어 선택 (한국어)
   - 앱 또는 게임 선택
   - 무료/유료 선택

2. **앱 액세스 설정**
   - 모든 사용자 / 제한된 사용자 선택
   - 콘텐츠 등급 준비

#### 3단계: Keystore 생성 및 빌드

```bash
# 1. Keystore 생성
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# 비밀번호 입력 (안전하게 보관!)

# 2. key.properties 파일 생성
cat > android/key.properties << EOF
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=../upload-keystore.jks
EOF

# 3. AAB 빌드
flutter build appbundle --release
```

#### 4단계: Play Console에 앱 정보 입력

1. **스토어 등록 정보**

   - 앱 아이콘 업로드 (512x512 PNG)
   - 기능 그래픽 업로드 (1024x500 PNG, 선택사항)
   - 스크린샷 최소 2장 업로드
   - 앱 설명 작성 (최대 4000자)
   - 간단한 설명 작성 (최대 80자)

2. **콘텐츠 등급**

   - 설문지 작성
   - 앱 콘텐츠에 맞는 등급 선택

3. **개인정보처리방침**
   - URL 입력 (호스팅된 개인정보처리방침 페이지)

#### 5단계: 내부 테스트 트랙에 업로드

1. **내부 테스트 트랙 생성**

   - 출시 → 테스트 → 내부 테스트
   - "새 출시 만들기" 클릭

2. **AAB 업로드**

   - "앱 번들 업로드" 클릭
   - `build/app/outputs/bundle/release/app-release.aab` 선택
   - 업로드 완료 대기 (몇 분 소요)

3. **테스터 추가**

   - 테스터 이메일 주소 추가
   - 테스트 링크 공유

4. **검토 및 출시**
   - "검토" 클릭
   - "출시" 클릭

#### 6단계: 프로덕션 출시

1. 내부 테스트에서 검증 완료 후
2. 출시 → 프로덕션 → "새 출시 만들기"
3. 내부 테스트에서 승인된 버전 선택
4. 출시 노트 작성
5. "검토" → "출시" 클릭

### App Store 배포 실습

#### 1단계: Apple Developer 계정 준비

1. Apple Developer Program 가입: https://developer.apple.com/programs/
2. 연간 $99 결제
3. 계정 활성화 대기 (보통 24-48시간)

#### 2단계: App Store Connect에서 앱 생성

1. **App Store Connect 접속**

   - https://appstoreconnect.apple.com
   - "내 앱" → "+" 클릭

2. **앱 정보 입력**
   - 플랫폼: iOS
   - 이름: 앱 이름
   - 기본 언어: 한국어
   - Bundle ID: Xcode에서 설정한 Bundle ID 선택
   - SKU: 고유 식별자 (예: advanced-class-001)

#### 3단계: Xcode에서 Archive 생성

1. **Xcode 프로젝트 열기**

   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Signing 설정**

   - Runner 타겟 선택
   - Signing & Capabilities 탭
   - Team 선택
   - "Automatically manage signing" 체크

3. **Archive 생성**

   - 상단에서 "Any iOS Device" 선택
   - Product → Archive
   - Archive 완료 대기

4. **App Store Connect에 업로드**
   - Archive 완료 후 "Distribute App" 클릭
   - "App Store Connect" 선택
   - "Upload" 선택
   - 다음 단계 진행

#### 4단계: App Store Connect에서 앱 정보 입력

1. **앱 정보**

   - 앱 아이콘 업로드 (1024x1024 PNG, 투명도 없음)
   - 스크린샷 업로드
     - iPhone 6.7" (1290x2796) - 필수
     - iPhone 6.5" (1284x2778) - 권장
     - iPad Pro 12.9" (2048x2732) - iPad 지원 시

2. **앱 설명**

   - 이름 (최대 30자)
   - 부제목 (최대 30자)
   - 설명 (최대 4000자)
   - 키워드 (최대 100자, 쉼표로 구분)
   - 홍보 텍스트 (최대 4000자)

3. **가격 및 판매 범위**

   - 가격 책정
   - 판매 국가 선택

4. **개인정보처리방침 URL**

   - URL 입력

5. **앱 심사 정보**
   - 연락처 정보 입력
   - 데모 계정 (필요시)
   - 특별 지침 (필요시)

#### 5단계: TestFlight 베타 테스트 (선택사항)

1. **내부 테스터 추가**

   - TestFlight → 내부 테스터
   - 이메일 주소 추가
   - 테스터가 이메일에서 승인

2. **외부 테스터 추가** (심사 필요)
   - 외부 테스터 그룹 생성
   - 테스터 추가
   - 빌드 선택
   - 심사 제출

#### 6단계: 앱 심사 제출

1. **빌드 선택**

   - "앱 스토어" 섹션에서 빌드 선택
   - 업로드된 빌드가 보이지 않으면 몇 분 대기

2. **심사 제출**

   - "심사 제출" 클릭
   - 확인 사항 체크
   - 제출 완료

3. **심사 대기**
   - 보통 24-48시간 소요
   - 상태는 "심사 중" → "승인됨" 또는 "거부됨"

## Fastlane 소개 및 설정

### Fastlane이란?

Fastlane은 iOS와 Android 앱 배포를 자동화하는 도구입니다. 반복적인 배포 작업을 스크립트로 자동화하여 시간을 절약하고 실수를 줄일 수 있습니다.

### 주요 기능

- **자동 빌드**: APK, AAB, IPA 자동 생성
- **자동 업로드**: Play Store / App Store Connect 자동 업로드
- **메타데이터 관리**: 스크린샷, 설명, 키워드 자동 업데이트
- **증분 배포**: 내부 테스트 → 비공개 테스트 → 프로덕션 자동화
- **CI/CD 통합**: GitHub Actions, GitLab CI 등과 연동

### 설치 방법

```bash
# macOS
sudo gem install fastlane

# 또는 Homebrew
brew install fastlane

# 버전 확인
fastlane --version
```

### Android Fastlane 설정

#### 1. Fastlane 초기화

```bash
cd android
fastlane init
```

선택 옵션:

- `2` (Automate beta distribution to Google Play)

#### 2. Appfile 생성

`android/fastlane/Appfile`:

```ruby
json_key_file("../fastlane/google-play-service-account.json")
package_name("com.example.advanced_class")
```

#### 3. Google Play 서비스 계정 생성

1. Google Cloud Console 접속
2. 프로젝트 생성
3. API 및 서비스 → 사용자 인증 정보
4. 서비스 계정 생성
5. Play Console에서 서비스 계정에 액세스 권한 부여
6. JSON 키 다운로드 → `fastlane/google-play-service-account.json`에 저장

#### 4. Fastfile 작성

`android/fastlane/Fastfile`:

```ruby
default_platform(:android)

platform :android do
  desc "Build release AAB"
  lane :build do
    sh("cd .. && flutter build appbundle --release")
  end

  desc "Upload to Play Store Internal Testing"
  lane :beta do
    build
    upload_to_play_store(
      track: 'internal',
      aab: '../build/app/outputs/bundle/release/app-release.aab',
      skip_upload_metadata: true,
      skip_upload_images: true,
      skip_upload_screenshots: true
    )
  end

  desc "Upload to Play Store Production"
  lane :release do
    build
    upload_to_play_store(
      track: 'production',
      aab: '../build/app/outputs/bundle/release/app-release.aab',
      skip_upload_metadata: true,
      skip_upload_images: true,
      skip_upload_screenshots: true
    )
  end
end
```

#### 5. 사용 방법

```bash
# 내부 테스트에 업로드
cd android
fastlane beta

# 프로덕션에 업로드
fastlane release
```

### iOS Fastlane 설정

#### 1. Fastlane 초기화

```bash
cd ios
fastlane init
```

선택 옵션:

- `2` (Automate beta distribution to TestFlight)

#### 2. Appfile 생성

`ios/fastlane/Appfile`:

```ruby
app_identifier("com.example.advancedClass")
apple_id("your-email@example.com")
team_id("YOUR_TEAM_ID")
```

#### 3. App Store Connect API 키 설정

1. App Store Connect → 사용자 및 액세스 → 키
2. "앱 스토어 Connect API" 키 생성
3. 키 ID, Issuer ID, `.p8` 파일 다운로드
4. `.p8` 파일을 `ios/fastlane/AuthKey_XXXXX.p8`에 저장

#### 4. Fastfile 작성

`ios/fastlane/Fastfile`:

```ruby
default_platform(:ios)

platform :ios do
  desc "Build and upload to TestFlight"
  lane :beta do
    increment_build_number(
      xcodeproj: "Runner.xcodeproj"
    )

    build_app(
      workspace: "Runner.xcworkspace",
      scheme: "Runner",
      export_method: "app-store"
    )

    upload_to_testflight(
      skip_waiting_for_build_processing: true
    )
  end

  desc "Build and upload to App Store"
  lane :release do
    increment_build_number(
      xcodeproj: "Runner.xcodeproj"
    )

    build_app(
      workspace: "Runner.xcworkspace",
      scheme: "Runner",
      export_method: "app-store"
    )

    upload_to_app_store(
      skip_metadata: true,
      skip_screenshots: true,
      force: true
    )
  end
end
```

#### 5. 사용 방법

```bash
# TestFlight에 업로드
cd ios
fastlane beta

# App Store에 업로드
fastlane release
```

### Fastlane과 CI/CD 통합

GitHub Actions에서 Fastlane 사용 예시:

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    tags:
      - "v*"

jobs:
  deploy-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: "3.0"
      - name: Install Fastlane
        run: gem install fastlane
      - name: Deploy to Play Store
        working-directory: android
        env:
          GOOGLE_PLAY_SERVICE_ACCOUNT_JSON: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT_JSON }}
        run: fastlane beta

  deploy-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
      - name: Install Fastlane
        run: gem install fastlane
      - name: Deploy to TestFlight
        working-directory: ios
        env:
          APP_STORE_CONNECT_API_KEY_ID: ${{ secrets.APP_STORE_CONNECT_API_KEY_ID }}
          APP_STORE_CONNECT_ISSUER_ID: ${{ secrets.APP_STORE_CONNECT_ISSUER_ID }}
          APP_STORE_CONNECT_API_KEY_CONTENT: ${{ secrets.APP_STORE_CONNECT_API_KEY_CONTENT }}
        run: fastlane beta
```

## CI/CD 자동 배포

### GitHub Actions를 이용한 자동 배포

#### Android 자동 배포 워크플로우

`.github/workflows/deploy-android.yml`:

```yaml
name: Deploy Android

on:
  push:
    tags:
      - "v*" # v1.0.0 같은 태그 생성 시 실행
  workflow_dispatch: # 수동 실행도 가능

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: 📥 Checkout
        uses: actions/checkout@v4

      - name: ☕ Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: "zulu"
          java-version: "17"

      - name: 🐦 Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.38.5"
          channel: "stable"
          cache: true

      - name: 📦 Install dependencies
        run: flutter pub get

      - name: 🔐 Setup Keystore
        env:
          KEYSTORE_BASE64: ${{ secrets.KEYSTORE_BASE64 }}
          KEY_PROPERTIES: ${{ secrets.KEY_PROPERTIES }}
        run: |
          echo "$KEYSTORE_BASE64" | base64 --decode > android/app/upload-keystore.jks
          echo "$KEY_PROPERTIES" > android/key.properties

      - name: 🏗️ Build AAB
        run: flutter build appbundle --release

      - name: 📤 Upload to Play Store (Internal)
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT_JSON }}
          packageName: com.example.advanced_class
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: internal
          status: completed
```

#### iOS 자동 배포 워크플로우

`.github/workflows/deploy-ios.yml`:

```yaml
name: Deploy iOS

on:
  push:
    tags:
      - "v*"
  workflow_dispatch:

jobs:
  deploy:
    runs-on: macos-latest

    steps:
      - name: 📥 Checkout
        uses: actions/checkout@v4

      - name: 🐦 Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.38.5"
          channel: "stable"
          cache: true

      - name: 📦 Install dependencies
        run: flutter pub get

      - name: 🍎 Setup Xcode
        uses: maxim-lobanov/setup-xcode@v1
        with:
          xcode-version: "latest-stable"

      - name: 🔐 Setup Code Signing
        env:
          APPLE_CERTIFICATE_BASE64: ${{ secrets.APPLE_CERTIFICATE_BASE64 }}
          APPLE_CERTIFICATE_PASSWORD: ${{ secrets.APPLE_CERTIFICATE_PASSWORD }}
          KEYCHAIN_PASSWORD: ${{ secrets.KEYCHAIN_PASSWORD }}
        run: |
          # 인증서 설치
          echo "$APPLE_CERTIFICATE_BASE64" | base64 --decode > certificate.p12
          security create-keychain -p "$KEYCHAIN_PASSWORD" build.keychain
          security default-keychain -s build.keychain
          security unlock-keychain -p "$KEYCHAIN_PASSWORD" build.keychain
          security import certificate.p12 -k build.keychain -P "$APPLE_CERTIFICATE_PASSWORD" -T /usr/bin/codesign
          security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$KEYCHAIN_PASSWORD" build.keychain

      - name: 🏗️ Build IPA
        run: |
          flutter build ios --release --no-codesign
          xcodebuild -workspace ios/Runner.xcworkspace \
            -scheme Runner \
            -configuration Release \
            -archivePath build/Runner.xcarchive \
            archive

      - name: 📤 Upload to App Store Connect
        uses: apple-actions/upload-testflight-build@v1
        with:
          app-path: build/Runner.xcarchive
          issuer-id: ${{ secrets.APP_STORE_CONNECT_ISSUER_ID }}
          api-key-id: ${{ secrets.APP_STORE_CONNECT_API_KEY_ID }}
          api-private-key: ${{ secrets.APP_STORE_CONNECT_API_PRIVATE_KEY }}
```

### GitHub Secrets 설정

#### Android Secrets

1. **KEYSTORE_BASE64**: Keystore 파일의 Base64 인코딩

   ```bash
   base64 -i upload-keystore.jks
   ```

2. **KEY_PROPERTIES**: key.properties 파일 내용

   ```
   storePassword=your-password
   keyPassword=your-password
   keyAlias=upload
   storeFile=../upload-keystore.jks
   ```

3. **GOOGLE_PLAY_SERVICE_ACCOUNT_JSON**: Google Play 서비스 계정 JSON 전체 내용

#### iOS Secrets

1. **APPLE_CERTIFICATE_BASE64**: 인증서(.p12)의 Base64 인코딩
2. **APPLE_CERTIFICATE_PASSWORD**: 인증서 비밀번호
3. **KEYCHAIN_PASSWORD**: Keychain 비밀번호
4. **APP_STORE_CONNECT_ISSUER_ID**: App Store Connect Issuer ID
5. **APP_STORE_CONNECT_API_KEY_ID**: API Key ID
6. **APP_STORE_CONNECT_API_PRIVATE_KEY**: API Private Key (.p8 파일 내용)

### 자동 배포 트리거 방법

```bash
# 태그 생성하여 자동 배포 트리거
git tag v1.0.0
git push origin v1.0.0

# 또는 GitHub에서 수동 실행
# Actions → Deploy Android → Run workflow
```

## 스크린샷 및 아이콘 제작 가이드

### 앱 아이콘 제작

#### Android 아이콘 요구사항

| 크기    | 용도                       | 형식              |
| ------- | -------------------------- | ----------------- |
| 512x512 | Play Store 아이콘          | PNG (투명도 없음) |
| 192x192 | Adaptive Icon (foreground) | PNG               |
| 144x144 | Adaptive Icon (background) | PNG (선택사항)    |

#### iOS 아이콘 요구사항

| 크기      | 용도                      | 형식              |
| --------- | ------------------------- | ----------------- |
| 1024x1024 | App Store 아이콘          | PNG (투명도 없음) |
| 180x180   | iPhone 앱 아이콘          | PNG               |
| 120x120   | iPhone 앱 아이콘 (레거시) | PNG               |

#### 아이콘 디자인 가이드라인

1. **단순하고 명확하게**

   - 작은 크기에서도 알아볼 수 있어야 함
   - 복잡한 디테일 피하기

2. **브랜드 일관성**

   - 앱의 색상과 스타일 유지
   - 로고나 심볼 활용

3. **플랫폼별 차이**

   - Android: 둥근 모서리 (시스템이 자동 적용)
   - iOS: 둥근 모서리 (시스템이 자동 적용)

4. **투명도 금지**
   - Play Store와 App Store 모두 투명도 없는 PNG 필수

#### 아이콘 제작 도구

1. **온라인 도구**

   - [App Icon Generator](https://www.appicon.co/)
   - [Icon Kitchen](https://icon.kitchen/) (Android)
   - [MakeAppIcon](https://makeappicon.com/)

2. **디자인 도구**

   - Figma
   - Adobe Illustrator
   - Sketch

3. **Flutter 패키지**
   - `flutter_launcher_icons`: 코드로 아이콘 자동 생성

#### flutter_launcher_icons 사용법

```yaml
# pubspec.yaml에 추가
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon.png" # 1024x1024 원본 이미지
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/icon/icon_foreground.png"
```

```bash
# 아이콘 생성
flutter pub get
flutter pub run flutter_launcher_icons
```

### 스크린샷 제작

#### Android 스크린샷 요구사항

| 기기   | 크기           | 최소 개수  |
| ------ | -------------- | ---------- |
| Phone  | 1080x1920 이상 | 2장        |
| Tablet | 1200x1920 이상 | 2장 (선택) |
| TV     | 1920x1080      | 1장 (선택) |
| Wear   | 400x400        | 1장 (선택) |

**추가 요구사항**:

- 기능 그래픽: 1024x500 (선택사항)
- 짧은 설명: 최대 80자

#### iOS 스크린샷 요구사항

| 기기           | 크기      | 필수 여부         |
| -------------- | --------- | ----------------- |
| iPhone 6.7"    | 1290x2796 | 필수              |
| iPhone 6.5"    | 1284x2778 | 권장              |
| iPhone 5.5"    | 1242x2208 | 선택              |
| iPad Pro 12.9" | 2048x2732 | iPad 지원 시 필수 |
| iPad Pro 11"   | 1668x2388 | iPad 지원 시 권장 |

**추가 요구사항**:

- 앱 미리보기 비디오: 최대 30초 (선택사항)

#### 스크린샷 제작 방법

##### 방법 1: 실제 기기에서 캡처

**Android**:

```bash
# ADB를 통한 스크린샷
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png

# 또는 기기에서 직접 캡처 후 전송
```

**iOS**:

- 시뮬레이터: Cmd + S
- 실제 기기: 전원 버튼 + 홈 버튼 (또는 볼륨 업 + 전원)

##### 방법 2: 에뮬레이터/시뮬레이터 사용

**Android Emulator**:

```bash
# 에뮬레이터 실행
flutter emulators --launch <emulator_id>

# 스크린샷 캡처
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png
```

**iOS Simulator**:

```bash
# 시뮬레이터 실행
open -a Simulator
flutter run

# 스크린샷 캡처
xcrun simctl io booted screenshot screenshot.png
```

##### 방법 3: Flutter 패키지 사용

```yaml
# pubspec.yaml
dev_dependencies:
  screenshots: ^3.2.0
```

`screenshots.yaml`:

```yaml
tests:
  - test_driver/main.dart

devices:
  ios:
    - iPhone 14 Pro Max
  android:
    - Nexus 6P

frames:
  android: true
  ios: true
```

```bash
# 스크린샷 자동 생성
flutter pub get
screenshots
```

#### 스크린샷 디자인 팁

1. **핵심 기능 강조**

   - 앱의 주요 기능을 보여주는 화면 선택
   - 사용자가 앱의 가치를 즉시 이해할 수 있도록

2. **텍스트 오버레이 활용**

   - 각 스크린샷에 간단한 설명 추가
   - "간편한 로그인", "실시간 알림" 등

3. **일관된 스타일**

   - 모든 스크린샷에 동일한 스타일 적용
   - 색상, 폰트, 레이아웃 일관성 유지

4. **다양한 화면 보여주기**

   - 홈 화면, 주요 기능 화면, 설정 화면 등
   - 앱의 전체적인 모습을 보여줌

5. **실제 콘텐츠 사용**
   - Placeholder 대신 실제 데이터 사용
   - 더욱 신뢰감 있는 느낌

#### 스크린샷 편집 도구

1. **온라인 도구**

   - [App Store Screenshot Generator](https://www.appstorescreenshot.com/)
   - [Screenshot Framer](https://screenshotframer.com/)

2. **디자인 도구**

   - Figma (템플릿 활용)
   - Adobe Photoshop
   - Sketch

3. **자동화 도구**
   - Fastlane의 `frameit` 기능
   - 스크린샷에 기기 프레임 자동 추가

#### Fastlane frameit 사용법

```bash
# frameit 설치
fastlane add_plugin frameit

# 스크린샷 프레임 추가
cd ios
fastlane frameit
```

`fastlane/Framefile.json`:

```json
{
  "default": {
    "keyword": {
      "color": "#FFFFFF"
    },
    "title": {
      "color": "#FFFFFF"
    },
    "background": "./background.jpg"
  }
}
```

### 메타데이터 작성 가이드

#### 앱 설명 작성 팁

1. **첫 문장이 중요**

   - 사용자가 처음 보는 부분
   - 앱의 핵심 가치를 명확히 전달

2. **키워드 활용**

   - 검색 최적화를 위한 키워드 포함
   - 자연스럽게 문장에 녹여내기

3. **구조화된 내용**

   - 단락으로 나누어 읽기 쉽게
   - 불릿 포인트 활용

4. **사용자 혜택 강조**
   - 기능 나열보다 사용자에게 주는 가치 강조
   - "당신의 생산성을 높여줍니다" 같은 표현

#### 예시: 좋은 앱 설명

```
📱 Advanced Class - Flutter 학습 앱

실전 Flutter 개발을 위한 고급 과정을 제공하는 학습 앱입니다.

✨ 주요 기능
• 실전 프로젝트 기반 학습
• CI/CD 파이프라인 구축
• 앱 스토어 배포 가이드
• 성능 최적화 기법

🎯 이 앱을 사용하면
• Flutter 고급 개발자로 성장할 수 있습니다
• 실제 프로젝트에 바로 적용 가능한 지식을 얻을 수 있습니다
• 업계 표준 개발 프로세스를 배울 수 있습니다

지금 바로 시작하세요!
```

#### 예시: 나쁜 앱 설명

```
최고의 앱! 무료 다운로드! 지금 바로 설치하세요!
다운로드하고 설치하면 좋은 앱입니다.
최고의 앱입니다.
```

(키워드 스팸, 구체적 정보 없음, 정책 위반 가능성)

## 빠른 참조

### 파일 구조

```
week4_deployment/
├── README.md                          # 메인 가이드 문서
├── scripts/
│   ├── build_release.sh              # Android 빌드 스크립트
│   └── build_ios_release.sh          # iOS 빌드 스크립트
├── fastlane/
│   ├── android/
│   │   ├── Appfile                   # Android Fastlane 설정
│   │   └── Fastfile                  # Android 배포 자동화
│   └── ios/
│       ├── Appfile                   # iOS Fastlane 설정
│       └── Fastfile                  # iOS 배포 자동화
├── .github/workflows/
│   ├── deploy-android.yml            # Android 자동 배포 워크플로우
│   └── deploy-ios.yml                # iOS 자동 배포 워크플로우
└── templates/
    ├── PRIVACY_POLICY_TEMPLATE.md    # 개인정보처리방침 템플릿
    ├── SCREENSHOT_GUIDE.md          # 스크린샷 제작 가이드
    └── ICON_GUIDE.md                 # 아이콘 제작 가이드
```

### 주요 명령어

#### Android 배포

```bash
# 수동 빌드
flutter build appbundle --release

# 스크립트 사용
./scripts/build_release.sh appbundle

# Fastlane 사용
cd android && fastlane beta
```

#### iOS 배포

```bash
# 수동 빌드
flutter build ios --release
# Xcode에서 Archive 생성

# 스크립트 사용
./scripts/build_ios_release.sh archive

# Fastlane 사용
cd ios && fastlane beta
```

#### CI/CD 자동 배포

```bash
# 태그 생성하여 자동 배포 트리거
git tag v1.0.0
git push origin v1.0.0
```

### 유용한 링크

- [Google Play Console](https://play.google.com/console)
- [App Store Connect](https://appstoreconnect.apple.com)
- [Apple Developer](https://developer.apple.com)
- [Fastlane 문서](https://docs.fastlane.tools/)
- [Flutter 배포 가이드](https://docs.flutter.dev/deployment)

### 다음 단계

1. ✅ Keystore/인증서 설정 완료
2. ✅ 빌드 스크립트 테스트
3. ✅ Fastlane 설정 (선택사항)
4. ✅ CI/CD 워크플로우 설정 (선택사항)
5. ✅ 스크린샷 및 아이콘 준비
6. ✅ 앱 스토어에 제출
7. ✅ 심사 대기 및 피드백 반영
