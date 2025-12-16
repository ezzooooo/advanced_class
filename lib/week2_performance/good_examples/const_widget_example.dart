import 'package:flutter/material.dart';

/// 2주차: 성능 최적화 - const 위젯 활용 예제
///
/// const 생성자가 성능에 미치는 영향을 보여줍니다.

/// const 위젯의 장점:
/// 1. 컴파일 타임에 인스턴스 생성 → 런타임 오버헤드 없음
/// 2. 동일한 const 위젯은 같은 인스턴스 공유
/// 3. rebuild 시 위젯 트리 비교 최적화

class ConstWidgetDemo extends StatefulWidget {
  const ConstWidgetDemo({super.key});

  @override
  State<ConstWidgetDemo> createState() => _ConstWidgetDemoState();
}

class _ConstWidgetDemoState extends State<ConstWidgetDemo> {
  int _rebuildCount = 0;

  @override
  Widget build(BuildContext context) {
    _rebuildCount++;

    return Scaffold(
      appBar: AppBar(
        title: const Text('const Widget 데모'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '부모 위젯 rebuild 횟수: $_rebuildCount',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // ✅ const 위젯 - 같은 인스턴스 공유
            const Text(
              '✅ const Text - rebuild 시에도 같은 인스턴스',
              style: TextStyle(color: Colors.green),
            ),
            const SizedBox(height: 8),

            // ✅ const 컨테이너
            const _ConstInfoCard(
              title: 'const 위젯',
              description: '컴파일 타임에 생성되어 rebuild 시 재생성되지 않음',
              color: Colors.green,
            ),
            const SizedBox(height: 16),

            // ❌ non-const 위젯 - 매번 새 인스턴스 생성
            _NonConstInfoCard(
              title: 'non-const 위젯',
              description: '매번 새로운 인스턴스가 생성됨',
              color: Colors.red,
            ),
            const SizedBox(height: 24),

            // 동일한 const 위젯이 같은 인스턴스인지 확인
            const _IdentityChecker(),

            const Spacer(),

            Center(
              child: ElevatedButton(
                onPressed: () => setState(() {}),
                child: const Text('Rebuild 트리거'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ const 생성자를 가진 위젯
class _ConstInfoCard extends StatelessWidget {
  const _ConstInfoCard({
    required this.title,
    required this.description,
    required this.color,
  });

  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    print('🟢 _ConstInfoCard build(): $title');

    return Card(
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(description),
          ],
        ),
      ),
    );
  }
}

/// ❌ non-const 위젯 (비교용)
class _NonConstInfoCard extends StatelessWidget {
  _NonConstInfoCard({
    required this.title,
    required this.description,
    required this.color,
  }) {
    print('🔴 _NonConstInfoCard 생성자 호출: $title');
  }

  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    print('🔴 _NonConstInfoCard build(): $title');

    return Card(
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(description),
          ],
        ),
      ),
    );
  }
}

/// 동일한 const 위젯이 같은 인스턴스인지 확인
class _IdentityChecker extends StatelessWidget {
  const _IdentityChecker();

  @override
  Widget build(BuildContext context) {
    // 두 const 위젯이 같은 인스턴스인지 확인
    const widget1 = SizedBox(height: 10);
    const widget2 = SizedBox(height: 10);

    final isSameInstance = identical(widget1, widget2);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔬 인스턴스 동일성 테스트',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('const SizedBox(height: 10) 두 개가 같은 인스턴스?'),
            Text(
              isSameInstance ? '✅ 예! (identical)' : '❌ 아니오',
              style: TextStyle(
                color: isSameInstance ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

