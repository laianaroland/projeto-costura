import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/costureira.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/illustrations.dart';

class BuscaScreen extends StatelessWidget {
  const BuscaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final visiveis = state.visiveis;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 18, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 14, color: textMuted(0.55)),
                    const SizedBox(width: 5),
                    Text(
                      'Rua das Palmeiras, 240 · Centro',
                      style: bodyFont(fontSize: 12, color: textMuted(0.55)),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text('Costureiras perto de você', style: headingFont(fontSize: 26)),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded, size: 18, color: textMuted(0.55)),
                      const SizedBox(width: 9),
                      Text('Bainha, zíper, vestido…', style: bodyFont(fontSize: 14.5, color: textMuted(0.55))),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              itemCount: kCategorias.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final c = kCategorias[i];
                final active = state.filtro == c;
                return _FiltroChip(
                  label: c,
                  active: active,
                  onTap: () => state.toggleFiltro(c),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    visiveis.isNotEmpty ? '${visiveis.length} costureiras encontradas' : 'Nenhum resultado',
                    style: bodyFont(fontSize: 12.5, weight: FontWeight.w700, color: textMuted(0.55)),
                  ),
                ),
                TextButton(
                  onPressed: state.cycleRaio,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                  ),
                  child: Text(state.raioLabel, style: headingFont(fontSize: 13, color: AppColors.accent)),
                ),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Row(
                    children: [
                      _ViewToggleButton(label: 'Mapa', active: state.vista == Vista.mapa, onTap: state.verMapa),
                      _ViewToggleButton(label: 'Lista', active: state.vista == Vista.lista, onTap: state.verLista),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (state.vistaMapa) _MapaView(state: state, visiveis: visiveis),
          if (state.isLoadingLista) const _LoadingSkeletons(),
          if (state.isEmptyLista) _EmptyState(onAmpliar: state.ampliarRaio),
          if (state.hasResults) _ResultsList(visiveis: visiveis, onOpen: state.abrirDetalhe),
        ],
      ),
    );
  }
}

class _FiltroChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _FiltroChip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.accent500 : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: active ? AppColors.accent500 : AppColors.divider),
          ),
          child: Text(
            label,
            style: bodyFont(
              fontSize: 13,
              weight: FontWeight.w700,
              color: active ? AppColors.bg : AppColors.text,
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewToggleButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _ViewToggleButton({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.accent500 : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            label,
            style: bodyFont(
              fontSize: 12.5,
              weight: FontWeight.w700,
              color: active ? AppColors.bg : textMuted(0.6),
            ),
          ),
        ),
      ),
    );
  }
}

const _pinPositions = [
  (0.30, 0.26),
  (0.64, 0.20),
  (0.22, 0.62),
  (0.72, 0.54),
  (0.46, 0.80),
];

class _MapaView extends StatelessWidget {
  final AppState state;
  final List<Costureira> visiveis;
  const _MapaView({required this.state, required this.visiveis});

  @override
  Widget build(BuildContext context) {
    final pins = visiveis.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 6, 22, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: SizedBox(
              height: 340,
              child: Stack(
                children: [
                  Positioned.fill(child: CustomPaint(painter: _MapBackgroundPainter())),
                  for (var i = 0; i < pins.length; i++)
                    Align(
                      alignment: Alignment(
                        _pinPositions[i].$1 * 2 - 1,
                        _pinPositions[i].$2 * 2 - 1,
                      ),
                      child: _MapPin(
                        costureira: pins[i],
                        highlight: i == 0,
                        onTap: () => state.abrirDetalhe(pins[i].id),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
          child: Text(
            'Toque em um marcador para ver os serviços e preços.',
            style: bodyFont(fontSize: 12.5, color: textMuted(0.55)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
          child: Column(
            children: visiveis.take(3).map((c) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _CompactResultCard(costureira: c, onTap: () => state.abrirDetalhe(c.id)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.accent2_200);
    final road = Paint()
      ..color = AppColors.bg
      ..strokeWidth = 14;
    for (final f in [0.27, 0.63, 0.86]) {
      canvas.drawLine(Offset(0, size.height * f), Offset(size.width, size.height * f), road);
    }
    for (final f in [0.29, 0.68]) {
      canvas.drawLine(Offset(size.width * f, 0), Offset(size.width * f, size.height), road);
    }
    final diag = Paint()
      ..color = AppColors.bg
      ..strokeWidth = 20;
    canvas.drawLine(Offset(0, size.height * 0.47), Offset(size.width, size.height * 0.12), diag);

    final center = Offset(size.width * 0.49, size.height * 0.5);
    canvas.drawCircle(center, size.width * 0.21, Paint()..color = AppColors.accent.withValues(alpha: 0.14));
    canvas.drawCircle(center, 5, Paint()..color = AppColors.accent600);
    canvas.drawCircle(
      center,
      9,
      Paint()
        ..color = AppColors.accent600.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant _MapBackgroundPainter oldDelegate) => false;
}

class _MapPin extends StatelessWidget {
  final Costureira costureira;
  final bool highlight;
  final VoidCallback onTap;
  const _MapPin({required this.costureira, required this.highlight, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = highlight ? AppColors.accent600 : AppColors.bg;
    final fg = highlight ? AppColors.bg : AppColors.text;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(6, 6, 11, 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: AppShadows.md,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: costureira.tint,
                child: Text(
                  costureira.inicial,
                  style: headingFont(fontSize: 13, color: costureira.ink),
                ),
              ),
              const SizedBox(width: 7),
              Text(
                'R\$ ${costureira.desde}',
                style: bodyFont(fontSize: 12.5, weight: FontWeight.w700, color: fg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactResultCard extends StatelessWidget {
  final Costureira costureira;
  final VoidCallback onTap;
  const _CompactResultCard({required this.costureira, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: costureira.tint,
                child: Text(costureira.inicial, style: headingFont(fontSize: 17, color: costureira.ink)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(costureira.nome, style: bodyFont(fontSize: 14.5, weight: FontWeight.w700)),
                    Text(
                      '${costureira.bairro} · ${costureira.distFmt} · ★ ${costureira.nota}',
                      style: bodyFont(fontSize: 12, color: textMuted(0.55)),
                    ),
                  ],
                ),
              ),
              Text('R\$ ${costureira.desde}', style: bodyFont(fontSize: 12.5, weight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingSkeletons extends StatelessWidget {
  const _LoadingSkeletons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
      child: Column(
        children: List.generate(
          3,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: _ShimmerRow(),
          ),
        ),
      ),
    );
  }
}

class _ShimmerRow extends StatefulWidget {
  const _ShimmerRow();

  @override
  State<_ShimmerRow> createState() => _ShimmerRowState();
}

class _ShimmerRowState extends State<_ShimmerRow> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.45, end: 0.9).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut)),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
        child: Row(
          children: [
            Container(width: 52, height: 52, decoration: const BoxDecoration(color: AppColors.neutral300, shape: BoxShape.circle)),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 13, width: 140, decoration: BoxDecoration(color: AppColors.neutral300, borderRadius: BorderRadius.circular(999))),
                  const SizedBox(height: 8),
                  Container(height: 11, width: 190, decoration: BoxDecoration(color: AppColors.neutral200, borderRadius: BorderRadius.circular(999))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAmpliar;
  const _EmptyState({required this.onAmpliar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
      child: Column(
        children: [
          const SoftIconBadge(icon: Icons.search_off_rounded, size: 130),
          const SizedBox(height: 10),
          Text('Ninguém por perto com esse serviço', style: headingFont(fontSize: 19)),
          const SizedBox(height: 6),
          Text(
            'Bordado mais próximo está a 7,4 km. Aumente o raio ou tire o filtro.',
            textAlign: TextAlign.center,
            style: bodyFont(fontSize: 13.5, color: textMuted(0.58)),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: onAmpliar,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.bg,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: const StadiumBorder(),
            ),
            child: Text('Buscar em 10 km', style: headingFont(fontSize: 14, color: AppColors.bg)),
          ),
        ],
      ),
    );
  }
}

class _ResultsList extends StatelessWidget {
  final List<Costureira> visiveis;
  final ValueChanged<String> onOpen;
  const _ResultsList({required this.visiveis, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: visiveis.map((c) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                onTap: () => onOpen(c.id),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 27,
                        backgroundColor: c.tint,
                        child: Text(c.inicial, style: headingFont(fontSize: 21, color: c.ink)),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(c.nome, style: bodyFont(fontSize: 15.5, weight: FontWeight.w700)),
                                const SizedBox(width: 6),
                                Text(
                                  '★ ${c.nota}',
                                  style: bodyFont(fontSize: 12.5, weight: FontWeight.w700, color: AppColors.accent700),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${c.bairro} · ${c.distFmt}',
                              style: bodyFont(fontSize: 12.5, color: textMuted(0.55)),
                            ),
                            const SizedBox(height: 7),
                            Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: c.tags.map((t) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent2_200,
                                    borderRadius: BorderRadius.circular(AppRadius.pill),
                                  ),
                                  child: Text(
                                    t,
                                    style: bodyFont(fontSize: 11, weight: FontWeight.w700, color: AppColors.accent2_800),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'a partir de\nR\$ ${c.desde}',
                        textAlign: TextAlign.right,
                        style: bodyFont(fontSize: 12.5, weight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
