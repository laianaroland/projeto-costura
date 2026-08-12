import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A seamstress ("costureira") shown in search results / map / detail.
class Costureira {
  final String id;
  final String nome;
  final String bairro;
  final double dist;
  final String nota;
  final int avaliacoes;
  final int tintIndex; // 0 or 1 -> picks accent / accent2 tint pair
  final List<String> tags;
  final int desde; // starting price in R$

  const Costureira({
    required this.id,
    required this.nome,
    required this.bairro,
    required this.dist,
    required this.nota,
    required this.avaliacoes,
    required this.tintIndex,
    required this.tags,
    required this.desde,
  });

  String get inicial {
    final semPrefixo = nome.replaceFirst(
      RegExp(r'^(Ateliê|Costura da|Bordados da) '),
      '',
    );
    return semPrefixo.isNotEmpty ? semPrefixo[0] : nome[0];
  }

  Color get tint => tintIndex == 0 ? AppColors.accent300 : AppColors.accent2_300;
  Color get ink => tintIndex == 0 ? AppColors.accent900 : AppColors.accent2_900;

  String get distFmt => '${dist.toString().replaceAll('.', ',')} km';
}

const List<Costureira> kCostureiras = [
  Costureira(
    id: 'c1',
    nome: 'Ateliê Dona Ivete',
    bairro: 'Centro',
    dist: 0.8,
    nota: '4,9',
    avaliacoes: 128,
    tintIndex: 0,
    tags: ['Ajustes', 'Reformas'],
    desde: 25,
  ),
  Costureira(
    id: 'c2',
    nome: 'Costura da Rita',
    bairro: 'Vila Nova',
    dist: 1.6,
    nota: '4,8',
    avaliacoes: 74,
    tintIndex: 1,
    tags: ['Ajustes', 'Sob medida'],
    desde: 30,
  ),
  Costureira(
    id: 'c3',
    nome: 'Ateliê Sônia Reis',
    bairro: 'Jardim Aurora',
    dist: 3.2,
    nota: '5,0',
    avaliacoes: 41,
    tintIndex: 0,
    tags: ['Sob medida', 'Reformas'],
    desde: 90,
  ),
  Costureira(
    id: 'c4',
    nome: 'Márcia Alfaiataria',
    bairro: 'Bela Vista',
    dist: 4.4,
    nota: '4,7',
    avaliacoes: 210,
    tintIndex: 1,
    tags: ['Ajustes', 'Reformas', 'Sob medida'],
    desde: 35,
  ),
  Costureira(
    id: 'c5',
    nome: 'Bordados da Lu',
    bairro: 'Santa Rita',
    dist: 7.4,
    nota: '4,9',
    avaliacoes: 63,
    tintIndex: 0,
    tags: ['Bordado', 'Ajustes'],
    desde: 40,
  ),
];

const kCategorias = ['Ajustes', 'Reformas', 'Sob medida', 'Bordado'];

/// A service offered inside a seamstress's detail sheet (derived from her
/// starting price).
class ServicoDetalhe {
  final String id;
  final String nome;
  final String prazo;
  final int preco;
  const ServicoDetalhe({
    required this.id,
    required this.nome,
    required this.prazo,
    required this.preco,
  });
}

List<ServicoDetalhe> servicosDe(Costureira c) => [
      ServicoDetalhe(id: 'v1', nome: 'Bainha de calça', prazo: 'pronto em 2 dias', preco: c.desde),
      ServicoDetalhe(id: 'v2', nome: 'Ajuste de cintura', prazo: 'pronto em 3 dias', preco: c.desde + 12),
      ServicoDetalhe(id: 'v3', nome: 'Trocar zíper', prazo: 'pronto em 2 dias', preco: c.desde + 18),
      ServicoDetalhe(id: 'v4', nome: 'Reforma completa', prazo: 'pronto em 7 dias', preco: c.desde + 88),
    ];
