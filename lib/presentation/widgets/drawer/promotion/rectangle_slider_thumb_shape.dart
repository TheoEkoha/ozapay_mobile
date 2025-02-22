import 'package:flutter/material.dart';

class RectangleSliderThumbShape extends SliderComponentShape {
  /// Create a slider thumb that draws a rectangle with adjustable radius and color.
  const RectangleSliderThumbShape({
    this.enabledWidth = 20.0,
    this.enabledHeight = 10.0,
    this.disabledWidth,
    this.disabledHeight,
    this.elevation = 1.0,
    this.pressedElevation = 6.0,
    this.borderRadius = 4.0,
    this.thumbColor,
    this.disabledThumbColor,
  });

  /// The preferred width of the rectangle thumb shape when the slider is enabled.
  final double enabledWidth;

  /// The preferred height of the rectangle thumb shape when the slider is enabled.
  final double enabledHeight;

  /// The preferred width of the rectangle thumb shape when the slider is disabled.
  final double? disabledWidth;

  /// The preferred height of the rectangle thumb shape when the slider is disabled.
  final double? disabledHeight;

  /// The resting elevation adds shadow to the unpressed thumb.
  final double elevation;

  /// The pressed elevation adds shadow to the pressed thumb.
  final double pressedElevation;

  /// The corner radius of the rectangle.
  final double borderRadius;

  /// The color of the thumb when enabled.
  final Color? thumbColor;

  /// The color of the thumb when disabled.
  final Color? disabledThumbColor;

  double get _disabledWidth => disabledWidth ?? enabledWidth;
  double get _disabledHeight => disabledHeight ?? enabledHeight;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(
      isEnabled ? enabledWidth : _disabledWidth,
      isEnabled ? enabledHeight : _disabledHeight,
    );
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Tween<double> widthTween = Tween<double>(
      begin: _disabledWidth,
      end: enabledWidth,
    );
    final Tween<double> heightTween = Tween<double>(
      begin: _disabledHeight,
      end: enabledHeight,
    );

    final ColorTween colorTween = ColorTween(
      begin: disabledThumbColor ?? sliderTheme.disabledThumbColor,
      end: thumbColor ?? sliderTheme.thumbColor,
    );

    final Color color = colorTween.evaluate(enableAnimation)!;
    final double width = widthTween.evaluate(enableAnimation);
    final double height = heightTween.evaluate(enableAnimation);

    final Tween<double> elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    final double evaluatedElevation =
        elevationTween.evaluate(activationAnimation);

    final RRect rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: width, height: height),
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rRect);

    bool paintShadows = true;
    assert(() {
      if (debugDisableShadows) {
        // _debugDrawShadow(canvas, path, evaluatedElevation);
        paintShadows = false;
      }
      return true;
    }());

    if (paintShadows) {
      canvas.drawShadow(path, Colors.black, evaluatedElevation, true);
    }

    canvas.drawRRect(
      rRect,
      Paint()..color = color,
    );
  }
}
