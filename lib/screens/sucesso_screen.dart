import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/illustrations.dart';

class SucessoScreen extends StatelessWidget {
  const SucessoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Material(
      color: AppColors.bg,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 34),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SuccessCheckIllustration(),
              const SizedBox(height: 14),
              Text('Pedido enviado!', style: headingFont(fontSize: 26)),
              const SizedBox(height: 6),
              Text(
                state.sucessoTexto,
                textAlign: TextAlign.center,
                style: bodyFont(fontSize: 14.5, color: textMuted(0.6)),
              ),
              const SizedBox(height: 22),
              PrimaryButton(label: 'Ver meu pedido', onPressed: state.verPedidos),
              const SizedBox(height: 8),
              GhostButton(label: 'Voltar para a busca', onPressed: state.voltarBusca, fullWidth: true),
            ],
          ),
        ),
      ),
    );
  }
}
