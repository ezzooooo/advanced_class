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

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Container
    // ㄴ Column
    //   ㄴ Icon
    //   ㄴ SizedBox
    //     ㄴ Text
    //   ㄴ Text
    //   ㄴ SizedBox
    //     ㄴ Row
    //       ㄴ Icon
    //       ㄴ Text

    return Column(
      children: [
        Icon(Icons.add),
        SizedBox(height: 5, child: Text('Hello2')),
        Text('Hello'),
        SizedBox(child: Row(children: [Icon(Icons.add), Text('Hello3')])),
      ],
    );
  }
}

class SeatPage extends StatefulWidget {
  const SeatPage({super.key});

  @override
  State<SeatPage> createState() => _SeatPageState();
}

class _SeatPageState extends State<SeatPage> {
  int? selectRow;
  int? selectColumn;

  void onSelected(int row, int column) {
    setState(() {
      selectRow = row;
      selectColumn = column;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SeatSelectBox(
      selectRow: selectRow,
      selectColumn: selectColumn,
      onSelected: onSelected,
    );
  }
}

class SeatSelectBox extends StatefulWidget {
  const SeatSelectBox({
    super.key,
    required this.selectRow,
    required this.selectColumn,
    required this.onSelected,
  });

  final int? selectRow;
  final int? selectColumn;
  final void Function(int row, int column) onSelected;

  @override
  State<SeatSelectBox> createState() => _SeatSelectBoxState();
}

class _SeatSelectBoxState extends State<SeatSelectBox> {
  // 얘는 SeatPage의 상태를 모른다.

  // SeatPage에 있는 onSelected를 호출해야 해서

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SeatBottom extends StatefulWidget {
  const SeatBottom({super.key});

  @override
  State<SeatBottom> createState() => _SeatBottomState();
}

class _SeatBottomState extends State<SeatBottom> {
  @override
  Widget build(BuildContext context) {
    return Text(
      'aa',
      style: TextStyle(fontFamily: 'BlackHanSans', fontWeight: FontWeight.w900),
    );
  }
}

class MyAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar();
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
