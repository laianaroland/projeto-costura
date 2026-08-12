import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final double fontSize;
  final EdgeInsets padding;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fullWidth = true,
    this.fontSize = 16,
    this.padding = const EdgeInsets.symmetric(vertical: 15),
  });

  @override
  Widget build(BuildContext context) {
    final child = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.bg,
        disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.45),
        padding: padding,
        elevation: 0,
        shape: const StadiumBorder(),
      ),
      child: Text(label, style: headingFont(fontSize: fontSize, color: AppColors.bg)),
    );
    return fullWidth ? SizedBox(width: double.infinity, child: child) : child;
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final double fontSize;
  final EdgeInsets padding;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fullWidth = true,
    this.fontSize = 14.5,
    this.padding = const EdgeInsets.symmetric(vertical: 13),
  });

  @override
  Widget build(BuildContext context) {
    final child = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.text,
        side: BorderSide(color: AppColors.divider),
        padding: padding,
        shape: const StadiumBorder(),
      ),
      child: Text(label, style: headingFont(fontSize: fontSize, color: AppColors.text)),
    );
    return fullWidth ? SizedBox(width: double.infinity, child: child) : child;
  }
}

class GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double fontSize;
  final bool fullWidth;

  const GhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fontSize = 14,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final btn = TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accent,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: headingFont(fontSize: fontSize, color: AppColors.accent)),
    );
    return fullWidth ? SizedBox(width: double.infinity, child: Center(child: btn)) : btn;
  }
}

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? background;
  final Color? iconColor;

  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 38,
    this.background,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: background ?? AppColors.surface,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Icon(icon, size: size * 0.47, color: iconColor ?? AppColors.text),
        ),
      ),
    );
  }
}

class RoundStepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const RoundStepperButton({super.key, required this.icon, required this.onPressed, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: AppColors.bg,
        shape: CircleBorder(side: BorderSide(color: AppColors.divider)),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Icon(icon, size: size * 0.55, color: AppColors.text),
        ),
      ),
    );
  }
}
