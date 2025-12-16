import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/force_update_service.dart';

/// 강제 업데이트 다이얼로그
///
/// 앱 시작 시 버전 체크 후 표시합니다.
/// 뒤로가기 버튼을 막아 반드시 업데이트하도록 유도합니다.
class ForceUpdateDialog extends StatelessWidget {
  final UpdateCheckResult result;
  final VoidCallback onUpdate;

  const ForceUpdateDialog({
    super.key,
    required this.result,
    required this.onUpdate,
  });

  /// 강제 업데이트 다이얼로그 표시
  static Future<void> show(
    BuildContext context, {
    required UpdateCheckResult result,
    required VoidCallback onUpdate,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false, // 바깥 터치로 닫기 방지
      builder: (context) => ForceUpdateDialog(
        result: result,
        onUpdate: onUpdate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // 뒤로가기 버튼 막기 (강제 업데이트의 경우)
        if (result.needsForceUpdate) {
          // 앱 종료
          SystemNavigator.pop();
          return false;
        }
        return true;
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              result.isMaintenance ? Icons.engineering : Icons.system_update,
              color: result.isMaintenance ? Colors.orange : Colors.blue,
            ),
            const SizedBox(width: 8),
            Text(
              result.isMaintenance ? '서버 점검' : '업데이트 필요',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(result.message),
            if (result.currentVersion != null) ...[
              const SizedBox(height: 16),
              _buildVersionInfo(
                '현재 버전',
                result.currentVersion!,
                Colors.grey,
              ),
              _buildVersionInfo(
                '최소 버전',
                result.minimumVersion!,
                Colors.blue,
              ),
            ],
          ],
        ),
        actions: [
          if (result.isMaintenance)
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text('앱 종료'),
            )
          else ...[
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text('종료'),
            ),
            ElevatedButton(
              onPressed: onUpdate,
              child: const Text('업데이트'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVersionInfo(String label, String version, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            version,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// 점검 화면
///
/// 점검 모드일 때 전체 화면으로 표시합니다.
class MaintenanceScreen extends StatelessWidget {
  final String message;

  const MaintenanceScreen({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.engineering,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 24),
              const Text(
                '서버 점검 중',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: () => SystemNavigator.pop(),
                icon: const Icon(Icons.exit_to_app),
                label: const Text('앱 종료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

