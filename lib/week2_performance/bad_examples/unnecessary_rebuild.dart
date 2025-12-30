import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 2주차: 성능 최적화 - 불필요한 rebuild 예제 (안티패턴)
///
/// 이 예제는 상태 관리가 잘못되어 불필요한 rebuild가 발생하는 경우를 보여줍니다.

/// ❌ 안티패턴: 전체 위젯 트리가 rebuild됨
class BadCounterPage extends StatefulWidget {
  const BadCounterPage({super.key});

  @override
  State<BadCounterPage> createState() => _BadCounterPageState();
}

class _BadCounterPageState extends State<BadCounterPage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    // 문제: 카운터가 변경될 때마다 전체 트리가 rebuild됨
    if (kDebugMode) {
      print('🔴 BadCounterPage build() 호출됨');
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Bad Example - 불필요한 Rebuild')),
      body: Column(
        children: [
          // 문제 1: const가 아닌 위젯들도 매번 rebuild
          HeavyWidget(), // const 없음!
          // 문제 2: 변경되지 않는 위젯도 rebuild
          Container(
            padding: EdgeInsets.all(16), // const 없음!
            child: Text(
              '이 텍스트는 변경되지 않지만 매번 rebuild됩니다',
              style: TextStyle(fontSize: 16), // const 없음!
            ),
          ),

          // 실제로 변경되는 부분
          Text(
            'Counter: $_counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _counter++),
        child: Icon(Icons.add), // const 없음!
      ),
    );
  }
}

/// ❌ 안티패턴: 매번 새로운 인스턴스 생성
class HeavyWidget extends StatelessWidget {
  HeavyWidget({super.key}) {
    if (kDebugMode) {
      print('🔴 HeavyWidget 인스턴스 생성됨');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('🔴 HeavyWidget build() 호출됨');
    }

    // 실제로 무거운 연산 수행
    final startTime = DateTime.now();

    // 1. 복잡한 수학 계산 (약 100-200ms 소요)
    double result = 0;
    for (int i = 0; i < 5000000; i++) {
      result += i * 0.001;
      // 추가 연산으로 더 무겁게
      if (i % 100 == 0) {
        result = result / 1.1 + i * 0.5;
      }
    }

    // 2. 문자열 연산 (메모리 할당)
    final heavyStringBuffer = StringBuffer();
    for (int i = 0; i < 1000; i++) {
      heavyStringBuffer.write('Heavy calculation $i ');
    }
    result += heavyStringBuffer.length.toDouble();

    // 3. 리스트 연산
    final List<int> heavyList = [];
    for (int i = 0; i < 10000; i++) {
      heavyList.add(i);
      if (i % 2 == 0) heavyList.remove(i);
    }
    result += heavyList.length.toDouble();

    final endTime = DateTime.now();
    final duration = endTime.difference(startTime).inMilliseconds;
    if (kDebugMode) {
      print('🔴 HeavyWidget 빌드 시간: ${duration}ms (매번 계산!)');
    }

    // 극도로 복잡한 위젯 트리 생성
    return Container(
      height: 300,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade100, Colors.purple.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
            // 엄청나게 많은 위젯 생성 (화면에 보이지도 않음)
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
                              color: Colors.black.withValues(alpha: 0.2),
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
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    '⚠️ Heavy Widget',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '매번 rebuild 시 ${duration}ms 소요',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '계산 결과: ${result.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 10),
                  ),
                  Text(
                    '위젯 개수: 500개 매번 생성',
                    style: TextStyle(fontSize: 10, color: Colors.red.shade700),
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

/// ❌ 안티패턴: 리스트를 잘못 사용
class BadListExample extends StatelessWidget {
  const BadListExample({super.key});

  @override
  Widget build(BuildContext context) {
    // 문제: 1000개 항목을 모두 한번에 생성
    return ListView(
      children: List.generate(
        1000,
        (index) => ListTile(title: Text('Item $index')),
      ),
    );
  }
}

/// ❌ 안티패턴: build 메서드 내에서 객체 생성
class BadObjectCreation extends StatelessWidget {
  const BadObjectCreation({super.key});

  @override
  Widget build(BuildContext context) {
    // 문제: 매 빌드마다 새로운 함수 객체 생성
    void handleTap() {
      if (kDebugMode) {
        print('Tapped!');
      }
    }

    // 문제: 매 빌드마다 새로운 리스트 생성
    final items = ['A', 'B', 'C'];

    return Column(
      children: items
          .map(
            (item) => ElevatedButton(
              onPressed: handleTap, // 매번 새 함수 객체
              child: Text(item),
            ),
          )
          .toList(),
    );
  }
}
