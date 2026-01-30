# 스크린샷 제작 가이드

## 스크린샷 캡처 방법

### Android 에뮬레이터 사용

```bash
# 1. 에뮬레이터 목록 확인
flutter emulators

# 2. 에뮬레이터 실행
flutter emulators --launch <emulator_id>

# 3. 앱 실행
flutter run

# 4. 스크린샷 캡처
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png
```

### iOS 시뮬레이터 사용

```bash
# 1. 시뮬레이터 실행
open -a Simulator

# 2. 앱 실행
flutter run

# 3. 스크린샷 캡처
xcrun simctl io booted screenshot screenshot.png
```

### 실제 기기 사용

**Android**:
- 전원 버튼 + 볼륨 다운 버튼 동시 누르기
- 또는 ADB: `adb shell screencap -p /sdcard/screenshot.png`

**iOS**:
- iPhone X 이상: 볼륨 업 + 전원 버튼
- iPhone 8 이하: 전원 버튼 + 홈 버튼

## 스크린샷 편집 도구

### 온라인 도구
- [App Store Screenshot Generator](https://www.appstorescreenshot.com/)
- [Screenshot Framer](https://screenshotframer.com/)

### 디자인 도구
- Figma (템플릿 활용)
- Adobe Photoshop
- Sketch

## 스크린샷 디자인 템플릿

### Figma 템플릿
- [App Store Screenshot Templates](https://www.figma.com/community/tag/app%20store%20screenshots)
- [Play Store Screenshot Templates](https://www.figma.com/community/tag/play%20store%20screenshots)

## 자동화 도구

### screenshots 패키지 사용

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

