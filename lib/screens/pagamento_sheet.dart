import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../state/formatters.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/qr_code_painter.dart';

class PagamentoSheet extends StatelessWidget {
  const PagamentoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final itens = state.itensSelecionados;

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
                      RoundIconButton(icon: Icons.chevron_left_rounded, onPressed: state.closePagamento),
                      const SizedBox(width: 10),
                      Text('Fechar pedido', style: headingFont(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Column(
                      children: [
                        for (final it in itens)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    it.qtd > 1 ? '${it.servico.nome} × ${it.qtd}' : it.servico.nome,
                                    style: bodyFont(fontSize: 14),
                                  ),
                                ),
                                Text(
                                  brl(it.servico.preco * it.qtd),
                                  style: bodyFont(fontSize: 14, weight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.entrega == Entrega.receber ? 'Receber em casa' : 'Retirar no ateliê',
                                style: bodyFont(fontSize: 13, color: textMuted(0.58)),
                              ),
                              Text(
                                state.frete > 0 ? brl(state.frete) : 'grátis',
                                style: bodyFont(fontSize: 13, color: textMuted(0.58)),
                              ),
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
                              Text(brl(state.total), style: headingFont(fontSize: 20)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text('Entrega', style: headingFont(fontSize: 15, weight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _EntregaOption(
                          label: 'Retiro lá',
                          sub: 'sem custo',
                          selected: state.entrega == Entrega.retirar,
                          onTap: () => state.escolherEntrega(Entrega.retirar),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _EntregaOption(
                          label: 'Receber em casa',
                          sub: '+ R\$ 9',
                          selected: state.entrega == Entrega.receber,
                          onTap: () => state.escolherEntrega(Entrega.receber),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text('Pagamento', style: headingFont(fontSize: 15, weight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  if (state.avisoEntrega)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.accent2_200,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.accent2_800),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Para receber em casa, o pagamento é adiantado — só Pix ou cartão de crédito.',
                              style: bodyFont(fontSize: 12.5, color: AppColors.accent2_900),
                            ),
                          ),
                        ],
                      ),
                    ),
                  _PagamentoOption(
                    label: 'Pix',
                    sub: 'aprovação na hora',
                    selected: state.pagamento == FormaPagamento.pix,
                    onTap: () => state.escolherPagamento(FormaPagamento.pix),
                  ),
                  const SizedBox(height: 9),
                  _PagamentoOption(
                    label: 'Cartão de crédito',
                    sub: 'até 2x sem juros',
                    selected: state.pagamento == FormaPagamento.cartao,
                    onTap: () => state.escolherPagamento(FormaPagamento.cartao),
                  ),
                  const SizedBox(height: 9),
                  _PagamentoOption(
                    label: 'Pagar na retirada',
                    sub: state.entrega == Entrega.receber
                        ? 'indisponível para entrega em casa'
                        : 'dinheiro, débito ou maquininha',
                    selected: state.pagamento == FormaPagamento.entrega,
                    dimmed: state.entrega == Entrega.receber,
                    onTap: () => state.escolherPagamento(FormaPagamento.entrega),
                  ),
                  if (state.mostraQr) _QrPanel(state: state),
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
            child: PrimaryButton(label: state.confirmarLabel, onPressed: state.confirmar),
          ),
        ],
      ),
    );
  }
}

class _EntregaOption extends StatelessWidget {
  final String label;
  final String sub;
  final bool selected;
  final VoidCallback onTap;
  const _EntregaOption({required this.label, required this.sub, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.accent100 : AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: selected ? AppColors.accent : Colors.transparent, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: bodyFont(fontSize: 13.5, weight: FontWeight.w700)),
              Text(sub, style: bodyFont(fontSize: 12, color: textMuted(0.55))),
            ],
          ),
        ),
      ),
    );
  }
}

class _PagamentoOption extends StatelessWidget {
  final String label;
  final String sub;
  final bool selected;
  final bool dimmed;
  final VoidCallback onTap;
  const _PagamentoOption({
    required this.label,
    required this.sub,
    required this.selected,
    required this.onTap,
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: dimmed ? 0.45 : 1,
      child: Material(
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
                Container(width: 34, height: 34, decoration: const BoxDecoration(color: AppColors.accent200, shape: BoxShape.circle)),
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
      ),
    );
  }
}

class _QrPanel extends StatelessWidget {
  final AppState state;
  const _QrPanel({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(18),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          Text('Pague com o QR Code', style: bodyFont(fontSize: 13.5, weight: FontWeight.w700)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const QrCodePainter(),
          ),
          const SizedBox(height: 12),
          Text(
            'Válido por 30 minutos · ${brl(state.total)}',
            style: bodyFont(fontSize: 12, color: textMuted(0.55)),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(AppRadius.pill)),
            child: Text(
              state.pixCodigo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11.5),
            ),
          ),
          const SizedBox(height: 10),
          SecondaryButton(
            label: 'Copiar código Pix',
            onPressed: state.copiarPix,
            fullWidth: false,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            fontSize: 13.5,
          ),
        ],
      ),
    );
  }
}
