/// A service in a seamstress's own catalog (screen "cad1" / profile).
class Servico {
  final String id;
  final String nome;
  final int preco;
  final bool on;

  const Servico({
    required this.id,
    required this.nome,
    required this.preco,
    this.on = true,
  });

  Servico copyWith({String? nome, int? preco, bool? on}) => Servico(
        id: id,
        nome: nome ?? this.nome,
        preco: preco ?? this.preco,
        on: on ?? this.on,
      );
}

List<Servico> defaultServicos() => const [
      Servico(id: 'a', nome: 'Bainha de calça', preco: 25, on: true),
      Servico(id: 'b', nome: 'Ajuste de cintura', preco: 35, on: true),
      Servico(id: 'c', nome: 'Trocar zíper', preco: 40, on: true),
      Servico(id: 'd', nome: 'Reforma de vestido', preco: 120, on: false),
      Servico(id: 'e', nome: 'Roupa sob medida', preco: 260, on: false),
      Servico(id: 'f', nome: 'Bordado à mão', preco: 60, on: false),
    ];
