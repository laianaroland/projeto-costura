import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/costureira.dart';
import '../state/app_state.dart';
import '../state/formatters.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';

class DetailSheet extends StatelessWidget {
  const DetailSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final c = state.dp;
    if (c == null) return const SizedBox.shrink();
    final servicos = state.svcsDoDetalhe;

    return Material(
      color: AppColors.bg,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                    color: c.tint,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RoundIconButton(
                          icon: Icons.chevron_left_rounded,
                          onPressed: state.closeDetail,
                          background: AppColors.bg.withValues(alpha: 0.78),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundColor: AppColors.text.withValues(alpha: 0.09),
                              child: Text(c.inicial, style: headingFont(fontSize: 28, color: c.ink)),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c.nome, style: headingFont(fontSize: 24, height: 1.1)),
                                  Text(
                                    '★ ${c.nota} · ${c.avaliacoes} avaliações · ${c.distFmt}',
                                    style: bodyFont(fontSize: 13, color: textMuted(0.62)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trabalho com máquina reta e overloque há 18 anos. Faço ajuste na hora quando é simples e aviso pelo app quando fica pronto.',
                          style: bodyFont(fontSize: 14, height: 1.55),
                        ),
                        const SizedBox(height: 16),
                        const Row(
                          children: [
                            _FactCard(label: 'ATENDE', value: 'Seg a sáb'),
                            SizedBox(width: 10),
                            _FactCard(label: 'ENTREGA', value: 'Retira ou leva'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text('Serviços e preços', style: headingFont(fontSize: 16, weight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        for (final v in servicos) ...[
                          _ServicoOption(
                            servico: v,
                            selected: state.servicoSelecionado(v.id),
                            quantidade: state.quantidadeDoServico(v.id),
                            onTap: () => state.toggleItemCarrinho(v.id),
                            onInc: () => state.incQuantidade(v.id),
                            onDec: () => state.decQuantidade(v.id),
                          ),
                          const SizedBox(height: 9),
                        ],
                        const SizedBox(height: 12),
                        Text('Endereço', style: headingFont(fontSize: 16, weight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.accent2_200,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Text(
                            'Rua das Acácias, 87 · ${c.bairro} · São Carlos/SP · CEP 13560-120',
                            style: bodyFont(fontSize: 13.5, color: AppColors.accent2_900),
                          ),
                        ),
                      ],
                    ),
                  ),
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
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.selLabel,
                        style: bodyFont(fontSize: 11.5, color: textMuted(0.55)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(state.selTotal, style: headingFont(fontSize: 20)),
                    ],
                  ),
                ),
                PrimaryButton(
                  label: 'Pedir orçamento',
                  onPressed: state.toPagamento,
                  fullWidth: false,
                  fontSize: 15,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FactCard extends StatelessWidget {
  final String label;
  final String value;
  const _FactCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: bodyFont(fontSize: 10.5, weight: FontWeight.w700, color: textMuted(0.52))
                  .copyWith(letterSpacing: 0.6),
            ),
            const SizedBox(height: 2),
            Text(value, style: headingFont(fontSize: 15.5, weight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _ServicoOption extends StatelessWidget {
  final ServicoDetalhe servico;
  final bool selected;
  final int quantidade;
  final VoidCallback onTap;
  final VoidCallback onInc;
  final VoidCallback onDec;

  const _ServicoOption({
    required this.servico,
    required this.selected,
    required this.quantidade,
    required this.onTap,
    required this.onInc,
    required this.onDec,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.accent100 : AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: selected ? AppColors.accent : Colors.transparent, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.accent600 : Colors.transparent,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: selected ? AppColors.accent600 : AppColors.neutral400,
                        width: 2,
                      ),
                    ),
                    child: selected ? const Icon(Icons.check, size: 14, color: AppColors.bg) : null,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(servico.nome, style: bodyFont(fontSize: 14.5, weight: FontWeight.w700)),
                  ),
                  Text(
                    brl(servico.preco * (selected ? quantidade : 1)),
                    style: headingFont(fontSize: 17),
                  ),
                ],
              ),
            ),
            if (selected) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.divider))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quantidade', style: bodyFont(fontSize: 13, weight: FontWeight.w700)),
                    Row(
                      children: [
                        RoundStepperButton(icon: Icons.remove, onPressed: onDec),
                        SizedBox(
                          width: 34,
                          child: Text(
                            '$quantidade',
                            textAlign: TextAlign.center,
                            style: headingFont(fontSize: 16),
                          ),
                        ),
                        RoundStepperButton(icon: Icons.add, onPressed: onInc),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
