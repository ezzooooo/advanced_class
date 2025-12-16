import 'package:flutter/material.dart';
import '../services/remote_config_service.dart';
import '../services/feature_flag_service.dart';
import '../services/force_update_service.dart';

/// Remote Config & Feature Flag 데모 화면
class RemoteConfigDemoScreen extends StatefulWidget {
  const RemoteConfigDemoScreen({super.key});

  @override
  State<RemoteConfigDemoScreen> createState() => _RemoteConfigDemoScreenState();
}

class _RemoteConfigDemoScreenState extends State<RemoteConfigDemoScreen> {
  final RemoteConfigService _remoteConfig = RemoteConfigService.instance;
  final FeatureFlagService _featureFlags = FeatureFlagService.instance;
  final ForceUpdateService _forceUpdate = ForceUpdateService.instance;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Config Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshConfig,
            tooltip: 'Fetch & Activate',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    '📱 앱 상태',
                    _buildAppStatusCard(),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    '⚙️ Remote Config 값',
                    _buildRemoteConfigCard(),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    '🚩 Feature Flags',
                    _buildFeatureFlagsCard(),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    '🔄 강제 업데이트 체크',
                    _buildForceUpdateCard(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildAppStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(
              '마지막 Fetch',
              _remoteConfig.lastFetchTime.toString(),
            ),
            _buildInfoRow(
              'Fetch 상태',
              _remoteConfig.lastFetchStatus.name,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemoteConfigCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow('환영 메시지', _remoteConfig.welcomeMessage),
            _buildInfoRow('최소 버전', _remoteConfig.minimumVersion),
            _buildInfoRow(
              '점검 모드',
              _remoteConfig.isMaintenanceMode ? '🔴 ON' : '🟢 OFF',
            ),
            _buildInfoRow(
              '최대 업로드 크기',
              '${_remoteConfig.maxUploadSizeMB} MB',
            ),
            _buildInfoRow('API URL', _remoteConfig.apiBaseUrl),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureFlagsCard() {
    final flags = _featureFlags.getAllFlags();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: flags.entries.map((entry) {
            return _buildFlagRow(entry.key, entry.value);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildForceUpdateCard() {
    final result = _forceUpdate.checkForUpdates();

    Color statusColor;
    IconData statusIcon;

    switch (result.status) {
      case UpdateStatus.ok:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case UpdateStatus.forceUpdate:
        statusColor = Colors.red;
        statusIcon = Icons.warning;
        break;
      case UpdateStatus.maintenance:
        statusColor = Colors.orange;
        statusIcon = Icons.engineering;
        break;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.status.name.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      Text(
                        result.message,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('현재 버전', _forceUpdate.currentVersion),
            _buildInfoRow('최소 버전', _forceUpdate.minimumVersion),
            const SizedBox(height: 16),
            if (result.needsForceUpdate)
              ElevatedButton.icon(
                onPressed: _openStore,
                icon: const Icon(Icons.system_update),
                label: const Text('스토어로 이동'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlagRow(String flagName, bool isEnabled) {
    // 읽기 쉬운 이름으로 변환
    final displayName = flagName
        .replaceAll('flag_', '')
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(displayName),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isEnabled ? Colors.green.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isEnabled ? 'ON' : 'OFF',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isEnabled ? Colors.green.shade700 : Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshConfig() async {
    setState(() => _isLoading = true);

    try {
      final updated = await _remoteConfig.fetchAndActivate();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              updated ? '설정이 업데이트되었습니다!' : '변경된 설정이 없습니다.',
            ),
            backgroundColor: updated ? Colors.green : Colors.grey,
          ),
        );
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _openStore() {
    // 실제로는 url_launcher를 사용하여 스토어로 이동
    // Android: 'https://play.google.com/store/apps/details?id=패키지명'
    // iOS: 'https://apps.apple.com/app/id앱ID'

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('스토어로 이동합니다...')),
    );
  }
}

