import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Pill switch matching the design's custom on/off control (used for
/// "aceitando novos pedidos").
class AppToggleSwitch extends StatelessWidget {
  final bool value;
  final Color onColor;
  final VoidCallback onTap;

  const AppToggleSwitch({
    super.key,
    required this.value,
    required this.onTap,
    this.onColor = AppColors.accent2_600,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 56,
        height: 32,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? onColor : AppColors.neutral400,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(color: AppColors.bg, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
