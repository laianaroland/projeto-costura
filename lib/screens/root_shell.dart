import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_tab_bar.dart';
import '../widgets/notif_banner.dart';
import '../widgets/toast_overlay.dart';
import 'busca_screen.dart';
import 'cad_cliente_screen.dart';
import 'cad_pro_step1_screen.dart';
import 'cad_pro_step2_screen.dart';
import 'detail_sheet.dart';
import 'pagamento_sheet.dart';
import 'pagar_pedido_sheet.dart';
import 'pedidos_screen.dart';
import 'perfil_cliente_screen.dart';
import 'perfil_pro_screen.dart';
import 'role_screen.dart';
import 'sucesso_screen.dart';
import 'welcome_screen.dart';

/// Top-level shell: swaps between the prototype's "screens" and layers the
/// detail sheet / notification banner / toast overlays on top, mirroring
/// the original design's z-index stack.
class RootShell extends StatelessWidget {
  const RootShell({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: _ScreenBody(screen: state.screen)),
            if (state.screen == AppScreen.app && state.dp != null)
              const Positioned.fill(child: DetailSheet()),
            NotifBanner(
              visible: state.notif,
              titulo: 'Sua peça está pronta!',
              texto: state.notifTexto,
              onTap: state.abrirNotif,
            ),
            ToastOverlay(message: state.toast),
          ],
        ),
      ),
    );
  }
}

class _ScreenBody extends StatelessWidget {
  final AppScreen screen;
  const _ScreenBody({required this.screen});

  @override
  Widget build(BuildContext context) {
    switch (screen) {
      case AppScreen.welcome:
        return const WelcomeScreen();
      case AppScreen.role:
        return const RoleScreen();
      case AppScreen.cadCli:
        return const CadClienteScreen();
      case AppScreen.cad1:
        return const CadProStep1Screen();
      case AppScreen.cad2:
        return const CadProStep2Screen();
      case AppScreen.app:
        return const _AppShell();
      case AppScreen.pagamento:
        return const PagamentoSheet();
      case AppScreen.sucesso:
        return const SucessoScreen();
      case AppScreen.pagarPedido:
        return const PagarPedidoSheet();
    }
  }
}

class _AppShell extends StatelessWidget {
  const _AppShell();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    Widget body;
    if (state.showBusca) {
      body = const BuscaScreen();
    } else if (state.showPedidos) {
      body = const PedidosScreen();
    } else if (state.showPerfilCli) {
      body = const PerfilClienteScreen();
    } else if (state.showPerfilPro) {
      body = const PerfilProScreen();
    } else {
      body = const SizedBox.shrink();
    }

    return Column(
      children: [
        Expanded(child: body),
        if (state.showTabs)
          BottomTabBar(
            current: state.tab,
            buscaLabel: state.tabBuscaLabel,
            onTap: state.goTab,
          ),
      ],
    );
  }
}
