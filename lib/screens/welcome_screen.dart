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
    const padding = EdgeInsets.fromLTRB(24, 26, 24, 28);

    // On tall phone screens this spreads the hero art and the pitch/CTA
    // apart like the design; on short viewports (small phones, landscape,
    // the default test surface) it scrolls instead of overflowing.
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - padding.vertical,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MINHA COSTUREIRA',
                      style: bodyFont(fontSize: 11, weight: FontWeight.w700, color: AppColors.accent700)
                          .copyWith(letterSpacing: 1.3),
                    ),
                    const SizedBox(height: 14),
                    const WelcomeIllustration(),
                  ],
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
              ],
            ),
          ),
        );
      },
    );
  }
}
