import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(text, style: bodyFont(fontSize: 12, weight: FontWeight.w700)),
    );
  }
}

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    required this.controller,
    this.placeholder,
    this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: bodyFont(fontSize: 15),
      cursorColor: AppColors.accent,
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: bodyFont(fontSize: 15, color: textMuted(0.4)),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
      ),
    );
  }
}

/// A pill-shaped display field for values that get auto-filled (e.g. by a
/// CEP lookup) rather than typed — shows a muted placeholder until filled.
class DisplayField extends StatelessWidget {
  final String value;
  final bool filled;

  const DisplayField({super.key, required this.value, required this.filled});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          value,
          style: bodyFont(fontSize: 15, color: filled ? AppColors.text : textMuted(0.38)),
        ),
      ),
    );
  }
}
