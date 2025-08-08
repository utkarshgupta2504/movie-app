import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import '../theme/app_colors.dart';

class AppToast {
  static void error(BuildContext? context, String message, {String? title}) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      title: title != null ? Text(title) : const Text('Error'),
      description: Text(message),
      autoCloseDuration: const Duration(seconds: 4),
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      icon: const Icon(Icons.error_outline, color: Colors.redAccent),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: true,
      progressBarTheme: ProgressIndicatorThemeData(
        color: Colors.redAccent.withValues(alpha: 0.7),
      ),
    );
  }

  static void success(BuildContext? context, String message, {String? title}) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      title: title != null ? Text(title) : const Text('Success'),
      description: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      icon: const Icon(Icons.check_circle_outline, color: Colors.greenAccent),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: true,
      progressBarTheme: ProgressIndicatorThemeData(
        color: Colors.greenAccent.withValues(alpha: 0.7),
      ),
    );
  }

  static void info(BuildContext? context, String message, {String? title}) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      title: title != null ? Text(title) : const Text('Info'),
      description: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      icon: const Icon(Icons.info_outline, color: Colors.lightBlueAccent),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: true,
      progressBarTheme: ProgressIndicatorThemeData(
        color: Colors.lightBlueAccent.withValues(alpha: 0.7),
      ),
    );
  }
}
