# 앱 아이콘 제작 가이드

## 아이콘 크기 요구사항

### Android
- Play Store: 512x512 PNG
- Adaptive Icon: 192x192 PNG (foreground)
- Adaptive Icon Background: 144x144 PNG (선택사항)

### iOS
- App Store: 1024x1024 PNG
- iPhone: 180x180, 120x120 PNG
- iPad: 152x152, 76x76 PNG

## 디자인 가이드라인

1. **단순하고 명확하게**
   - 작은 크기에서도 알아볼 수 있어야 함
   - 복잡한 디테일 피하기

2. **브랜드 일관성**
   - 앱의 색상과 스타일 유지
   - 로고나 심볼 활용

3. **투명도 금지**
   - Play Store와 App Store 모두 투명도 없는 PNG 필수

## 아이콘 제작 도구

### 온라인 도구
- [App Icon Generator](https://www.appicon.co/)
- [Icon Kitchen](https://icon.kitchen/) (Android)
- [MakeAppIcon](https://makeappicon.com/)

### 디자인 도구
- Figma
- Adobe Illustrator
- Sketch

## flutter_launcher_icons 사용

```yaml
# pubspec.yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon.png"  # 1024x1024 원본 이미지
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/icon/icon_foreground.png"
```

```bash
# 아이콘 생성
flutter pub get
flutter pub run flutter_launcher_icons
```

## 아이콘 제작 체크리스트

- [ ] 1024x1024 원본 이미지 준비
- [ ] 투명도 없는 PNG 형식
- [ ] 작은 크기에서도 명확하게 보임
- [ ] 브랜드 색상과 일치
- [ ] 플랫폼별 크기 자동 생성 확인

