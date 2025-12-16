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
    print('🔴 BadCounterPage build() 호출됨');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bad Example - 불필요한 Rebuild'),
      ),
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
    print('🔴 HeavyWidget 인스턴스 생성됨');
  }

  @override
  Widget build(BuildContext context) {
    print('🔴 HeavyWidget build() 호출됨');

    // 무거운 위젯 시뮬레이션
    return Container(
      height: 100,
      color: Colors.blue.shade100,
      child: Center(
        child: Text('Heavy Widget'),
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
        (index) => ListTile(
          title: Text('Item $index'),
        ),
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
      print('Tapped!');
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

