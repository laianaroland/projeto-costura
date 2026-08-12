import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class BottomTabBar extends StatelessWidget {
  final AppTab current;
  final String buscaLabel;
  final ValueChanged<AppTab> onTap;

  const BottomTabBar({
    super.key,
    required this.current,
    required this.buscaLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (tab: AppTab.busca, icon: Icons.search_rounded, label: buscaLabel),
      (tab: AppTab.pedidos, icon: Icons.inventory_2_outlined, label: 'Pedidos'),
      (tab: AppTab.perfil, icon: Icons.person_outline_rounded, label: 'Perfil'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 12),
      child: Row(
        children: items.map((it) {
          final active = current == it.tab;
          final color = active ? AppColors.accent700 : textMuted(0.45);
          return Expanded(
            child: InkWell(
              onTap: () => onTap(it.tab),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(it.icon, size: 22, color: color),
                    const SizedBox(height: 3),
                    Text(it.label, style: bodyFont(fontSize: 11, weight: FontWeight.w700, color: color)),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
