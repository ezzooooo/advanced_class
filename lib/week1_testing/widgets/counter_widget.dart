import 'package:flutter/material.dart';

/// 1주차: 테스팅 기초 - Widget Test 대상 위젯
///
/// 간단한 카운터 위젯입니다.
/// Widget Test를 통해 UI 동작을 검증합니다.
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key, this.initialValue = 0, this.onValueChanged});

  final int initialValue;
  final void Function(int)? onValueChanged;
  //final ValueChanged<int>? onValueChanged;

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late int _counter;

  @override
  void initState() {
    super.initState();
    _counter = widget.initialValue;
  }

  void _increment() {
    setState(() {
      _counter++;
    });
    widget.onValueChanged?.call(_counter);
  }

  void _decrement() {
    setState(() {
      _counter--;
    });
    widget.onValueChanged?.call(_counter);
  }

  void _reset() {
    setState(() {
      _counter = 0;
    });
    widget.onValueChanged?.call(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('카운터', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text(
              '$_counter',
              key: const Key('counter_value'),
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  key: const Key('decrement_button'),
                  onPressed: _decrement,
                  icon: const Icon(Icons.remove),
                  tooltip: '감소',
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  key: const Key('reset_button'),
                  onPressed: _reset,
                  child: const Text('리셋'),
                ),
                const SizedBox(width: 16),
                IconButton(
                  key: const Key('increment_button'),
                  onPressed: _increment,
                  icon: const Icon(Icons.add),
                  tooltip: '증가',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
