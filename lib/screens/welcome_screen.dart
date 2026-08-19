import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/illustrations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();

    // Natural top-down flow (scrollable as a safety net on short viewports)
    // instead of stretching to fill the screen — keeps the hero art and the
    // pitch/CTA close together instead of spread apart by empty space.
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MINHA COSTUREIRA',
            style: bodyFont(fontSize: 11, weight: FontWeight.w700, color: AppColors.accent700)
                .copyWith(letterSpacing: 1.3),
          ),
          const SizedBox(height: 14),
          const WelcomeIllustration(),
          const SizedBox(height: 20),
          Text(
            'Uma costureira boa, aqui do lado.',
            style: headingFont(fontSize: 32, height: 1.08),
          ),
          const SizedBox(height: 8),
          Text(
            'Encontre quem faz bainha, ajuste, reforma e roupa sob medida perto de você — com preço combinado antes.',
            style: bodyFont(fontSize: 15, color: textMuted(0.62)),
          ),
          const SizedBox(height: 20),
          PrimaryButton(label: 'Começar', onPressed: state.toRole),
          const SizedBox(height: 6),
          GhostButton(label: 'Já tenho conta', onPressed: state.toRole, fullWidth: true),
        ],
      ),
    );
  }
}
