/// An in-flight order, shared between the client and seamstress "pedidos" views.
class Pedido {
  final String nome;
  final String quem;
  final String prazo;
  final String valor;
  final bool pronto;
  final bool pago;

  const Pedido({
    required this.nome,
    required this.quem,
    required this.prazo,
    required this.valor,
    this.pronto = false,
    this.pago = false,
  });

  Pedido copyWith({
    String? nome,
    String? quem,
    String? prazo,
    String? valor,
    bool? pronto,
    bool? pago,
  }) =>
      Pedido(
        nome: nome ?? this.nome,
        quem: quem ?? this.quem,
        prazo: prazo ?? this.prazo,
        valor: valor ?? this.valor,
        pronto: pronto ?? this.pronto,
        pago: pago ?? this.pago,
      );
}

/// Client registration data collected on the "cadCli" screen.
class ClienteInfo {
  final String nome;
  final String tel;
  final String cep;
  final String num;
  final String compl;
  final String? moradia; // 'casa' | 'apto' | 'outro'
  final bool achou; // whether CEP lookup has "found" an address

  const ClienteInfo({
    this.nome = '',
    this.tel = '',
    this.cep = '',
    this.num = '',
    this.compl = '',
    this.moradia,
    this.achou = false,
  });

  ClienteInfo copyWith({
    String? nome,
    String? tel,
    String? cep,
    String? num,
    String? compl,
    String? moradia,
    bool? achou,
  }) =>
      ClienteInfo(
        nome: nome ?? this.nome,
        tel: tel ?? this.tel,
        cep: cep ?? this.cep,
        num: num ?? this.num,
        compl: compl ?? this.compl,
        moradia: moradia ?? this.moradia,
        achou: achou ?? this.achou,
      );
}
