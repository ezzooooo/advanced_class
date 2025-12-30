import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../services/secure_storage_service.dart';

/// 7주차: 앱 보안 - 데모 화면
class SecurityDemoScreen extends StatefulWidget {
  const SecurityDemoScreen({super.key});

  @override
  State<SecurityDemoScreen> createState() => _SecurityDemoScreenState();
}

class _SecurityDemoScreenState extends State<SecurityDemoScreen> {
  final SecureStorageService _storage = SecureStorageService();
  final AppConfig _config = AppConfig();
  final TextEditingController _tokenController = TextEditingController();

  String? _savedToken;
  Map<String, String> _allData = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final token = await _storage.getAccessToken();
    final allData = await _storage.readAll();
    setState(() {
      _savedToken = token;
      _allData = allData;
    });
  }

  Future<void> _saveToken() async {
    final token = _tokenController.text;
    if (token.isEmpty) {
      _showSnackBar('토큰을 입력하세요');
      return;
    }

    await _storage.saveAccessToken(token);
    _tokenController.clear();
    await _loadData();
    _showSnackBar('토큰이 안전하게 저장되었습니다');
  }

  Future<void> _clearAll() async {
    await _storage.deleteAll();
    await _loadData();
    _showSnackBar('모든 데이터가 삭제되었습니다');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('보안 데모')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 환경 설정 섹션
            _buildSectionTitle('⚙️ 환경 설정'),
            const SizedBox(height: 8),
            _buildEnvironmentSection(),

            const SizedBox(height: 24),

            // Secure Storage 섹션
            _buildSectionTitle('🔐 Secure Storage'),
            const SizedBox(height: 8),
            _buildSecureStorageSection(),

            const SizedBox(height: 24),

            // 보안 체크리스트
            _buildSectionTitle('✅ 보안 체크리스트'),
            const SizedBox(height: 8),
            _buildSecurityChecklist(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildEnvironmentSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConfigItem(
              '현재 환경',
              _config.environment.name.toUpperCase(),
              _getEnvironmentColor(),
            ),
            const Divider(),
            _buildConfigItem('API URL', _config.apiBaseUrl),
            const Divider(),
            _buildConfigItem('앱 이름', _config.appName),
            const Divider(),
            _buildConfigItem('로깅 활성화', _config.enableLogging ? '✅ 예' : '❌ 아니오'),
            const SizedBox(height: 16),
            const Text(
              '💡 빌드 시 --dart-define=ENV=prod 로 환경 변경',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Color _getEnvironmentColor() {
    switch (_config.environment) {
      case Environment.prod:
        return Colors.green;
      case Environment.staging:
        return Colors.orange;
      case Environment.dev:
        return Colors.blue;
    }
  }

  Widget _buildConfigItem(String label, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSecureStorageSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 토큰 입력
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: '토큰 입력',
                hintText: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // 저장 버튼
            ElevatedButton.icon(
              onPressed: _saveToken,
              icon: const Icon(Icons.save),
              label: const Text('안전하게 저장'),
            ),
            const SizedBox(height: 16),

            // 저장된 토큰 표시
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '저장된 토큰:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _savedToken ?? '없음',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: _savedToken != null ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 저장된 모든 데이터
            if (_allData.isNotEmpty) ...[
              const Text(
                '모든 저장된 데이터:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...(_allData.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '${e.key}: ${e.value.substring(0, e.value.length > 20 ? 20 : e.value.length)}...',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                    ),
                  ),
                ),
              )),
              const SizedBox(height: 12),
            ],

            // 전체 삭제 버튼
            OutlinedButton.icon(
              onPressed: _clearAll,
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text(
                '모든 데이터 삭제',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityChecklist() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _ChecklistItem(
              title: 'Secure Storage 사용',
              description: '토큰, API 키 등 민감 정보',
              isChecked: true,
            ),
            Divider(),
            _ChecklistItem(
              title: 'ProGuard/R8 난독화',
              description: 'Android Release 빌드 시 적용',
              isChecked: false,
            ),
            Divider(),
            _ChecklistItem(
              title: '환경 분리',
              description: 'dev/staging/prod 설정 분리',
              isChecked: true,
            ),
            Divider(),
            _ChecklistItem(
              title: 'HTTPS 사용',
              description: '모든 네트워크 통신 암호화',
              isChecked: true,
            ),
            Divider(),
            _ChecklistItem(
              title: '민감 정보 로깅 금지',
              description: '프로덕션에서 토큰 로그 제거',
              isChecked: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({
    required this.title,
    required this.description,
    required this.isChecked,
  });

  final String title;
  final String description;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isChecked ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
