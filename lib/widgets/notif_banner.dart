import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotifBanner extends StatelessWidget {
  final bool visible;
  final String titulo;
  final String texto;
  final VoidCallback onTap;

  const NotifBanner({
    super.key,
    required this.visible,
    required this.titulo,
    required this.texto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 14,
      right: 14,
      top: 14,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, -1.4),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: const Duration(milliseconds: 240),
          child: IgnorePointer(
            ignoring: !visible,
            child: Material(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: AppShadows.lg,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.accent2_300,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.check, color: AppColors.accent2_900, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'MINHA COSTUREIRA',
                                  style: bodyFont(
                                    fontSize: 11,
                                    weight: FontWeight.w700,
                                    color: AppColors.accent700,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text('agora', style: bodyFont(fontSize: 11, color: textMuted(0.45))),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(titulo, style: bodyFont(fontSize: 14.5, weight: FontWeight.w700)),
                            Text(
                              texto,
                              style: bodyFont(fontSize: 12.5, color: textMuted(0.6)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
