import 'package:flutter/material.dart';

/// 2주차: 성능 최적화 - Key 사용법 예제
///
/// Key가 위젯 재사용에 미치는 영향을 보여줍니다.

class KeyUsageDemo extends StatefulWidget {
  const KeyUsageDemo({super.key});

  @override
  State<KeyUsageDemo> createState() => _KeyUsageDemoState();
}

class _KeyUsageDemoState extends State<KeyUsageDemo> {
  List<String> items = ['Apple', 'Banana', 'Cherry'];

  void _shuffleItems() {
    setState(() {
      items.shuffle();
    });
  }

  void _removeFirst() {
    if (items.isNotEmpty) {
      setState(() {
        items = items.sublist(1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Key 사용법 데모'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: _shuffleItems,
            tooltip: '셔플',
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _removeFirst,
            tooltip: '첫 번째 삭제',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '❌ Key 없음 - 상태가 잘못 유지됨',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            const Text('체크박스를 선택하고 셔플해보세요:'),
            const SizedBox(height: 8),

            // ❌ Key 없이 사용 - 문제 발생
            ...items.map((item) => _CheckboxTile(title: item)),

            const Divider(height: 32),

            const Text(
              '✅ Key 사용 - 상태가 올바르게 유지됨',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            const Text('체크박스를 선택하고 셔플해보세요:'),
            const SizedBox(height: 8),

            // ✅ Key 사용 - 올바르게 동작
            ...items.map(
              (item) => _CheckboxTile(
                key: ValueKey(item), // ✅ Key 추가
                title: item,
              ),
            ),

            const Divider(height: 32),

            const _KeyTypesInfo(),
          ],
        ),
      ),
    );
  }
}

/// 상태를 가진 체크박스 타일
class _CheckboxTile extends StatefulWidget {
  const _CheckboxTile({super.key, required this.title});

  final String title;

  @override
  State<_CheckboxTile> createState() => _CheckboxTileState();
}

class _CheckboxTileState extends State<_CheckboxTile> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.title),
      value: _isChecked,
      onChanged: (value) => setState(() => _isChecked = value ?? false),
    );
  }
}

/// Key 종류 설명
class _KeyTypesInfo extends StatelessWidget {
  const _KeyTypesInfo();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔑 Key 종류',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            _KeyTypeItem(
              title: 'ValueKey<T>',
              description: '값을 기반으로 위젯 식별 (가장 많이 사용)',
              example: "ValueKey('item_id')",
            ),
            SizedBox(height: 8),
            _KeyTypeItem(
              title: 'ObjectKey',
              description: '객체 인스턴스를 기반으로 식별',
              example: 'ObjectKey(myObject)',
            ),
            SizedBox(height: 8),
            _KeyTypeItem(
              title: 'UniqueKey',
              description: '매번 새로운 위젯으로 취급 (항상 rebuild)',
              example: 'UniqueKey()',
            ),
            SizedBox(height: 8),
            _KeyTypeItem(
              title: 'GlobalKey',
              description: '전역적으로 위젯 접근 가능 (신중히 사용)',
              example: 'GlobalKey<FormState>()',
            ),
          ],
        ),
      ),
    );
  }
}

class _KeyTypeItem extends StatelessWidget {
  const _KeyTypeItem({
    required this.title,
    required this.description,
    required this.example,
  });

  final String title;
  final String description;
  final String example;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(description, style: const TextStyle(fontSize: 12)),
        Text(
          example,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'monospace',
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
