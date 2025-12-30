# 2주차: 앱 성능 최적화

## 학습 목표
- Flutter 렌더링 원리 이해 (Widget → Element → RenderObject)
- 불필요한 rebuild 방지
- const 생성자 활용
- RepaintBoundary 적용

## 파일 설명

### bad_examples/
성능 문제가 있는 안티패턴 예제들

### good_examples/
최적화가 적용된 베스트 프랙티스 예제들

## DevTools 사용법

```bash
flutter run --profile
# 또는
flutter run --debug

# DevTools 열기
flutter pub global activate devtools
flutter pub global run devtools
```

## 주요 최적화 기법

1. **const 생성자 사용**
   - 불변 위젯은 const로 선언
   - 컴파일 타임에 인스턴스 생성

2. **RepaintBoundary**
   - 독립적으로 다시 그려져야 하는 영역 분리
   - 애니메이션 영역에 적용

3. **ListView.builder**
   - 보이는 항목만 렌더링
   - 대량의 목록에 필수
   - 이미지 리스트에 특히 효과적

4. **적절한 상태 관리**
   - 필요한 부분만 rebuild
   - 상태 범위 최소화

5. **이미지 최적화**
   - 네트워크 이미지 자동 캐싱
   - loadingBuilder로 로딩 상태 표시
   - errorBuilder로 에러 처리
   - cacheExtent로 미리 로딩 범위 설정

## 네트워크 권한 설정

macOS에서 인터넷 이미지를 사용하려면:

**macos/Runner/DebugProfile.entitlements 및 Release.entitlements:**
```xml
<key>com.apple.security.network.client</key>
<true/>
```

