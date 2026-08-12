import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ToastOverlay extends StatelessWidget {
  final String? message;
  const ToastOverlay({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 22,
      right: 22,
      bottom: 88,
      child: IgnorePointer(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: message == null
              ? const SizedBox.shrink()
              : Container(
                  key: ValueKey(message),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.accent2_800,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    boxShadow: AppShadows.lg,
                  ),
                  child: Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: bodyFont(fontSize: 13, weight: FontWeight.w600, color: AppColors.neutral100),
                  ),
                ),
        ),
      ),
    );
  }
}
