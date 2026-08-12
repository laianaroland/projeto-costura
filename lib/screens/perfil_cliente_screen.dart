import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';

class PerfilClienteScreen extends StatelessWidget {
  const PerfilClienteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final ajustes = [
      (
        label: 'Endereço de retirada',
        value: state.cli.achou
            ? 'Rua das Palmeiras, ${state.cli.num.isNotEmpty ? state.cli.num : 's/n'} · Centro'
            : 'Rua das Palmeiras, 240 · Centro',
      ),
      (label: 'Formas de pagamento', value: 'Pix · cartão final 4412'),
      (label: 'Notificações', value: 'Quando a peça ficar pronta'),
      (label: 'Raio de busca', value: 'Até ${state.raio} km'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Seu perfil', style: headingFont(fontSize: 26)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.accent2_300,
                  child: Text('A', style: headingFont(fontSize: 24, color: AppColors.accent2_900)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(state.cliPerfilNome, style: bodyFont(fontSize: 17, weight: FontWeight.w700)),
                      Text(state.cliPerfilTel, style: bodyFont(fontSize: 12.5, color: textMuted(0.55))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          for (final a in ajustes)
            InkWell(
              onTap: () => state.flash('Tela de ${a.label.toLowerCase()}'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 2),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.label, style: bodyFont(fontSize: 14.5, weight: FontWeight.w600)),
                          Text(a.value, style: bodyFont(fontSize: 12.5, color: textMuted(0.55))),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.text),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 18),
          SecondaryButton(label: 'Quero atender como costureira', onPressed: state.virarPro),
          const SizedBox(height: 12),
          GhostButton(label: 'Sair da conta', onPressed: state.toWelcome),
        ],
      ),
    );
  }
}
