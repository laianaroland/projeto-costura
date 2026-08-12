import 'dart:math' as math;

String brl(num n) => 'R\$ ${n.toStringAsFixed(0)}';

String hFmt(double h) {
  final i = h.floor();
  final m = (h % 1 != 0) ? '30' : '00';
  return '${i}h$m';
}

const kDiasOrdem = ['seg', 'ter', 'qua', 'qui', 'sex', 'sab', 'dom'];
const kDiasNome = {
  'seg': 'seg',
  'ter': 'ter',
  'qua': 'qua',
  'qui': 'qui',
  'sex': 'sex',
  'sab': 'sáb',
  'dom': 'dom',
};

/// Human summary of a seamstress's attendance days + hours, e.g.
/// "seg a sáb · 9h00 às 18h00 (fecha 12h–13h)".
String resumoHorario({
  required Set<String> diasAtende,
  required double abre,
  required double fecha,
  required bool almoco,
}) {
  if (diasAtende.isEmpty) return 'Nenhum dia selecionado';
  final ord = kDiasOrdem.where(diasAtende.contains).toList();
  var seq = true;
  for (var i = 1; i < ord.length; i++) {
    if (kDiasOrdem.indexOf(ord[i]) != kDiasOrdem.indexOf(ord[i - 1]) + 1) {
      seq = false;
    }
  }
  final dias = (ord.length > 2 && seq)
      ? '${kDiasNome[ord.first]} a ${kDiasNome[ord.last]}'
      : ord.map((d) => kDiasNome[d]).join(', ');
  final almocoTxt = almoco ? ' (fecha 12h–13h)' : '';
  return '$dias · ${hFmt(abre)} às ${hFmt(fecha)}$almocoTxt';
}

String maskTel(String raw) {
  final d = raw.replaceAll(RegExp(r'\D'), '');
  final v = d.length > 11 ? d.substring(0, 11) : d;
  if (v.length <= 2) return v;
  if (v.length <= 6) return '(${v.substring(0, 2)}) ${v.substring(2)}';
  if (v.length <= 10) {
    return '(${v.substring(0, 2)}) ${v.substring(2, 6)}-${v.substring(6)}';
  }
  return '(${v.substring(0, 2)}) ${v.substring(2, 7)}-${v.substring(7)}';
}

String maskCep(String raw) {
  final d = raw.replaceAll(RegExp(r'\D'), '');
  final v = d.length > 8 ? d.substring(0, 8) : d;
  return v.length > 5 ? '${v.substring(0, 5)}-${v.substring(5)}' : v;
}

class QrCell {
  final int x;
  final int y;
  const QrCell(this.x, this.y);
}

/// Deterministic pseudo-QR pattern (finder squares + timing line + noise),
/// ported from the prototype so the Pix "QR code" looks consistent.
List<QrCell> buildQrCells() {
  const n = 21;
  final cells = <QrCell>[];
  bool finderAt(int r, int c, int br, int bc) {
    return r >= br &&
        r < br + 7 &&
        c >= bc &&
        c < bc + 7 &&
        (r == br ||
            r == br + 6 ||
            c == bc ||
            c == bc + 6 ||
            (r >= br + 2 && r <= br + 4 && c >= bc + 2 && c <= bc + 4));
  }

  bool dark(int r, int c) {
    if (r < 8 && c < 8) return finderAt(r, c, 0, 0);
    if (r < 8 && c > 12) return finderAt(r, c, 0, 14);
    if (r > 12 && c < 8) return finderAt(r, c, 14, 0);
    if (r == 6 || c == 6) return (r + c) % 2 == 0;
    final h = math.sin(r * 12.9898 + c * 78.233) * 43758.5453;
    return (h - h.floorToDouble()) > 0.48;
  }

  for (var r = 0; r < n; r++) {
    for (var c = 0; c < n; c++) {
      if (dark(r, c)) cells.add(QrCell(c + 2, r + 2));
    }
  }
  return cells;
}
