import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/illustrations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();

    // Natural top-down flow (scrollable as a safety net on short viewports)
    // instead of stretching to fill the screen — keeps the hero art and the
    // pitch/CTA close together instead of spread apart by empty space.
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Wordmark(),
          const SizedBox(height: 16),
          const WelcomeIllustration(),
          const SizedBox(height: 20),
          Text(
            'Uma costureira boa, aqui do lado.',
            style: headingFont(fontSize: 32, height: 1.08),
          ),
          const SizedBox(height: 8),
          Text(
            'Encontre quem faz bainha, ajuste, reforma e roupa sob medida perto de você — com preço combinado antes.',
            style: bodyFont(fontSize: 15, color: textMuted(0.62)),
          ),
          const SizedBox(height: 20),
          PrimaryButton(label: 'Começar', onPressed: state.toRole),
          const SizedBox(height: 6),
          GhostButton(label: 'Já tenho conta', onPressed: state.toRole, fullWidth: true),
        ],
      ),
    );
  }
}

/// Little brand lockup — a stitched-thread badge plus the wordmark, styled
/// with the display face for more personality than a plain uppercase label.
class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(color: AppColors.accent200, shape: BoxShape.circle),
          child: CustomPaint(painter: _ThreadBadgePainter()),
        ),
        const SizedBox(width: 10),
        Text(
          'MINHA COSTUREIRA',
          style: headingFont(fontSize: 16, weight: FontWeight.w700, color: AppColors.accent700)
              .copyWith(letterSpacing: 0.6),
        ),
      ],
    );
  }
}

class _ThreadBadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // A single smooth stitched ribbon, plus one small anchoring stitch dot —
    // reads cleanly as a mark even at this tiny size.
    final threadPaint = Paint()
      ..color = AppColors.accent700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    final thread = Path()
      ..moveTo(size.width * 0.22, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.28, size.width * 0.5, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.52, size.width * 0.78, size.height * 0.28);
    canvas.drawPath(thread, threadPaint);
    canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.28), 1.8, Paint()..color = AppColors.accent2_600);
  }

  @override
  bool shouldRepaint(covariant _ThreadBadgePainter oldDelegate) => false;
}
