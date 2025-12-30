import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'week2_performance/week2_menu_page.dart';

// 메인 주석 추가
void main() {
  runApp(const MyApp());
}

abstract class Animal {
  final String type;
  Animal({required this.type});
  void eat();
}

abstract class Human {
  final String name;

  Human({required this.name});

  void speak();
}

abstract class MyPureInterface {
  // 외부 라이브러리에서 extends 불가, implements만 가능
  void greet() {
    if (kDebugMode) {
      print('Hello, World!');
    }
  }

  void breathe();
}

class Flyable {
  final String type;
  Flyable({required this.type});

  void fly() {
    if (kDebugMode) {
      print('Flying...');
    }
  }
}

class Swimmable {
  void swim() {
    if (kDebugMode) {
      print('Swimming...');
    }
  }
}

class Duck implements Flyable, Swimmable {
  @override
  final String type;

  Duck({required this.type});

  @override
  void fly() {
    // TODO: implement fly
  }

  @override
  void swim() {
    // TODO: implement swim
  }
}

class MyPureInterfaceImpl extends Human implements MyPureInterface, Animal {
  MyPureInterfaceImpl({required super.name});

  @override
  void greet() {
    if (kDebugMode) {
      print('Hello, World!');
    }
  }

  @override
  void breathe() {
    // TODO: implement breathe
  }

  @override
  void eat() {
    // TODO: implement eat
  }

  @override
  void speak() {
    // TODO: implement speak
  }

  @override
  // TODO: implement type
  String get type => throw UnimplementedError();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Class',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Class'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _WeekCard(
            week: 1,
            title: '테스팅 기초',
            description: 'Unit Test, Widget Test, Mocking',
          ),
          _WeekCard(
            week: 2,
            title: '앱 성능 최적화',
            description: 'DevTools, const, RepaintBoundary',
          ),
          _WeekCard(
            week: 3,
            title: 'CI/CD 파이프라인',
            description: 'GitHub Actions, 자동화',
          ),
          _WeekCard(
            week: 4,
            title: '앱 스토어 배포',
            description: 'Play Store, Keystore',
          ),
          _WeekCard(
            week: 5,
            title: 'Push Notification',
            description: 'FCM, 로컬 알림',
          ),
          _WeekCard(
            week: 6,
            title: '앱 모니터링',
            description: 'Crashlytics, Analytics',
          ),
          _WeekCard(
            week: 7,
            title: '앱 보안 & 고급 기법',
            description: 'Secure Storage, 난독화, Flavor',
          ),
        ],
      ),
    );
  }
}

class _WeekCard extends StatelessWidget {
  const _WeekCard({
    required this.week,
    required this.title,
    required this.description,
  });

  final int week;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          child: Text('$week'),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Week 2만 구현
          if (week == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Week2MenuPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Week $week는 아직 구현되지 않았습니다')),
            );
          }
        },
      ),
    );
  }
}

class TodoEntity {
  final String title;
  final String description;
  final bool isDone;
  final bool isFavorite;

  TodoEntity({
    required this.title,
    required this.description,
    required this.isDone,
    required this.isFavorite,
  });
}

void addTodo(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return AddTodoBottomSheet();
    },
  );
}

class AddTodoBottomSheet extends StatefulWidget {
  const AddTodoBottomSheet({super.key});

  @override
  State<AddTodoBottomSheet> createState() => _AddTodoBottomSheetState();
}

class _AddTodoBottomSheetState extends State<AddTodoBottomSheet> {
  TextEditingController titleController = TextEditingController();
  bool canSave = false;

  @override
  void initState() {
    titleController.addListener(() {
      canSave = titleController.text.isNotEmpty;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: titleController,
          decoration: InputDecoration(border: InputBorder.none),
          onSubmitted: (value) {
            if (kDebugMode) {
              print(value);
            }
          },
        ),
        Row(children: []),
      ],
    );
  }
}
