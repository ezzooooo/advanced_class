// 7주차: 앱 보안 - 환경별 설정
//
// --dart-define을 활용한 환경 분리
//
// 빌드 명령어:
// - 개발: flutter run --dart-define=ENV=dev
// - 스테이징: flutter run --dart-define=ENV=staging
// - 프로덕션: flutter run --dart-define=ENV=prod

enum Environment { dev, staging, prod }

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  // 환경 변수에서 읽어오기
  static const String _envString = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  // 현재 환경
  Environment get environment {
    switch (_envString) {
      case 'prod':
        return Environment.prod;
      case 'staging':
        return Environment.staging;
      default:
        return Environment.dev;
    }
  }

  // 환경별 API Base URL
  String get apiBaseUrl {
    switch (environment) {
      case Environment.prod:
        return 'https://api.example.com';
      case Environment.staging:
        return 'https://staging-api.example.com';
      case Environment.dev:
        return 'https://dev-api.example.com';
    }
  }

  // 환경별 앱 이름
  String get appName {
    switch (environment) {
      case Environment.prod:
        return 'My App';
      case Environment.staging:
        return 'My App (Staging)';
      case Environment.dev:
        return 'My App (Dev)';
    }
  }

  // 개발 환경인지 확인
  bool get isDev => environment == Environment.dev;

  // 프로덕션 환경인지 확인
  bool get isProd => environment == Environment.prod;

  // 로깅 활성화 여부
  bool get enableLogging => environment != Environment.prod;

  // 디버그 배너 표시 여부
  bool get showDebugBanner => environment == Environment.dev;

  @override
  String toString() {
    return '''
AppConfig {
  environment: $environment
  apiBaseUrl: $apiBaseUrl
  appName: $appName
  enableLogging: $enableLogging
}''';
  }
}

/// 환경별 Firebase 옵션 (예시)
class FirebaseConfig {
  static String get projectId {
    switch (AppConfig().environment) {
      case Environment.prod:
        return 'my-app-prod';
      case Environment.staging:
        return 'my-app-staging';
      case Environment.dev:
        return 'my-app-dev';
    }
  }

  // 다른 Firebase 설정들...
}

