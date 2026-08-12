import 'package:flutter/material.dart';
import '../state/formatters.dart';
import '../theme/app_theme.dart';

/// Renders the deterministic pseudo-QR pattern used for the Pix payment
/// screen — visually a QR code, not a real scannable one (this is a design
/// prototype, there's no backend to encode a real Pix payload).
class QrCodePainter extends StatelessWidget {
  final double size;
  const QrCodePainter({super.key, this.size = 168});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _QrPainter(buildQrCells())),
    );
  }
}

class _QrPainter extends CustomPainter {
  final List<QrCell> cells;
  _QrPainter(this.cells);

  @override
  void paint(Canvas canvas, Size size) {
    const n = 25.0;
    final cell = size.width / n;
    final bg = Paint()..color = AppColors.neutral100;
    canvas.drawRect(Offset.zero & size, bg);
    final fg = Paint()..color = AppColors.accent900;
    for (final c in cells) {
      canvas.drawRect(
        Rect.fromLTWH(c.x * cell, c.y * cell, cell, cell),
        fg,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _QrPainter oldDelegate) => false;
}
