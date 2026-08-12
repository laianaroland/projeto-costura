import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A simplified, original illustration for the welcome screen — a dress on
/// a hanger with a stitching thread, echoing the tailor theme of the
/// original artwork without reproducing its exact vector paths.
class WelcomeIllustration extends StatelessWidget {
  const WelcomeIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 360 / 268,
      child: CustomPaint(painter: _WelcomePainter()),
    );
  }
}

class _WelcomePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final backdrop = Paint()..color = AppColors.accent2_200;
    canvas.drawCircle(Offset(w * 0.54, h * 0.46), w * 0.34, backdrop);

    // hanger
    final hangerPaint = Paint()
      ..color = AppColors.accent700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final hookTop = Offset(w * 0.5, h * 0.1);
    canvas.drawLine(hookTop, Offset(w * 0.5, h * 0.16), hangerPaint);
    canvas.drawCircle(Offset(w * 0.5, h * 0.08), h * 0.025, hangerPaint);
    final hangerPath = Path()
      ..moveTo(w * 0.28, h * 0.28)
      ..quadraticBezierTo(w * 0.5, h * 0.12, w * 0.72, h * 0.28);
    canvas.drawPath(hangerPath, hangerPaint);

    // dress body
    final dressPaint = Paint()..color = AppColors.accent500;
    final dress = Path()
      ..moveTo(w * 0.36, h * 0.3)
      ..lineTo(w * 0.64, h * 0.3)
      ..lineTo(w * 0.76, h * 0.86)
      ..quadraticBezierTo(w * 0.5, h * 0.98, w * 0.24, h * 0.86)
      ..close();
    canvas.drawPath(dress, dressPaint);

    // waist band
    final band = Paint()..color = AppColors.accent700;
    canvas.drawRect(Rect.fromLTWH(w * 0.34, h * 0.52, w * 0.32, h * 0.045), band);

    // stitching thread swirl
    final threadPaint = Paint()
      ..color = AppColors.accent2_600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;
    final threadPath = Path()..moveTo(w * 0.14, h * 0.7);
    for (var i = 0; i < 5; i++) {
      final dx = w * 0.14 + i * w * 0.05;
      threadPath.quadraticBezierTo(dx + w * 0.025, h * (i.isEven ? 0.62 : 0.78), dx + w * 0.05, h * 0.7);
    }
    canvas.drawPath(threadPath, threadPaint);

    // needle
    final needlePaint = Paint()
      ..color = AppColors.neutral700
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.4, h * 0.66), Offset(w * 0.5, h * 0.58), needlePaint);
    canvas.drawCircle(Offset(w * 0.5, h * 0.58), 2.6, Paint()..color = AppColors.neutral700);

    // spool
    final spoolPaint = Paint()..color = AppColors.neutral200;
    final spoolRect = Rect.fromLTWH(w * 0.78, h * 0.12, w * 0.14, h * 0.18);
    canvas.drawRRect(RRect.fromRectAndRadius(spoolRect, const Radius.circular(6)), spoolPaint);
    final spoolLines = Paint()
      ..color = AppColors.neutral400
      ..strokeWidth = 2;
    for (var i = 1; i < 4; i++) {
      final y = spoolRect.top + spoolRect.height * i / 4;
      canvas.drawLine(Offset(spoolRect.left + 4, y), Offset(spoolRect.right - 4, y), spoolLines);
    }
  }

  @override
  bool shouldRepaint(covariant _WelcomePainter oldDelegate) => false;
}

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
