import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';

class PagarPedidoSheet extends StatelessWidget {
  const PagarPedidoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final opcoes = [
      (key: FormaPagto.pix, label: 'Pix', sub: 'aprovação na hora', icon: Icons.qr_code_rounded),
      (
        key: FormaPagto.credito,
        label: 'Cartão de crédito',
        sub: 'até 2x sem juros',
        icon: Icons.credit_card_rounded,
      ),
      (
        key: FormaPagto.debito,
        label: 'Cartão de débito',
        sub: 'debitado agora',
        icon: Icons.credit_card_rounded,
      ),
      (
        key: FormaPagto.dinheiro,
        label: 'Dinheiro na retirada',
        sub: 'você paga pessoalmente',
        icon: Icons.payments_outlined,
      ),
    ];

    return Material(
      color: AppColors.bg,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      RoundIconButton(icon: Icons.chevron_left_rounded, onPressed: state.fecharPagarPedido),
                      const SizedBox(width: 10),
                      Text('Conferir e pagar', style: headingFont(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accent2_200,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(color: AppColors.accent2_500, shape: BoxShape.circle),
                          child: const Icon(Icons.check, color: AppColors.neutral100, size: 22),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sua peça está pronta',
                                style: bodyFont(fontSize: 14.5, weight: FontWeight.w700, color: AppColors.accent2_900),
                              ),
                              Text(
                                state.prontoLinha,
                                style: bodyFont(fontSize: 12.5, color: AppColors.accent2_800),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(state.pedidoNome, style: bodyFont(fontSize: 14)),
                              Text(state.pedidoValor, style: bodyFont(fontSize: 14, weight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.divider))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total', style: headingFont(fontSize: 20)),
                              Text(state.pedidoValor, style: headingFont(fontSize: 20)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text('Como você quer pagar?', style: headingFont(fontSize: 15, weight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  for (final o in opcoes) ...[
                    _FormaPagtoOption(
                      icon: o.icon,
                      label: o.label,
                      sub: o.sub,
                      selected: state.formaPagto == o.key,
                      onTap: () => state.escolherFormaPagto(o.key),
                    ),
                    const SizedBox(height: 9),
                  ],
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(22, 13, 22, 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: PrimaryButton(label: state.pagarLabel, onPressed: state.pagarAgora),
          ),
        ],
      ),
    );
  }
}

class _FormaPagtoOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final bool selected;
  final VoidCallback onTap;

  const _FormaPagtoOption({
    required this.icon,
    required this.label,
    required this.sub,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.accent100 : AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: selected ? AppColors.accent : Colors.transparent, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: selected ? AppColors.accent300 : AppColors.neutral200,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: selected ? AppColors.accent900 : AppColors.neutral700),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: bodyFont(fontSize: 14, weight: FontWeight.w700)),
                    Text(sub, style: bodyFont(fontSize: 12, color: textMuted(0.55))),
                  ],
                ),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AppColors.accent : Colors.transparent,
                  border: Border.all(color: selected ? AppColors.accent : AppColors.neutral400, width: 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
