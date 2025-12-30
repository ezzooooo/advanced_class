# 브랜치 보호 규칙 설정 가이드

## GitHub 웹 UI를 통한 설정 방법

### 1단계: 저장소 설정 페이지로 이동

1. GitHub 저장소 페이지로 이동
2. 상단 메뉴에서 **Settings** 클릭
3. 왼쪽 사이드바에서 **Branches** 클릭

### 2단계: 브랜치 보호 규칙 추가

1. **Add branch protection rule** 또는 **Add rule** 버튼 클릭
2. **Branch name pattern**에 `main` 입력
3. 다음 옵션들을 체크:
   - ✅ **Require a pull request before merging**
     - ✅ **Require approvals**: 1 (또는 원하는 승인자 수)
   - ✅ **Require status checks to pass before merging**
     - ✅ **Require branches to be up to date before merging**
     - 아래에서 다음 체크박스들을 선택:
       - ✅ `analyze-and-test` (분석 & 테스트)
       - ✅ `build-android` (Android 빌드)
       - ✅ `build-ios` (iOS 빌드) - 선택사항
       - ✅ `build-web` (Web 빌드)
   - ✅ **Do not allow bypassing the above settings** (선택사항, 관리자도 우회 불가)
4. **Create** 또는 **Save changes** 클릭

### 3단계: develop 브랜치에도 동일하게 설정

1. 다시 **Add branch protection rule** 클릭
2. **Branch name pattern**에 `develop` 입력
3. main과 동일한 설정 적용
4. **Create** 또는 **Save changes** 클릭

## 설정 후 동작 방식

- PR 생성 시: CI가 자동으로 실행되고, 모든 체크가 통과해야만 merge 가능
- 직접 push 시도: 보호된 브랜치에 직접 push하려고 하면 GitHub에서 차단
- CI 실패 시: PR 페이지에 빨간색 X 표시, merge 버튼 비활성화

## 참고사항

- CI 워크플로우 이름: `Flutter CI`
- 필수 Job 이름들:
  - `analyze-and-test` (분석 & 테스트)
  - `build-android` (Android 빌드)
  - `build-ios` (iOS 빌드) - 선택사항
  - `build-web` (Web 빌드)
