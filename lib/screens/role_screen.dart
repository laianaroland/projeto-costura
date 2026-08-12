import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final roleCta = state.papel == Papel.costureira
        ? 'Cadastrar meu ateliê'
        : (state.papel == Papel.cliente ? 'Buscar costureiras' : 'Escolha uma opção');

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Como você vai usar?', style: headingFont(fontSize: 26)),
          const SizedBox(height: 4),
          Text(
            'Dá para mudar depois, no seu perfil.',
            style: bodyFont(fontSize: 14, color: textMuted(0.6)),
          ),
          const SizedBox(height: 18),
          _RoleOption(
            selected: state.papel == Papel.cliente,
            icon: Icons.person_outline_rounded,
            tint: AppColors.accent2_300,
            ink: AppColors.accent2_900,
            title: 'Preciso de costura',
            subtitle: 'Encontrar quem ajusta, conserta ou faz',
            onTap: () => state.setPapel(Papel.cliente),
          ),
          const SizedBox(height: 14),
          _RoleOption(
            selected: state.papel == Papel.costureira,
            icon: Icons.content_cut_rounded,
            tint: AppColors.accent300,
            ink: AppColors.accent900,
            title: 'Sou costureira',
            subtitle: 'Divulgar meus serviços e preços',
            onTap: () => state.setPapel(Papel.costureira),
          ),
          const SizedBox(height: 4),
          PrimaryButton(label: roleCta, onPressed: state.confirmRole),
        ],
      ),
    );
  }
}

class _RoleOption extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final Color tint;
  final Color ink;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleOption({
    required this.selected,
    required this.icon,
    required this.tint,
    required this.ink,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: selected ? AppColors.accent : Colors.transparent, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
                child: Icon(icon, size: 26, color: ink),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: bodyFont(fontSize: 17, weight: FontWeight.w700)),
                    Text(subtitle, style: bodyFont(fontSize: 13, color: textMuted(0.58))),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.text),
            ],
          ),
        ),
      ),
    );
  }
}
