import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Add Riverpod import
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart'; // For GlobalKey, NavigatorState, showDialog
import 'package:flutter/services.dart'; // For HapticFeedback
import 'package:shake/shake.dart';

import 'package:alkitab_core/alkitab_core.dart';
import '../core/widgets/feedback_dialog.dart'; // Import FeedbackDialog
import '../data/local/app_database.dart';

// --- REFACTORED PROVIDERS ---

final screenshotControllerProvider = Provider<ScreenshotController>((ref) => ScreenshotController());

final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) => GlobalKey<NavigatorState>());

final feedbackServiceProvider = Provider<FeedbackService>((ref) {
  final db = ref.watch(databaseProvider);
  final screenshot = ref.watch(screenshotControllerProvider);
  final navKey = ref.watch(navigatorKeyProvider);
  return FeedbackService(db, screenshot, navKey);
});

class FeedbackService {
  final AppDatabase _db;
  final ScreenshotController screenshotController;
  final GlobalKey<NavigatorState>? navigatorKey;
  ShakeDetector? _shakeDetector;

  FeedbackService(this._db, this.screenshotController, [this.navigatorKey]);

  void initialize() {
    // Only enable shake on mobile
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      _shakeDetector = ShakeDetector.autoStart(
        onPhoneShake: (_) {
          // Fire and forget async logic
          () async {
            final Uint8List? capturedImage = await screenshotController.capture(pixelRatio: 2.0);

            if (navigatorKey?.currentState != null &&
                navigatorKey!.currentState!.mounted) {
              final result = await showDialog(
                context: navigatorKey!.currentState!.context,
                builder: (context) => const FeedbackDialog(),
              );

              if (result != null && result is Map) {
                final desc = result['description'];
                final cats = result['categories'] as List;
                captureAndReport(
                  context: "Shake Report: ${cats.join(', ')}",
                  extraMessage: desc,
                  preCapturedImage: capturedImage,
                );
              }
            }
          }();
        },
        minimumShakeCount: 2,
        shakeSlopTimeMS: 500,
        shakeCountResetTime: 3000,
        shakeThresholdGravity: 2.7,
      );
    }
  }

  void dispose() {
    _shakeDetector?.stopListening();
  }

  Future<void> captureAndReport({
    String context = "General Feedback",
    String? extraMessage,
    Uint8List? preCapturedImage,
  }) async {
    try {
      // 1. Capture Screenshot
      // Use pre-captured image if available, otherwise capture now
      final Uint8List? image = preCapturedImage ?? 
          await screenshotController.capture(pixelRatio: 2.0);

      // 2. Prepare Files
      final tempDir = await getTemporaryDirectory();
      final attachments = <String>[];

      // Save Screenshot
      if (image != null) {
        final screenshotPath =
            '${tempDir.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File(screenshotPath);
        await file.writeAsBytes(image);
        attachments.add(screenshotPath);
      }

      // 3. Dump Logs
      final logs = await _db.getRecentLogs(limit: 100);
      final logBuffer = StringBuffer();
      logBuffer.writeln("--- APPLICATION LOGS (Last 100) ---");
      for (var log in logs) {
        logBuffer.writeln(
            "[${log.timestamp}] [${log.level}] ${log.message} ${log.stackTrace ?? ''}");
      }

      final logPath = '${tempDir.path}/app_logs.txt';
      await File(logPath).writeAsString(logBuffer.toString());
      attachments.add(logPath);

      // 4. Device Info
      final deviceInfo = DeviceInfoPlugin();
      final packageInfo = await PackageInfo.fromPlatform();
      String deviceDetails = "";

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceDetails =
            "Device: ${androidInfo.manufacturer} ${androidInfo.model}\nAndroid SDK: ${androidInfo.version.sdkInt}";
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceDetails =
            "Device: ${iosInfo.name} ${iosInfo.systemName} ${iosInfo.systemVersion}";
      }

      // 5. Compose Email
      final body = """
--- PLEASE DESCRIBE YOUR ISSUE BELOW ---


--- SYSTEM INFO ---
App Version: ${packageInfo.version} (${packageInfo.buildNumber})
Context: $context
$deviceDetails
${extraMessage != null ? 'Extra: $extraMessage' : ''}
""";

      final Email email = Email(
        body: body,
        subject: '[Alkitab Support] Report: $context',
        recipients: ['alikitab.support@gmail.com'],
        attachmentPaths: attachments,
        isHTML: false,
      );

      await FlutterEmailSender.send(email);
    } catch (e, st) {
      AppLogger.e("Failed to send feedback report", e, st);
    }
  }
}
