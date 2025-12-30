import 'package:flutter/material.dart';

/// 2주차: 성능 최적화 - 리스트 최적화 예제
///
/// ListView vs ListView.builder 성능 비교

class ListOptimizationExample extends StatelessWidget {
  const ListOptimizationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('리스트 최적화'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '❌ Bad (ListView)'),
              Tab(text: '✅ Good (builder)'),
              Tab(text: '🖼️ 이미지 (builder)'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _BadListExample(),
            _GoodListExample(),
            _ImageListExample(),
          ],
        ),
      ),
    );
  }
}

/// ❌ 안티패턴: ListView with children
/// 모든 항목을 한번에 생성 → 메모리 낭비
class _BadListExample extends StatelessWidget {
  const _BadListExample();

  @override
  Widget build(BuildContext context) {
    print('🔴 BadListExample build() - 100개 항목 모두 생성 시작');
    final startTime = DateTime.now();

    final items = List.generate(
      100, // 1000개는 너무 많아서 100개로 축소
      (index) {
        if (index % 20 == 0) {
          print('🔴 Item $index 생성 중...');
        }
        return _HeavyListItem(index: index, isBuilder: false);
      },
    );

    final duration = DateTime.now().difference(startTime).inMilliseconds;
    print('🔴 BadListExample 생성 완료: ${duration}ms');

    return Column(
      children: [
        Container(
          color: Colors.red.shade50,
          padding: const EdgeInsets.all(16),
          child: Text(
            '❌ 문제점:\n'
            '• 100개 항목을 모두 한번에 생성 (${duration}ms 소요)\n'
            '• 화면에 보이지 않는 항목도 렌더링\n'
            '• 메모리 낭비 및 초기 로딩 느림\n'
            '• 스크롤 전에 이미 모든 위젯 생성됨',
            style: const TextStyle(fontSize: 11),
          ),
        ),
        Expanded(child: ListView(children: items)),
      ],
    );
  }
}

/// ✅ 베스트 프랙티스: ListView.builder
/// 보이는 항목만 생성 → 메모리 효율적
class _GoodListExample extends StatelessWidget {
  const _GoodListExample();

  @override
  Widget build(BuildContext context) {
    print('🟢 GoodListExample build() - builder 사용 (즉시 완료)');

    return Column(
      children: [
        Container(
          color: Colors.green.shade50,
          padding: const EdgeInsets.all(16),
          child: const Text(
            '✅ 장점:\n'
            '• 화면에 보이는 항목만 생성 (즉시 완료!)\n'
            '• 스크롤 시 동적으로 생성/제거\n'
            '• 메모리 효율적, 빠른 초기 로딩\n'
            '• 1000개 항목이어도 초기 로딩 빠름',
            style: TextStyle(fontSize: 11),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 1000,
            itemBuilder: (context, index) {
              return _HeavyListItem(index: index, isBuilder: true);
            },
          ),
        ),
      ],
    );
  }
}

/// 무거운 리스트 항목 (시뮬레이션)
class _HeavyListItem extends StatelessWidget {
  const _HeavyListItem({required this.index, required this.isBuilder});

  final int index;
  final bool isBuilder;

  @override
  Widget build(BuildContext context) {
    // 콘솔에서 어떤 항목이 빌드되는지 확인
    if (index % 100 == 0) {
      print('${isBuilder ? "🟢" : "🔴"} Item $index build()');
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isBuilder ? Colors.green : Colors.red,
          child: Text('$index'),
        ),
        title: Text('Item $index'),
        subtitle: Text(isBuilder ? 'ListView.builder로 생성' : 'ListView로 생성'),
        trailing: Icon(
          isBuilder ? Icons.check_circle : Icons.warning,
          color: isBuilder ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}

/// 🖼️ 이미지 리스트 예제 (picsum.photos 사용)
/// ListView.builder + 이미지 최적화
class _ImageListExample extends StatelessWidget {
  const _ImageListExample();

  @override
  Widget build(BuildContext context) {
    print('🖼️ ImageListExample build() - 100개 이미지 항목 모두 생성 시작');
    final startTime = DateTime.now();

    // 모든 이미지 항목을 한번에 생성
    final items = List.generate(100, (index) {
      if (index % 10 == 0) {
        print('🖼️ ImageItem $index 생성 중...');
      }
      return _ImageListItem(index: index);
    });

    final duration = DateTime.now().difference(startTime).inMilliseconds;
    print('🖼️ ImageListExample 생성 완료: ${duration}ms (이미지 로드는 별도)');

    return Column(
      children: [
        Container(
          color: Colors.blue.shade50,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🖼️ 이미지 리스트 (모든 항목 한번에 빌드)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                '• 100개 위젯 모두 한번에 생성 (${duration}ms)\n'
                '• 모든 이미지가 동시에 네트워크 요청\n'
                '• 화면에 안 보여도 모두 build() 호출\n'
                '• 초기 메모리 사용량 높음 + 느린 로딩',
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(child: Column(children: items)),
        ),
      ],
    );
  }
}

/// 이미지가 포함된 리스트 항목
class _ImageListItem extends StatelessWidget {
  const _ImageListItem({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    // 모든 항목의 build 호출 로그
    print('🖼️ ImageListItem $index build() 호출');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지 영역 - picsum.photos 사용
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
              child: Image.network(
                'https://picsum.photos/seed/$index/400/225',
                fit: BoxFit.cover,
                // 로딩 중 표시
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                // 에러 처리
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(
                        Icons.error_outline,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // 텍스트 정보
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Photo #$index',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${(index * 7 + 42) % 500} likes',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.comment_outlined,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${(index * 3 + 15) % 100} comments',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 추가 예제: ListView.separated
class ListSeparatedExample extends StatelessWidget {
  const ListSeparatedExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListView.separated')),
      body: ListView.separated(
        itemCount: 50,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text('$index')),
            title: Text('Item $index'),
            subtitle: const Text('구분선이 자동으로 추가됩니다'),
          );
        },
      ),
    );
  }
}
