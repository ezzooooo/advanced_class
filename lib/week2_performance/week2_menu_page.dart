import 'package:flutter/material.dart';
import 'bad_examples/unnecessary_rebuild.dart';
import 'good_examples/optimized_rebuild.dart';
import 'good_examples/key_usage_example.dart';
import 'good_examples/list_optimization.dart';
import 'good_examples/const_widget_example.dart';

/// Week 2: 성능 최적화 메뉴 페이지
class Week2MenuPage extends StatelessWidget {
  const Week2MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 2: 성능 최적화'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionTitle(title: '❌ Bad Examples (안티패턴)'),
          _ExampleCard(
            title: '불필요한 Rebuild',
            description: 'const 미사용, 전체 트리 rebuild 문제',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BadCounterPage()),
            ),
          ),
          const SizedBox(height: 24),
          const _SectionTitle(title: '✅ Good Examples (최적화)'),
          _ExampleCard(
            title: 'Rebuild 최적화',
            description: 'const 사용, 상태 범위 최소화',
            icon: Icons.speed,
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GoodCounterPage()),
            ),
          ),
          _ExampleCard(
            title: 'const 위젯 활용',
            description: 'const 생성자로 rebuild 최적화',
            icon: Icons.check_circle,
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ConstWidgetDemo()),
            ),
          ),
          _ExampleCard(
            title: 'Key 사용 예제',
            description: 'GlobalKey, ValueKey, UniqueKey 활용',
            icon: Icons.key,
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const KeyUsageDemo()),
            ),
          ),
          _ExampleCard(
            title: '리스트 최적화',
            description: 'ListView.builder vs ListView',
            icon: Icons.list,
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ListOptimizationExample(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const _InfoCard(
            title: '💡 성능 측정 방법',
            content:
                '1. flutter run --profile 모드로 실행\n'
                '2. DevTools에서 Performance 탭 확인\n'
                '3. 콘솔 로그에서 rebuild 횟수 확인\n'
                '4. Timeline을 통해 렌더링 시간 측정',
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.description,
    required this.onTap,
    this.icon = Icons.code,
    this.color = Colors.red,
  });

  final String title;
  final String description;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          foregroundColor: color,
          child: Icon(icon),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(content, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
