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
      appBar: AppBar(title: const Text('Good Example - 최적화된 Rebuild')),
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
/// StatefulWidget이지만 상태가 없어서 rebuild되지 않음
class HeavyWidgetOptimized extends StatefulWidget {
  const HeavyWidgetOptimized({super.key});

  @override
  State<HeavyWidgetOptimized> createState() => _HeavyWidgetOptimizedState();
}

class _HeavyWidgetOptimizedState extends State<HeavyWidgetOptimized> {
  late double _calculationResult;
  late int _buildTime;
  int _buildCount = 0;

  @override
  void initState() {
    super.initState();
    // 무거운 계산을 initState에서 한 번만 수행
    final startTime = DateTime.now();

    // 1. 복잡한 수학 계산 (Bad Example과 동일한 무게)
    _calculationResult = 0;
    for (int i = 0; i < 5000000; i++) {
      _calculationResult += i * 0.001;
      // 추가 연산으로 더 무겁게
      if (i % 100 == 0) {
        _calculationResult = _calculationResult / 1.1 + i * 0.5;
      }
    }

    // 2. 문자열 연산 (메모리 할당)
    final heavyStringBuffer = StringBuffer();
    for (int i = 0; i < 1000; i++) {
      heavyStringBuffer.write('Heavy calculation $i ');
    }
    _calculationResult += heavyStringBuffer.length.toDouble();

    // 3. 리스트 연산
    final List<int> heavyList = [];
    for (int i = 0; i < 10000; i++) {
      heavyList.add(i);
      if (i % 2 == 0) heavyList.remove(i);
    }
    _calculationResult += heavyList.length.toDouble();

    _buildTime = DateTime.now().difference(startTime).inMilliseconds;
    print('🟢 HeavyWidgetOptimized initState 계산 시간: ${_buildTime}ms (최초 1회만!)');
  }

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    print('🟢 HeavyWidgetOptimized build() 호출됨 (${_buildCount}번째)');

    // 위젯 트리는 build마다 생성되지만, 무거운 계산은 initState에서만 수행
    // Bad Example과 동일하게 복잡한 위젯 트리
    return Container(
      height: 300,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade100, Colors.teal.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bad Example과 동일하게 500개 위젯 생성
            Row(
              children: List.generate(500, (index) {
                return Container(
                  margin: const EdgeInsets.all(2),
                  child: Column(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.primaries[index % Colors.primaries.length],
                              Colors.primaries[(index + 1) %
                                  Colors.primaries.length],
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Item ${index + 1}',
                        style: const TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    '✅ Heavy Widget (Optimized)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'const로 선언 → 무거운 계산은 최초 1회만!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'build 횟수: $_buildCount | 계산 시간: ${_buildTime}ms (initState)',
                    style: const TextStyle(fontSize: 10),
                  ),
                  Text(
                    '계산 결과: ${_calculationResult.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 10),
                  ),
                  Text(
                    '위젯 개수: 500개 (최초 1회만 생성)',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.green.shade700,
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
        return ListTile(title: Text('Item $index'));
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
