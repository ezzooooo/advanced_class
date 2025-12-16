import 'package:flutter/material.dart';

/// 2주차: 성능 최적화 - 최적화된 rebuild 예제 (베스트 프랙티스)
///
/// 이 예제는 불필요한 rebuild를 방지하는 방법을 보여줍니다.

/// ✅ 베스트 프랙티스: 변경되는 부분만 rebuild
class GoodCounterPage extends StatefulWidget {
  const GoodCounterPage({super.key});

  @override
  State<GoodCounterPage> createState() => _GoodCounterPageState();
}

class _GoodCounterPageState extends State<GoodCounterPage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    print('🟢 GoodCounterPage build() 호출됨');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Good Example - 최적화된 Rebuild'),
      ),
      body: Column(
        children: [
          // ✅ const 위젯은 rebuild되지 않음
          const HeavyWidgetOptimized(),

          // ✅ const를 사용하여 불변 위젯 표시
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '이 텍스트는 const이므로 rebuild되지 않습니다',
              style: TextStyle(fontSize: 16),
            ),
          ),

          // ✅ 변경되는 부분만 별도 위젯으로 분리
          _CounterDisplay(counter: _counter),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _counter++),
        child: const Icon(Icons.add), // ✅ const 사용
      ),
    );
  }
}

/// ✅ const 생성자를 사용한 무거운 위젯
class HeavyWidgetOptimized extends StatelessWidget {
  const HeavyWidgetOptimized({super.key});

  @override
  Widget build(BuildContext context) {
    print('🟢 HeavyWidgetOptimized build() 호출됨');

    return Container(
      height: 100,
      color: Colors.green.shade100,
      child: const Center(
        child: Text('Heavy Widget (Optimized)'),
      ),
    );
  }
}

/// ✅ 변경되는 부분을 별도 위젯으로 분리
class _CounterDisplay extends StatelessWidget {
  const _CounterDisplay({required this.counter});

  final int counter;

  @override
  Widget build(BuildContext context) {
    print('🟢 _CounterDisplay build() 호출됨 - counter: $counter');

    return Text(
      'Counter: $counter',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

/// ✅ 베스트 프랙티스: ListView.builder 사용
class GoodListExample extends StatelessWidget {
  const GoodListExample({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ 보이는 항목만 렌더링
    return ListView.builder(
      itemCount: 1000,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Item $index'),
        );
      },
    );
  }
}

/// ✅ 콜백 함수 최적화
class GoodObjectCreation extends StatefulWidget {
  const GoodObjectCreation({super.key});

  @override
  State<GoodObjectCreation> createState() => _GoodObjectCreationState();
}

class _GoodObjectCreationState extends State<GoodObjectCreation> {
  // ✅ 클래스 레벨에서 정의
  static const List<String> _items = ['A', 'B', 'C'];

  // ✅ 메서드로 정의하여 재사용
  void _handleTap(String item) {
    print('Tapped: $item');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _items
          .map(
            (item) => ElevatedButton(
              onPressed: () => _handleTap(item),
              child: Text(item),
            ),
          )
          .toList(),
    );
  }
}

/// ✅ RepaintBoundary로 애니메이션 영역 분리
class RepaintBoundaryExample extends StatefulWidget {
  const RepaintBoundaryExample({super.key});

  @override
  State<RepaintBoundaryExample> createState() => _RepaintBoundaryExampleState();
}

class _RepaintBoundaryExampleState extends State<RepaintBoundaryExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ✅ 애니메이션 영역을 RepaintBoundary로 감싸기
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * 3.14159,
                child: child,
              );
            },
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
              child: const Center(
                child: Text('회전', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 이 영역은 애니메이션 때문에 다시 그려지지 않음
        const Text('이 텍스트는 애니메이션 영향을 받지 않습니다'),
      ],
    );
  }
}

