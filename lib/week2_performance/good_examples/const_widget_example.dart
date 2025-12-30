import 'package:advanced_class/main.dart';
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
      appBar: AppBar(title: const Text('const Widget 데모')),
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
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
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
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
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
    // ❌ Case 1: Key factory constructor 사용 → 다른 인스턴스!
    Widget withKey1 = const MyWidget();
    Widget withKey2 = const MyWidget();

    // ✅ Case 2: ValueKey 직접 사용 → 같은 인스턴스!
    Widget withValueKey1 = const MyWidget(key: ValueKey('widget'));
    Widget withValueKey2 = const MyWidget(key: ValueKey('widget'));

    // ✅ Case 3: Key 없음 → 같은 인스턴스!
    Widget noKey1 = const MyWidget();
    Widget noKey2 = const MyWidget();

    const textA = Text('Hello');
    const textB = Text('Hello');

    final results = [
      _TestResult(
        name: 'Key("widget") 사용',
        code: 'const SizedBox(key: Key("widget"))',
        widget1: withKey1,
        widget2: withKey2,
      ),
      _TestResult(
        name: 'ValueKey("widget") 사용',
        code: 'const SizedBox(key: ValueKey("widget"))',
        widget1: withValueKey1,
        widget2: withValueKey2,
      ),
      _TestResult(
        name: 'Key 없음',
        code: 'const SizedBox(height: 10)',
        widget1: noKey1,
        widget2: noKey2,
      ),
      _TestResult(
        name: 'Text("Hello")',
        code: 'const Text("Hello")',
        widget1: textA,
        widget2: textB,
      ),
    ];

    for (final r in results) {
      print(
        '🔬 ${r.name}: identical=${r.isIdentical}, addr1=${r.addr1}, addr2=${r.addr2}',
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🔬 const 위젯 메모리 주소 비교',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              ...results.map((r) => _buildResultRow(r)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(_TestResult r) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            r.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: r.isIdentical ? Colors.green : Colors.red,
            ),
          ),
          Text(
            r.code,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
          ),
          Text(
            '주소1: 0x${r.addr1.toRadixString(16).toUpperCase()}',
            style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
          ),
          Text(
            '주소2: 0x${r.addr2.toRadixString(16).toUpperCase()}',
            style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
          ),
          Text(
            r.isIdentical ? '✅ 같은 메모리!' : '❌ 다른 메모리',
            style: TextStyle(
              color: r.isIdentical ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class _TestResult {
  final String name;
  final String code;
  final Widget widget1;
  final Widget widget2;

  _TestResult({
    required this.name,
    required this.code,
    required this.widget1,
    required this.widget2,
  });

  int get addr1 => identityHashCode(widget1);
  int get addr2 => identityHashCode(widget2);
  bool get isIdentical => identical(widget1, widget2);
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AddTodoBottomSheet(title: 'title', saveTodo: (todo) {});
  }
}

class AddTodoBottomSheet extends StatefulWidget {
  const AddTodoBottomSheet({
    super.key,
    required this.title,
    required this.saveTodo,
  });

  final String title;
  final void Function(TodoEntity todo) saveTodo;

  @override
  State<AddTodoBottomSheet> createState() => _AddTodoBottomSheetState();
}

class _AddTodoBottomSheetState extends State<AddTodoBottomSheet> {
  bool isFavorite = false;
  bool showDescription = false;
  String title = '';

  @override
  Widget build(BuildContext context) {
    return TextField(); // TextField의 값이 바뀔 때 title 변수에 할당을 해줘야 해요
  }

  void a() {
    setState(() {
      showDescription = !showDescription;
    });
  }
}
