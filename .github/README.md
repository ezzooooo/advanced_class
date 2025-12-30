# 3주차: CI/CD 파이프라인

## 학습 목표

- CI/CD 개념 이해
- GitHub Actions workflow 작성
- 자동화된 테스트/빌드 환경 구축

## CI/CD

CI/CD는 **코드 변경을 더 빠르고, 더 안전하게, 반복 가능하게 배포하기 위한 개발·배포 자동화 개념**이야.
개념을 정확히 나눠서 설명할게.

---

## 1️⃣ CI (Continuous Integration, 지속적 통합)

### 핵심 개념

> 여러 개발자가 작업한 코드를 **자주(main 브랜치에) 병합**하고,
> 병합 시점마다 **자동으로 검증(빌드·테스트)** 하는 것

### 왜 필요한가

- 코드 병합이 늦어질수록

  - 충돌 증가
  - 원인 추적 어려움

- CI는 **문제가 생기면 즉시 알 수 있게** 해줌

### CI에서 자동으로 하는 일

보통 커밋 또는 PR 기준으로 실행됨

1. 코드 체크아웃
2. 빌드
3. 정적 분석 (lint)
4. 테스트 실행 (unit / widget / integration)
5. 결과 리포트

### CI 실패 시

- PR 머지 불가
- 문제 발생 지점을 **가장 최근 변경 코드**에서 바로 확인 가능

### Flutter 예시

- `flutter analyze`
- `flutter test`
- `flutter build` (옵션)

---

## 2️⃣ CD (Continuous Delivery / Continuous Deployment)

CD는 **두 가지 의미**로 쓰여서 헷갈리기 쉬워.

---

### 2-1️⃣ Continuous Delivery (지속적 전달)

> **언제든 배포 가능한 상태**로 만들어 두는 것
> (배포는 사람이 버튼을 누름)

#### 특징

- CI 통과 후

  - 앱 빌드
  - 스토어 업로드 파일 생성

- **실제 배포는 수동 승인**

#### 많이 쓰는 이유

- 모바일 앱 (App Store / Play Store 심사)
- QA 검증 단계 필요

---

### 2-2️⃣ Continuous Deployment (지속적 배포)

> CI 통과하면 **자동으로 바로 배포까지**

#### 특징

- 사람 개입 없음
- 서버/웹 서비스에서 주로 사용

---

## 3️⃣ CI/CD 전체 흐름 요약

```text
코드 작성
 ↓
git push / PR 생성
 ↓
CI
- build
- test
- lint
 ↓
CD
- 앱 빌드
- 배포 파일 생성
- (자동 or 수동 배포)
```

---

## 4️⃣ CI/CD를 도입했을 때 얻는 것

### 개발 관점

- 버그 조기 발견
- 리뷰 신뢰도 증가
- "내 로컬에서는 됐는데요?" 제거

### 팀 관점

- 배포 과정 표준화
- 특정 사람 의존도 제거
- 신규 인원 온보딩 쉬워짐

---

## 5️⃣ Flutter 개발 기준으로 정리하면

| 단계 | 역할                             |
| ---- | -------------------------------- |
| CI   | 코드 품질 보장 (analyze, test)   |
| CD   | apk/aab/ipa 생성 및 배포 자동화  |
| 목적 | **실수 없는 배포 + 빠른 피드백** |

---

## 6️⃣ 한 줄 요약 (수강생용)

> **CI는 “코드가 괜찮은지 자동으로 검사하는 과정”,
> CD는 “검증된 코드를 배포까지 자동으로 이어주는 과정”**

---

원하면 다음도 이어서 설명해줄 수 있어:

- GitHub Actions 기준 CI/CD 구성
- Flutter 프로젝트에 최소 CI 구성 예시
- 수강생 교육용 슬라이드 구조 정리

## 파일 설명

### .github/workflows/ci.yml

PR/Push 시 자동 실행되는 CI 파이프라인

- 코드 분석 (flutter analyze)
- 테스트 실행 (flutter test)
- Android/iOS/Web 빌드

### .github/workflows/release.yml

태그 생성 시 Release 빌드 생성

- Release APK/AAB 빌드
- GitHub Release 생성

## GitHub Secrets 설정 방법

### 1. Keystore 생성

```bash
# Keystore 생성
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# Base64 인코딩
base64 -i upload-keystore.jks
```

### 2. GitHub Secrets 등록

Repository Settings → Secrets and variables → Actions에서 추가:

#### KEYSTORE_BASE64

```
(Keystore의 Base64 인코딩 값)
```

#### KEY_PROPERTIES

```
storePassword=<keystore-password>
keyPassword=<key-password>
keyAlias=upload
storeFile=upload-keystore.jks
```

## Workflow 실행 확인

1. GitHub Repository → Actions 탭
2. 실행 중인 workflow 확인
3. 각 Job의 로그 확인
4. Artifacts에서 빌드 결과물 다운로드

## 주요 개념

### Job

하나의 가상 머신에서 실행되는 작업 단위

### Step

Job 내에서 순차적으로 실행되는 개별 명령

### Workflow

여러 Job으로 구성된 자동화 프로세스

### Trigger (on:)

- `push`: 특정 브랜치에 push 시
- `pull_request`: PR 생성/업데이트 시
- `workflow_dispatch`: 수동 실행
- `schedule`: 스케줄 기반 (cron)
- `tags`: 태그 생성 시
