import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// 5주차: Push Notification - FCM 서비스
///
/// Firebase Cloud Messaging을 활용한 푸시 알림 구현
///
/// 알림 상태:
/// - Foreground: 앱이 열려있는 상태
/// - Background: 앱이 백그라운드에 있는 상태
/// - Terminated: 앱이 완전히 종료된 상태

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // 알림 채널 (Android)
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    '중요 알림',
    description: '중요한 알림을 표시합니다',
    importance: Importance.high,
  );

  /// FCM 초기화
  Future<void> initialize() async {
    // Firebase 초기화
    await Firebase.initializeApp();

    // 알림 권한 요청
    await _requestPermission();

    // 로컬 알림 초기화
    await _initializeLocalNotifications();

    // FCM 토큰 획득
    await _getToken();

    // 메시지 리스너 설정
    _setupMessageHandlers();

    debugPrint('✅ FCM Service initialized');
  }

  /// 알림 권한 요청
  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint('알림 권한 상태: ${settings.authorizationStatus}');
  }

  /// 로컬 알림 초기화
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Android 알림 채널 생성
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  /// FCM 토큰 획득
  Future<String?> _getToken() async {
    final token = await _messaging.getToken();
    debugPrint('📱 FCM Token: $token');

    // 토큰 갱신 리스너
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('📱 FCM Token refreshed: $newToken');
      // TODO: 서버에 새 토큰 전송
    });

    return token;
  }

  /// 메시지 핸들러 설정
  void _setupMessageHandlers() {
    // Foreground 메시지 처리
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background/Terminated 상태에서 알림 탭 처리
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // 앱이 종료된 상태에서 알림으로 시작된 경우
    _checkInitialMessage();
  }

  /// Foreground 메시지 처리
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('📩 Foreground message received: ${message.messageId}');
    debugPrint('   Title: ${message.notification?.title}');
    debugPrint('   Body: ${message.notification?.body}');
    debugPrint('   Data: ${message.data}');

    // Foreground에서는 로컬 알림으로 표시
    if (message.notification != null) {
      await _showLocalNotification(message);
    }
  }

  /// 로컬 알림 표시
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          icon: '@mipmap/ic_launcher',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data.toString(),
    );
  }

  /// 알림 탭 시 앱이 열린 경우
  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('📩 Message opened app: ${message.messageId}');
    debugPrint('   Data: ${message.data}');

    // TODO: 딥링크 처리
    _handleDeepLink(message.data);
  }

  /// 앱 시작 시 초기 메시지 확인
  Future<void> _checkInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('📩 Initial message: ${initialMessage.messageId}');
      _handleDeepLink(initialMessage.data);
    }
  }

  /// 딥링크 처리
  void _handleDeepLink(Map<String, dynamic> data) {
    // 데이터 기반 화면 이동
    final type = data['type'];
    final id = data['id'];

    debugPrint('🔗 Deep link: type=$type, id=$id');

    // TODO: 실제 네비게이션 구현
    // 예: Navigator.pushNamed(context, '/$type/$id');
  }

  /// 알림 탭 처리 (로컬 알림)
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('🔔 Notification tapped: ${response.payload}');
    // TODO: payload 파싱 후 화면 이동
  }

  // ===============================
  // 토픽 구독 관련
  // ===============================

  /// 토픽 구독
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    debugPrint('✅ Subscribed to topic: $topic');
  }

  /// 토픽 구독 해제
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    debugPrint('❌ Unsubscribed from topic: $topic');
  }

  /// 현재 FCM 토큰 가져오기
  Future<String?> getToken() async {
    return _messaging.getToken();
  }
}

/// Background 메시지 핸들러 (최상위 함수)
///
/// ⚠️ 이 함수는 반드시 최상위(top-level)이어야 합니다!
/// 클래스 메서드나 익명 함수는 사용할 수 없습니다.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('📩 Background message: ${message.messageId}');
  // Background에서 할 작업 수행
}

