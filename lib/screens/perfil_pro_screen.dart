import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../state/formatters.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/toggle_switch.dart';

class PerfilProScreen extends StatelessWidget {
  const PerfilProScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final meus = state.meusServicosAtivos;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Seu ateliê', style: headingFont(fontSize: 26)),
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
                  backgroundColor: AppColors.accent300,
                  child: Text('R', style: headingFont(fontSize: 24, color: AppColors.accent900)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rita Nascimento', style: bodyFont(fontSize: 17, weight: FontWeight.w700)),
                      Text('Vila Nova · publicado hoje', style: bodyFont(fontSize: 12.5, color: textMuted(0.55))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: state.disponivel ? AppColors.accent2_200 : AppColors.neutral200,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    state.disponivel ? 'Aceitando novos pedidos' : 'Agenda fechada',
                    style: bodyFont(fontSize: 14.5, weight: FontWeight.w700),
                  ),
                ),
                AppToggleSwitch(value: state.disponivel, onTap: state.toggleDisp),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Seus serviços', style: headingFont(fontSize: 16, weight: FontWeight.w600)),
          for (final s in meus)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 2),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(s.nome, style: bodyFont(fontSize: 14.5, weight: FontWeight.w600)),
                  Text(brl(s.preco), style: headingFont(fontSize: 16)),
                ],
              ),
            ),
          const SizedBox(height: 16),
          SecondaryButton(label: 'Editar serviços e preços', onPressed: state.editarServicos),
          const SizedBox(height: 22),
          Text('Atendimento', style: headingFont(fontSize: 16, weight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(state.resumoHorarioTexto, style: bodyFont(fontSize: 13.5, color: textMuted(0.58))),
          const SizedBox(height: 16),
          Text('Endereço', style: headingFont(fontSize: 16, weight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(AppState.enderecoLinha, style: bodyFont(fontSize: 13.5, color: textMuted(0.58))),
          const SizedBox(height: 20),
          GhostButton(label: 'Sair da conta', onPressed: state.toWelcome),
        ],
      ),
    );
  }
}
