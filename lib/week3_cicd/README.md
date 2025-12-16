# 3주차: CI/CD 파이프라인

## 학습 목표
- CI/CD 개념 이해
- GitHub Actions workflow 작성
- 자동화된 테스트/빌드 환경 구축

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

