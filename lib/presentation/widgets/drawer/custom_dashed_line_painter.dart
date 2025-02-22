import 'package:flutter/material.dart';

class CustomDashedLinePainter extends CustomPainter {
  final bool isOnTop;
  final double leftPadding, rightPadding;
  final double? dashWidth, dashSpace;

  CustomDashedLinePainter({
    this.isOnTop = false,
    this.leftPadding = 0,
    this.rightPadding = 0,
    this.dashWidth,
    this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFC8C8D3)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    double _dashWidth = dashWidth ?? 7;
    double _dashSpace = dashSpace ?? 4;
    final double startX = leftPadding;
    final double endX = size.width - rightPadding;
    final double startY = isOnTop ? 0 : size.height;

    // Calculate number of segments needed
    final availableWidth = endX - startX;
    final segmentWidth = _dashWidth + _dashSpace;
    final segmentCount = (availableWidth / segmentWidth).floor();

    // Draw dashed line
    double currentX = startX;
    for (int i = 0; i < segmentCount; i++) {
      canvas.drawLine(
        Offset(currentX, startY),
        Offset(currentX + _dashWidth, startY),
        paint,
      );
      currentX += segmentWidth;
    }

    // Draw remaining space if any
    final remainingSpace = availableWidth - (segmentCount * segmentWidth);
    if (remainingSpace > _dashWidth) {
      canvas.drawLine(
        Offset(currentX, startY),
        Offset(currentX + _dashWidth, startY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
