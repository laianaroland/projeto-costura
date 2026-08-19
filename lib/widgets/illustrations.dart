import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

/// The welcome screen hero — reproduced pixel-for-pixel from the original
/// Claude Design SVG (var(--color-*) tokens swapped for their literal hex
/// values from [AppColors]).
class WelcomeIllustration extends StatelessWidget {
  const WelcomeIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 360 / 268,
      child: SvgPicture.string(_welcomeSvg),
    );
  }
}

const _welcomeSvg = '''
<svg viewBox="0 0 360 268" xmlns="http://www.w3.org/2000/svg">
  <circle cx="196" cy="118" r="122" fill="#FBDEE1"/>
  <g opacity=".75">
    <rect x="286" y="42" width="52" height="64" rx="10" fill="#F1EBE3" transform="rotate(9 312 74)"/>
    <path d="M296 62h32M296 76h24M296 90h30" stroke="#C2B8AB" stroke-width="3" stroke-linecap="round" transform="rotate(9 312 74)"/>
    <rect x="298" y="106" width="46" height="56" rx="10" fill="#F1EBE3" transform="rotate(-7 320 134)"/>
    <path d="M308 124h26M308 138h18" stroke="#C2B8AB" stroke-width="3" stroke-linecap="round" transform="rotate(-7 320 134)"/>
  </g>
  <path d="M30 152q18-22 36 0l8 48q-26 12-52 0z" fill="#DED6CB"/>
  <circle cx="48" cy="140" r="10" fill="#DED6CB"/>
  <path d="M48 200v30" stroke="#C2B8AB" stroke-width="5" stroke-linecap="round"/>
  <ellipse cx="48" cy="232" rx="18" ry="5" fill="#DED6CB"/>
  <circle cx="196" cy="70" r="46" fill="#2F2B26"/>
  <circle cx="158" cy="94" r="31" fill="#2F2B26"/>
  <circle cx="234" cy="94" r="31" fill="#2F2B26"/>
  <path d="M164 132q32 22 64 0l-6-46h-52z" fill="#2F2B26"/>
  <circle cx="196" cy="102" r="35" fill="#D9A179"/>
  <path d="M162 84q34-26 68 0" fill="none" stroke="#7B86D8" stroke-width="11" stroke-linecap="round"/>
  <rect x="172" y="96" width="22" height="15" rx="7" fill="none" stroke="#5E69BD" stroke-width="3"/>
  <rect x="200" y="96" width="22" height="15" rx="7" fill="none" stroke="#5E69BD" stroke-width="3"/>
  <path d="M194 103h6" stroke="#5E69BD" stroke-width="3"/>
  <path d="M188 122q8 6 16 0" fill="none" stroke="#6b4426" stroke-width="3" stroke-linecap="round"/>
  <circle cx="168" cy="116" r="6" fill="#C4855C" opacity=".7"/>
  <circle cx="224" cy="116" r="6" fill="#C4855C" opacity=".7"/>
  <path d="M158 152q38-16 76 0l10 62h-96z" fill="#7B86D8"/>
  <path d="M170 146v70M196 142v76M222 146v70M156 172h82M154 192h88" stroke="#47519A" stroke-width="3" opacity=".5"/>
  <path d="M162 158q-30 18-38 44" fill="none" stroke="#D9A179" stroke-width="19" stroke-linecap="round"/>
  <path d="M232 158q28 16 30 44" fill="none" stroke="#D9A179" stroke-width="19" stroke-linecap="round"/>
  <path d="M236 150q22 26 14 58" fill="none" stroke="#5E69BD" stroke-width="5" stroke-linecap="round" stroke-dasharray="1 12"/>
  <rect x="205" y="148" width="18" height="22" rx="6" fill="#D67C88"/>
  <rect x="100" y="168" width="132" height="34" rx="17" fill="#DFE3FB"/>
  <rect x="198" y="168" width="34" height="48" rx="15" fill="#DFE3FB"/>
  <rect x="100" y="180" width="34" height="34" rx="14" fill="#DFE3FB"/>
  <rect x="94" y="206" width="146" height="24" rx="12" fill="#C3CAF4"/>
  <circle cx="216" cy="186" r="11" fill="#7B86D8"/>
  <circle cx="117" cy="192" r="8" fill="#7B86D8"/>
  <path d="M117 202v14" stroke="#2F2B26" stroke-width="3" stroke-linecap="round"/>
  <path d="M0 232h360" stroke="#DED6CB" stroke-width="5" stroke-linecap="round"/>
  <path d="M112 232q100-26 196-2v18q-96-16-196 6z" fill="#E79BA5"/>
  <path d="M126 236q92-20 178-2M124 248q94-20 180-4" stroke="#BB5E6B" stroke-width="3" opacity=".55" fill="none"/>
  <ellipse cx="306" cy="240" rx="16" ry="14" fill="#F4C1C7"/>
  <rect x="18" y="196" width="30" height="36" rx="9" fill="#7B86D8"/>
  <rect x="14" y="192" width="38" height="9" rx="4" fill="#47519A"/>
  <rect x="14" y="226" width="38" height="9" rx="4" fill="#47519A"/>
</svg>
''';

/// Empty-state / "nothing here yet" illustration: a soft dashed circle with
/// a centered icon, reused across the empty search and empty orders states.
class SoftIconBadge extends StatelessWidget {
  final IconData icon;
  final double size;
  const SoftIconBadge({super.key, required this.icon, this.size = 96});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DashedCirclePainter(),
        child: Center(
          child: Icon(icon, size: size * 0.4, color: AppColors.accent600),
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final radius = size.width / 2 - 3;
    final center = rect.center;
    final paint = Paint()
      ..color = AppColors.neutral400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    const dashCount = 24;
    for (var i = 0; i < dashCount; i++) {
      final start = (i / dashCount) * 2 * math.pi;
      const sweep = (2 * math.pi / dashCount) * 0.55;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) => false;
}

/// Celebratory checkmark badge for the order-success screen.
class SuccessCheckIllustration extends StatefulWidget {
  const SuccessCheckIllustration({super.key});

  @override
  State<SuccessCheckIllustration> createState() => _SuccessCheckIllustrationState();
}

class _SuccessCheckIllustrationState extends State<SuccessCheckIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 420))..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    return ScaleTransition(
      scale: scale,
      child: SizedBox(
        width: 190,
        height: 190,
        child: CustomPaint(painter: _SuccessPainter()),
      ),
    );
  }
}

class _SuccessPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    canvas.drawCircle(center, size.width * 0.36, Paint()..color = AppColors.accent2_300);
    canvas.drawCircle(center, size.width * 0.26, Paint()..color = AppColors.accent2_500);

    final checkPaint = Paint()
      ..color = AppColors.bg
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final check = Path()
      ..moveTo(center.dx - 24, center.dy)
      ..lineTo(center.dx - 8, center.dy + 17)
      ..lineTo(center.dx + 25, center.dy - 19);
    canvas.drawPath(check, checkPaint);

    final swoosh = Paint()
      ..color = AppColors.accent700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final swooshPath = Path()
      ..moveTo(size.width * 0.14, size.height * 0.82)
      ..cubicTo(
        size.width * 0.44,
        size.height * 0.74,
        size.width * 0.64,
        size.height * 0.9,
        size.width * 0.9,
        size.height * 0.74,
      );
    final dashed = _dashPath(swooshPath, dashLength: 11, gapLength: 10);
    canvas.drawPath(dashed, swoosh);
  }

  Path _dashPath(Path source, {required double dashLength, required double gapLength}) {
    final dashed = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      var draw = true;
      while (distance < metric.length) {
        final len = draw ? dashLength : gapLength;
        final next = math.min(distance + len, metric.length);
        if (draw) {
          dashed.addPath(metric.extractPath(distance, next), Offset.zero);
        }
        distance = next;
        draw = !draw;
      }
    }
    return dashed;
  }

  @override
  bool shouldRepaint(covariant _SuccessPainter oldDelegate) => false;
}
