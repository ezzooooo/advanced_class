# 5주차: Push Notification (FCM)

## 학습 목표
- FCM 동작 원리 이해
- 알림 상태별 처리 (Foreground/Background/Terminated)
- 토픽 구독 구현
- 딥링크 처리

## Firebase 설정 방법

### 1. Firebase 프로젝트 생성
1. https://console.firebase.google.com
2. 프로젝트 추가
3. Android/iOS 앱 등록

### 2. Android 설정

#### google-services.json
`android/app/google-services.json`에 배치

#### build.gradle.kts (프로젝트 레벨)
```kotlin
plugins {
    id("com.google.gms.google-services") version "4.4.0" apply false
}
```

#### build.gradle.kts (앱 레벨)
```kotlin
plugins {
    id("com.google.gms.google-services")
}
```

### 3. iOS 설정

#### GoogleService-Info.plist
Xcode에서 Runner 프로젝트에 추가

#### AppDelegate.swift
```swift
import Firebase

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
  override func application(...) -> Bool {
    FirebaseApp.configure()
    // ...
  }
}
```

#### Capabilities 추가
- Push Notifications
- Background Modes → Remote notifications

## 주요 파일

### services/fcm_service.dart
FCM 초기화 및 메시지 처리 서비스

### screens/notification_demo_screen.dart
푸시 알림 테스트 화면

## main.dart 수정

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'week5_push_notification/services/fcm_service.dart';

// Background 핸들러 등록
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Background 핸들러 설정 (Firebase 초기화 전에!)
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  // FCM 초기화
  await FCMService().initialize();
  
  runApp(const MyApp());
}
```

## 알림 데이터 구조

### Notification Message
```json
{
  "notification": {
    "title": "새 메시지",
    "body": "홍길동님이 메시지를 보냈습니다"
  },
  "data": {
    "type": "chat",
    "roomId": "123"
  }
}
```

### Data-only Message
```json
{
  "data": {
    "type": "silent",
    "action": "sync"
  }
}
```

## 테스트 방법

### Firebase Console
1. Cloud Messaging 메뉴
2. 첫 번째 캠페인 만들기
3. 알림 제목/내용 입력
4. 대상 선택 (앱 또는 토픽)
5. 게시

### curl 명령어 (서버 키 필요)
```bash
curl -X POST \
  https://fcm.googleapis.com/fcm/send \
  -H 'Authorization: key=YOUR_SERVER_KEY' \
  -H 'Content-Type: application/json' \
  -d '{
    "to": "FCM_TOKEN",
    "notification": {
      "title": "테스트",
      "body": "테스트 메시지입니다"
    }
  }'
```

