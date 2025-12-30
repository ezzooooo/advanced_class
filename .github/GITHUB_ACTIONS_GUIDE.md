# GitHub Actions 찾기 가이드

## 1. 공식 마켓플레이스 (가장 권장)

**URL**: https://github.com/marketplace?type=actions

### 특징:
- 수천 개의 검증된 액션 제공
- 검색 기능 제공
- 사용량, 별점, 최근 업데이트 정보 확인 가능
- 공식 액션과 커뮤니티 액션 모두 포함

### 사용 방법:
1. 브라우저에서 https://github.com/marketplace?type=actions 접속
2. 검색창에 원하는 기능 입력 (예: "flutter", "docker", "deploy")
3. 액션 선택 후 사용법 확인
4. README에서 사용 예제 복사

## 2. GitHub 저장소에서 직접 검색

**URL**: https://github.com/search?q=&type=actions

### 검색 팁:
- `language:yaml` 필터 사용
- `topic:github-actions` 필터 사용
- 예: `flutter action` 검색

## 3. 주요 공식 액션들

### 기본 액션 (GitHub 공식)
- `actions/checkout@v4` - 코드 체크아웃
- `actions/setup-node@v4` - Node.js 설정
- `actions/setup-java@v4` - Java 설정
- `actions/setup-python@v5` - Python 설정
- `actions/upload-artifact@v4` - 아티팩트 업로드
- `actions/download-artifact@v4` - 아티팩트 다운로드

### Flutter 관련
- `subosito/flutter-action@v2` - Flutter SDK 설치
- `flutter/github-actions@v1` - Flutter 공식 액션 (선택사항)

### 배포 관련
- `peaceiris/actions-gh-pages@v3` - GitHub Pages 배포
- `appleboy/ssh-action@v1` - SSH 배포
- `docker/build-push-action@v5` - Docker 빌드/푸시

### 테스트/코드 품질
- `codecov/codecov-action@v4` - 코드 커버리지 업로드
- `sonarsource/sonarcloud-github-action@master` - SonarCloud 분석

## 4. 액션 선택 시 확인사항

### ✅ 좋은 액션의 특징:
- ⭐ 높은 별점 (100+)
- 📅 최근 업데이트 (6개월 이내)
- 📖 명확한 README 문서
- 🏷️ 버전 태그 사용 (v1, v2 등)
- 🔒 공식 액션 또는 검증된 커뮤니티 액션

### ⚠️ 주의사항:
- `@master` 또는 `@main` 태그는 피하는 것이 좋음 (변경될 수 있음)
- 버전 태그 사용 권장 (`@v1`, `@v2` 등)
- 사용량이 적은 액션은 신중하게 검토

## 5. 현재 프로젝트에서 사용 중인 액션들

현재 `ci.yml`에서 사용 중인 액션들:

```yaml
- actions/checkout@v4          # 코드 체크아웃
- subosito/flutter-action@v2   # Flutter SDK 설치
- actions/setup-java@v4         # Java 설정 (Android 빌드용)
- codecov/codecov-action@v4    # 코드 커버리지 업로드
- actions/upload-artifact@v4   # 빌드 결과물 업로드
```

## 6. 액션 사용 예제

### 액션 페이지에서 확인할 정보:
1. **버전**: 최신 안정 버전 확인
2. **Inputs**: 사용 가능한 입력 파라미터
3. **Outputs**: 액션이 반환하는 값
4. **Examples**: 사용 예제 코드

### 예시 - Flutter Action:
```yaml
- uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.38.5'
    channel: 'stable'
    cache: true
```

## 7. 액션 버전 관리

### 권장 방식:
- 특정 버전 사용: `@v2` (마이너 버전)
- 특정 커밋 사용: `@abc123def` (고정, 하지만 업데이트 어려움)
- 브랜치 사용: `@main` (비권장, 변경될 수 있음)

### 예시:
```yaml
# ✅ 좋은 예
uses: actions/checkout@v4

# ⚠️ 나쁜 예
uses: actions/checkout@main
```

## 8. 액션 검색 팁

### 검색 키워드 예시:
- "flutter setup" → Flutter 설치 액션
- "docker build" → Docker 빌드 액션
- "deploy aws" → AWS 배포 액션
- "test coverage" → 커버리지 관련 액션
- "notify slack" → Slack 알림 액션

## 9. 커스텀 액션 만들기

필요한 액션이 없다면 직접 만들 수도 있습니다:
- JavaScript/TypeScript 액션
- Docker 컨테이너 액션
- Composite 액션 (여러 step 조합)

## 10. 유용한 링크

- 마켓플레이스: https://github.com/marketplace?type=actions
- GitHub Actions 문서: https://docs.github.com/en/actions
- 액션 개발 가이드: https://docs.github.com/en/actions/creating-actions

