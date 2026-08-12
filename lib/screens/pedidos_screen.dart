import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/illustrations.dart';

class PedidosScreen extends StatelessWidget {
  const PedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(state.pedidosTitulo, style: headingFont(fontSize: 26)),
          const SizedBox(height: 14),
          if (state.isCliente) ..._clienteCards(state) else ..._proCards(state),
          if (state.semPedidos) _EmptyPedidos(),
        ],
      ),
    );
  }

  List<Widget> _clienteCards(AppState state) {
    final p = state.pedido;
    if (p == null) return const [];
    final statusBg = p.pronto ? AppColors.accent2_200 : AppColors.accent200;
    final statusInk = p.pronto ? AppColors.accent2_800 : AppColors.accent800;
    final status = p.pago ? 'Pago' : (p.pronto ? 'Pronta para retirar' : 'Aguardando aceite');
    final prazo = p.pago ? 'pago · retirar até sexta' : p.prazo;
    final acao = p.pago ? 'Ver recibo' : (p.pronto ? 'Conferir e pagar' : 'Ver detalhes');
    return [
      _PedidoCard(
        titulo: p.nome,
        quem: p.quem,
        prazo: prazo,
        valor: p.valor,
        status: status,
        statusBg: statusBg,
        statusInk: statusInk,
        acao: acao,
        onTap: state.tapPedidoCliente,
      ),
    ];
  }

  List<Widget> _proCards(AppState state) {
    return [
      _PedidoCard(
        titulo: 'Bainha de calça · 2 peças',
        quem: 'Ana Duarte',
        prazo: 'entrega sexta',
        valor: 'R\$ 50',
        status: 'Novo',
        statusBg: AppColors.accent200,
        statusInk: AppColors.accent800,
        acao: 'Aceitar',
        onTap: state.aceitarPedidoMock,
      ),
      const SizedBox(height: 12),
      _PedidoCard(
        titulo: 'Reforma de vestido',
        quem: 'Cleide M.',
        prazo: 'entrega 20/08',
        valor: 'R\$ 120',
        status: 'Em costura',
        statusBg: AppColors.accent2_200,
        statusInk: AppColors.accent2_800,
        acao: 'Marcar pronto',
        onTap: () => state.marcarPronto('Reforma de vestido', 'Cleide M.', 'R\$ 120'),
      ),
    ];
  }
}

class _PedidoCard extends StatelessWidget {
  final String titulo;
  final String quem;
  final String prazo;
  final String valor;
  final String status;
  final Color statusBg;
  final Color statusInk;
  final String acao;
  final VoidCallback onTap;

  const _PedidoCard({
    required this.titulo,
    required this.quem,
    required this.prazo,
    required this.valor,
    required this.status,
    required this.statusBg,
    required this.statusInk,
    required this.acao,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(titulo, style: bodyFont(fontSize: 15, weight: FontWeight.w700))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(AppRadius.pill)),
                child: Text(status, style: bodyFont(fontSize: 11.5, weight: FontWeight.w700, color: statusInk)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('$quem · $prazo', style: bodyFont(fontSize: 13, color: textMuted(0.58))),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              padding: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.divider))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(valor, style: headingFont(fontSize: 18)),
                  GhostButton(label: acao, onPressed: onTap, fontSize: 13.5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPedidos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            const SoftIconBadge(icon: Icons.inventory_2_outlined, size: 120),
            const SizedBox(height: 12),
            Text('Nada em andamento', style: headingFont(fontSize: 18)),
            const SizedBox(height: 4),
            Text(
              'Quando você pedir um orçamento, ele aparece aqui.',
              textAlign: TextAlign.center,
              style: bodyFont(fontSize: 13.5, color: textMuted(0.58)),
            ),
          ],
        ),
      ),
    );
  }
}
