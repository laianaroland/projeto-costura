import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';

import '../models/costureira.dart';
import '../models/pedido.dart';
import '../models/servico.dart';
import 'formatters.dart';

enum AppScreen { welcome, role, cadCli, cad1, cad2, app, pagamento, sucesso, pagarPedido }

enum AppTab { busca, pedidos, perfil }

enum Papel { cliente, costureira }

enum Entrega { retirar, receber }

/// Payment method chosen while requesting a quote (the "pagamento" sheet).
enum FormaPagamento { pix, cartao, entrega }

/// Payment method chosen when settling a ready order (the "pagarPedido" sheet).
enum FormaPagto { pix, credito, debito, dinheiro }

enum Vista { mapa, lista }

/// Single source of truth for the whole prototype, mirroring the state
/// machine of the original Claude Design canvas 1:1 (state fields, derived
/// values, actions) so the flow behaves identically.
class AppState extends ChangeNotifier {
  AppScreen screen = AppScreen.welcome;
  Papel? papel;
  AppTab tab = AppTab.busca;
  String? openId;
  String? filtro;
  int raio = 5;
  bool loading = false;
  String? servicoSel;
  int quantidade = 1;
  Entrega entrega = Entrega.retirar;
  FormaPagamento pagamento = FormaPagamento.pix;
  Pedido? pedido;
  bool disponivel = true;
  String? toast;
  bool notif = false;
  FormaPagto formaPagto = FormaPagto.pix;
  Vista vista = Vista.mapa;

  ClienteInfo cli = const ClienteInfo();

  bool novoAberto = false;
  String novoNome = '';
  int novoPreco = 30;

  bool cepBuscado = false;

  Set<String> diasAtende = {'seg', 'ter', 'qua', 'qui', 'sex', 'sab'};
  double abre = 9;
  double fecha = 18;
  bool almoco = true;

  List<Servico> servicos = defaultServicos();

  Timer? _toastTimer;
  Timer? _loadTimer;

  @override
  void dispose() {
    _toastTimer?.cancel();
    _loadTimer?.cancel();
    super.dispose();
  }

  // ── generic helpers ──────────────────────────────────────────────────

  void flash(String msg) {
    _toastTimer?.cancel();
    toast = msg;
    notifyListeners();
    _toastTimer = Timer(const Duration(milliseconds: 2200), () {
      toast = null;
      notifyListeners();
    });
  }

  /// Applies [patch] immediately, flips [loading] on, notifies, then turns
  /// it back off ~750ms later (mirrors the prototype's fake network delay).
  void load(void Function() patch) {
    patch();
    loading = true;
    notifyListeners();
    _loadTimer?.cancel();
    _loadTimer = Timer(const Duration(milliseconds: 750), () {
      loading = false;
      notifyListeners();
    });
  }

  void setCli(ClienteInfo Function(ClienteInfo) patch) {
    cli = patch(cli);
    notifyListeners();
  }

  // ── navigation ────────────────────────────────────────────────────────

  void toWelcome() {
    screen = AppScreen.welcome;
    papel = null;
    tab = AppTab.busca;
    notifyListeners();
  }

  void toRole() {
    screen = AppScreen.role;
    notifyListeners();
  }

  void back() {
    screen = screen == AppScreen.cad2 ? AppScreen.cad1 : AppScreen.role;
    notifyListeners();
  }

  void setPapel(Papel p) {
    papel = p;
    notifyListeners();
  }

  void confirmRole() {
    if (papel == null) return flash('Escolha um dos dois para continuar');
    screen = papel == Papel.costureira ? AppScreen.cad1 : AppScreen.cadCli;
    notifyListeners();
  }

  // ── cliente signup ──────────────────────────────────────────────────

  void setNome(String v) => setCli((c) => c.copyWith(nome: v));
  void setTel(String v) => setCli((c) => c.copyWith(tel: maskTel(v)));
  void setNum(String v) => setCli((c) => c.copyWith(num: v.replaceAll(RegExp(r'\D'), '')));
  void setCompl(String v) => setCli((c) => c.copyWith(compl: v));

  void setCep(String v) {
    final masked = maskCep(v);
    setCli((c) => c.copyWith(
          cep: masked,
          achou: masked.replaceAll(RegExp(r'\D'), '').length == 8,
        ));
  }

  void buscarCepCli() {
    if (cli.cep.replaceAll(RegExp(r'\D'), '').length < 8) {
      return flash('Digite os 8 números do CEP');
    }
    setCli((c) => c.copyWith(achou: true));
    flash('Rua e bairro preenchidos pelo CEP');
  }

  void setMoradia(String key) => setCli((c) => c.copyWith(moradia: key));

  void salvarCadastro() {
    final c = cli;
    if (c.nome.trim().isEmpty) return flash('Falta o nome completo');
    if (c.tel.replaceAll(RegExp(r'\D'), '').length < 10) return flash('Confira o telefone');
    if (!c.achou) return flash('Busque o CEP para completar o endereço');
    if (c.num.trim().isEmpty) return flash('Falta o número da casa');
    if (c.moradia == null) return flash('Escolha casa, apartamento ou outro');
    load(() {
      screen = AppScreen.app;
      tab = AppTab.busca;
      vista = Vista.mapa;
    });
    flash('Cadastro salvo — bem-vinda, ${c.nome.trim().split(' ').first}!');
  }

  // ── costureira signup: step 1 (services) ────────────────────────────

  void toggleServico(String id) {
    servicos = servicos.map((s) => s.id == id ? s.copyWith(on: !s.on) : s).toList();
    notifyListeners();
  }

  void incServico(String id) {
    servicos = servicos.map((s) => s.id == id ? s.copyWith(preco: s.preco + 5) : s).toList();
    notifyListeners();
  }

  void decServico(String id) {
    servicos = servicos
        .map((s) => s.id == id ? s.copyWith(preco: math.max(5, s.preco - 5)) : s)
        .toList();
    notifyListeners();
  }

  void abrirNovo() {
    novoAberto = true;
    notifyListeners();
  }

  void cancelarNovo() {
    novoAberto = false;
    novoNome = '';
    novoPreco = 30;
    notifyListeners();
  }

  void setNovoNome(String v) {
    novoNome = v;
    notifyListeners();
  }

  void novoInc() {
    novoPreco += 5;
    notifyListeners();
  }

  void novoDec() {
    novoPreco = math.max(5, novoPreco - 5);
    notifyListeners();
  }

  void salvarNovo() {
    final nome = novoNome.trim();
    if (nome.isEmpty) return flash('Escreva o nome do serviço');
    servicos = [
      ...servicos,
      Servico(id: 'n${DateTime.now().microsecondsSinceEpoch}', nome: nome, preco: novoPreco, on: true),
    ];
    novoAberto = false;
    novoNome = '';
    novoPreco = 30;
    notifyListeners();
    flash('$nome adicionado aos seus serviços');
  }

  List<Servico> get meusServicosAtivos => servicos.where((s) => s.on).toList();

  String get cad1Cta {
    final n = meusServicosAtivos.length;
    return n > 0 ? 'Continuar · $n serviços' : 'Marque ao menos um serviço';
  }

  void toCad2() {
    if (meusServicosAtivos.isEmpty) return flash('Marque ao menos um serviço');
    screen = AppScreen.cad2;
    notifyListeners();
  }

  // ── costureira signup: step 2 (address + hours) ─────────────────────

  static const _cepFixo = '13560-120';
  String get cep => _cepFixo;
  String get cepCta => cepBuscado ? 'Achou!' : 'Buscar';

  void buscarCep() {
    cepBuscado = true;
    notifyListeners();
    flash('Endereço preenchido pelo CEP');
  }

  void toggleDia(String dia) {
    diasAtende = diasAtende.contains(dia)
        ? (diasAtende.toSet()..remove(dia))
        : (diasAtende.toSet()..add(dia));
    notifyListeners();
  }

  void abreInc() {
    abre = (fecha - 1 < abre + 0.5) ? fecha - 1 : abre + 0.5;
    notifyListeners();
  }

  void abreDec() {
    abre = (abre - 0.5) < 5 ? 5 : abre - 0.5;
    notifyListeners();
  }

  void fechaInc() {
    fecha = (fecha + 0.5) > 23 ? 23 : fecha + 0.5;
    notifyListeners();
  }

  void fechaDec() {
    fecha = (abre + 1 > fecha - 0.5) ? abre + 1 : fecha - 0.5;
    notifyListeners();
  }

  void toggleAlmoco() {
    almoco = !almoco;
    notifyListeners();
  }

  String get resumoHorarioTexto =>
      resumoHorario(diasAtende: diasAtende, abre: abre, fecha: fecha, almoco: almoco);

  void finishCad() {
    if (diasAtende.isEmpty) return flash('Escolha ao menos um dia de atendimento');
    load(() {
      screen = AppScreen.app;
      tab = AppTab.perfil;
    });
    flash('Perfil publicado — você já aparece na busca');
  }

  // ── busca (search) ───────────────────────────────────────────────────

  List<Costureira> get visiveis => kCostureiras
      .where((p) => p.dist <= raio && (filtro == null || p.tags.contains(filtro)))
      .toList();

  Costureira? get dp {
    if (openId == null) return null;
    for (final p in kCostureiras) {
      if (p.id == openId) return p;
    }
    return null;
  }

  List<ServicoDetalhe> get svcsDoDetalhe {
    final d = dp;
    return d == null ? const [] : servicosDe(d);
  }

  ServicoDetalhe? get sel {
    if (servicoSel == null) return null;
    for (final v in svcsDoDetalhe) {
      if (v.id == servicoSel) return v;
    }
    return null;
  }

  int get frete => entrega == Entrega.receber ? 9 : 0;

  void toggleFiltro(String c) {
    load(() => filtro = filtro == c ? null : c);
  }

  String get raioLabel => 'Até $raio km';

  void cycleRaio() {
    load(() => raio = raio == 5 ? 10 : (raio == 10 ? 2 : 5));
  }

  void ampliarRaio() {
    load(() => raio = 10);
  }

  bool get isLoadingLista => loading && vista == Vista.lista;
  bool get isEmptyLista => !loading && visiveis.isEmpty && vista == Vista.lista;
  bool get hasResults => !loading && visiveis.isNotEmpty && vista == Vista.lista;
  bool get vistaMapa => !loading && vista == Vista.mapa;

  void verMapa() {
    vista = Vista.mapa;
    notifyListeners();
  }

  void verLista() {
    vista = Vista.lista;
    notifyListeners();
  }

  void abrirDetalhe(String id) {
    openId = id;
    servicoSel = null;
    quantidade = 1;
    notifyListeners();
  }

  void closeDetail() {
    openId = null;
    notifyListeners();
  }

  void selecionarServico(String id) {
    servicoSel = id;
    quantidade = 1;
    notifyListeners();
  }

  void incQuantidade() {
    quantidade++;
    notifyListeners();
  }

  void decQuantidade() {
    quantidade = math.max(1, quantidade - 1);
    notifyListeners();
  }

  String get selLabel =>
      sel != null ? (quantidade > 1 ? '${sel!.nome} × $quantidade' : sel!.nome) : 'Escolha um serviço';
  String get selTotal => sel != null ? brl(sel!.preco * quantidade) : '—';

  void toPagamento() {
    if (sel == null) return flash('Toque em um serviço para escolher');
    screen = AppScreen.pagamento;
    notifyListeners();
  }

  // ── pagamento (quote checkout) ───────────────────────────────────────

  void closePagamento() {
    screen = AppScreen.app;
    notifyListeners();
  }

  int get total => (sel?.preco ?? 0) * quantidade + frete;

  void escolherEntrega(Entrega e) {
    entrega = e;
    if (e == Entrega.receber && pagamento == FormaPagamento.entrega) {
      pagamento = FormaPagamento.pix;
    }
    notifyListeners();
  }

  bool get avisoEntrega => entrega == Entrega.receber;
  bool get mostraQr => pagamento == FormaPagamento.pix;

  void escolherPagamento(FormaPagamento p) {
    if (entrega == Entrega.receber && p == FormaPagamento.entrega) {
      return flash('Entrega em casa só com Pix ou cartão de crédito');
    }
    pagamento = p;
    notifyListeners();
  }

  String get pixCodigo =>
      '00020126BR.GOV.BCB.PIX0136minhacostureira${sel?.id ?? 'x'}5204000053039865802BR6009SAOCARLOS62070503***6304A1B2';

  void copiarPix() => flash('Código Pix copiado');

  String get confirmarLabel => 'Confirmar · ${brl(total)}';

  void confirmar() {
    final s = sel;
    final d = dp;
    final qtd = quantidade;
    screen = AppScreen.sucesso;
    pedido = (s != null && d != null)
        ? Pedido(
            nome: qtd > 1 ? '${s.nome} × $qtd' : s.nome,
            quem: d.nome,
            prazo: s.prazo,
            valor: brl(s.preco * qtd + frete),
          )
        : null;
    notifyListeners();
  }

  // ── sucesso ───────────────────────────────────────────────────────────

  String get sucessoTexto {
    final d = dp;
    return d != null
        ? '${d.nome} recebeu seu pedido e responde em até 1 hora.'
        : 'A costureira responde em até 1 hora.';
  }

  void verPedidos() {
    screen = AppScreen.app;
    tab = AppTab.pedidos;
    openId = null;
    notifyListeners();
  }

  void voltarBusca() {
    screen = AppScreen.app;
    tab = AppTab.busca;
    openId = null;
    notifyListeners();
  }

  // ── pedidos ───────────────────────────────────────────────────────────

  bool get isCliente => papel == Papel.cliente;

  String get pedidosTitulo => isCliente ? 'Seus pedidos' : 'Pedidos recebidos';
  bool get semPedidos => isCliente && pedido == null;

  void tapPedidoCliente() {
    final p = pedido;
    if (p == null) return;
    if (p.pago) {
      flash('Recibo enviado no seu e-mail');
    } else if (p.pronto) {
      screen = AppScreen.pagarPedido;
      notifyListeners();
    } else {
      flash('Rita responde em até 1 hora');
    }
  }

  void aceitarPedidoMock() => flash('Pedido aceito — o cliente foi avisado');

  void marcarPronto(String nome, String quem, String valor) {
    final atual = pedido;
    pedido = Pedido(
      nome: nome,
      quem: (isCliente && atual != null) ? atual.quem : 'Costura da Rita',
      prazo: 'pronta para retirar',
      valor: atual?.valor ?? valor,
      pronto: true,
      pago: false,
    );
    notif = true;
    notifyListeners();
    flash('Cliente avisada — notificação enviada');
  }

  // ── perfil (pro) ─────────────────────────────────────────────────────

  void toggleDisp() {
    disponivel = !disponivel;
    notifyListeners();
  }

  void editarServicos() {
    screen = AppScreen.cad1;
    notifyListeners();
  }

  static const enderecoLinha = 'Rua das Acácias, 87 · Vila Nova · São Carlos/SP · 13560-120';

  // ── perfil (cliente) ─────────────────────────────────────────────────

  String get cliPerfilNome => cli.nome.trim().isNotEmpty ? cli.nome.trim() : 'Ana Duarte';
  String get cliPerfilTel => cli.tel.isNotEmpty ? cli.tel : '(16) 99999-0000';

  void virarPro() {
    screen = AppScreen.cad1;
    papel = Papel.costureira;
    notifyListeners();
  }

  // ── notificação ──────────────────────────────────────────────────────

  String get notifTexto =>
      '${pedido != null ? pedido!.quem : 'A costureira'} terminou o serviço — confira e escolha como pagar.';

  void abrirNotif() {
    notif = false;
    papel = Papel.cliente;
    screen = AppScreen.pagarPedido;
    tab = AppTab.pedidos;
    openId = null;
    notifyListeners();
  }

  // ── pagarPedido ──────────────────────────────────────────────────────

  void fecharPagarPedido() {
    screen = AppScreen.app;
    tab = AppTab.pedidos;
    notifyListeners();
  }

  String get prontoLinha =>
      pedido != null ? '${pedido!.quem} · retirar até sexta, 18h' : 'Retirar até sexta, 18h';
  String get pedidoNome => pedido?.nome ?? 'Serviço';
  String get pedidoValor => pedido?.valor ?? 'R\$ 0';

  void escolherFormaPagto(FormaPagto f) {
    formaPagto = f;
    notifyListeners();
  }

  String get pagarLabel =>
      formaPagto == FormaPagto.dinheiro ? 'Confirmar retirada e pagar lá' : 'Pagar $pedidoValor';

  void pagarAgora() {
    final dinheiro = formaPagto == FormaPagto.dinheiro;
    screen = AppScreen.app;
    tab = AppTab.pedidos;
    if (pedido != null) {
      pedido = pedido!.copyWith(pago: !dinheiro, pronto: true);
    }
    notifyListeners();
    flash(dinheiro ? 'Combinado! Pague na retirada.' : 'Pagamento aprovado — pode retirar');
  }

  // ── tabs / screen visibility ─────────────────────────────────────────

  void goTab(AppTab t) {
    tab = t;
    openId = null;
    notifyListeners();
  }

  bool get showTabs => screen == AppScreen.app;

  /// Search tab is client-only; a seamstress's "busca" tab doubles as her
  /// inbox home, so it renders the pedidos list instead.
  bool get showBusca => screen == AppScreen.app && tab == AppTab.busca && isCliente;
  bool get showPedidos =>
      screen == AppScreen.app && (tab == AppTab.pedidos || (!isCliente && tab == AppTab.busca));
  bool get showPerfilCli => screen == AppScreen.app && tab == AppTab.perfil && isCliente;
  bool get showPerfilPro => screen == AppScreen.app && tab == AppTab.perfil && !isCliente;

  String get tabBuscaLabel => isCliente ? 'Buscar' : 'Início';
}
