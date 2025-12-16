import 'package:flutter/material.dart';

import '../services/fcm_service.dart';

/// 5주차: Push Notification - 데모 화면
class NotificationDemoScreen extends StatefulWidget {
  const NotificationDemoScreen({super.key});

  @override
  State<NotificationDemoScreen> createState() => _NotificationDemoScreenState();
}

class _NotificationDemoScreenState extends State<NotificationDemoScreen> {
  final FCMService _fcmService = FCMService();
  String? _token;
  final List<String> _subscribedTopics = [];

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await _fcmService.getToken();
    setState(() => _token = token);
  }

  Future<void> _subscribeTopic(String topic) async {
    await _fcmService.subscribeToTopic(topic);
    setState(() {
      if (!_subscribedTopics.contains(topic)) {
        _subscribedTopics.add(topic);
      }
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$topic 토픽 구독 완료')),
      );
    }
  }

  Future<void> _unsubscribeTopic(String topic) async {
    await _fcmService.unsubscribeFromTopic(topic);
    setState(() => _subscribedTopics.remove(topic));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$topic 토픽 구독 해제')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notification Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FCM 토큰 섹션
            _buildSection(
              title: 'FCM 토큰',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    _token ?? '로딩 중...',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _loadToken,
                    icon: const Icon(Icons.refresh),
                    label: const Text('토큰 새로고침'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 토픽 구독 섹션
            _buildSection(
              title: '토픽 구독',
              child: Column(
                children: [
                  _buildTopicTile('news', '뉴스 알림'),
                  _buildTopicTile('events', '이벤트 알림'),
                  _buildTopicTile('updates', '업데이트 알림'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 알림 상태 설명
            _buildSection(
              title: '알림 상태별 동작',
              child: const Column(
                children: [
                  _StatusExplanation(
                    state: 'Foreground',
                    description: '앱이 열려있는 상태',
                    behavior: '로컬 알림으로 표시',
                    icon: Icons.phone_android,
                    color: Colors.green,
                  ),
                  SizedBox(height: 12),
                  _StatusExplanation(
                    state: 'Background',
                    description: '앱이 백그라운드에 있는 상태',
                    behavior: '시스템 알림으로 표시',
                    icon: Icons.phone_locked,
                    color: Colors.orange,
                  ),
                  SizedBox(height: 12),
                  _StatusExplanation(
                    state: 'Terminated',
                    description: '앱이 완전히 종료된 상태',
                    behavior: '시스템 알림 → 앱 실행 시 처리',
                    icon: Icons.power_off,
                    color: Colors.red,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 테스트 방법 안내
            _buildSection(
              title: '테스트 방법',
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. Firebase Console → Cloud Messaging'),
                  Text('2. "새 캠페인" 클릭'),
                  Text('3. 제목/내용 입력'),
                  Text('4. 대상: 앱 선택 또는 토픽 선택'),
                  Text('5. "검토" → "게시"'),
                  SizedBox(height: 12),
                  Text(
                    '또는 위의 FCM 토큰을 복사하여\nFirebase Console에서 테스트 메시지 전송',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _buildTopicTile(String topic, String label) {
    final isSubscribed = _subscribedTopics.contains(topic);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isSubscribed ? Icons.notifications_active : Icons.notifications_off,
        color: isSubscribed ? Colors.green : Colors.grey,
      ),
      title: Text(label),
      subtitle: Text(topic),
      trailing: Switch(
        value: isSubscribed,
        onChanged: (value) {
          if (value) {
            _subscribeTopic(topic);
          } else {
            _unsubscribeTopic(topic);
          }
        },
      ),
    );
  }
}

class _StatusExplanation extends StatelessWidget {
  const _StatusExplanation({
    required this.state,
    required this.description,
    required this.behavior,
    required this.icon,
    required this.color,
  });

  final String state;
  final String description;
  final String behavior;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                description,
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                '→ $behavior',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

