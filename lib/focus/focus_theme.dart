import 'package:flutter/material.dart';
import '../services/device_performance.dart';
import '../theme/mono_tokens.dart';

class FocusTheme {
  FocusTheme._();

  // Apple TV inspired focus: clear lift and scale, without a heavy hard outline.
  static const double focusScale = 1.04;
  static const double fullCardFocusScale = 1.06;
  static const double focusBorderWidth = 2.0;
  static const double defaultBorderRadius = 18.0;
  static const double focusGlowInnerBlurRadius = 22;
  static const double focusGlowOuterBlurRadius = 42;
  static const double focusGlowSpreadRadius = 1.0;

  static Color getFocusBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.90)
        : Colors.black.withValues(alpha: 0.70);
  }

  static Duration getAnimationDuration(BuildContext context) {
    if (DevicePerformance.isReduced) return Duration.zero;
    return Theme.of(context).extension<MonoTokens>()?.normal ?? const Duration(milliseconds: 220);
  }

  static BoxDecoration focusDecoration(
    BuildContext context, {
    required bool isFocused,
    double borderRadius = defaultBorderRadius,
    BorderRadius? radii,
    double borderStrokeAlign = BorderSide.strokeAlignInside,
    Color? color,
  }) {
    final focusColor = color ?? getFocusBorderColor(context);

    return BoxDecoration(
      borderRadius: radii ?? BorderRadius.circular(borderRadius),
      border: Border.all(
        color: isFocused ? focusColor : Colors.transparent,
        width: focusBorderWidth,
        strokeAlign: borderStrokeAlign,
      ),
    );
  }

  static List<BoxShadow> focusGlowShadows(Color color) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.20),
        blurRadius: focusGlowInnerBlurRadius,
        spreadRadius: focusGlowSpreadRadius,
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.42),
        blurRadius: focusGlowOuterBlurRadius,
        offset: const Offset(0, 12),
      ),
    ];
  }

  static double get focusGlowExtent => focusGlowOuterBlurRadius * 2 + focusGlowSpreadRadius;

  static BoxDecoration focusBackgroundDecoration({
    required bool isFocused,
    double borderRadius = defaultBorderRadius,
    BorderRadius? radii,
  }) {
    return BoxDecoration(
      borderRadius: radii ?? BorderRadius.circular(borderRadius),
      color: isFocused ? Colors.white.withValues(alpha: 0.18) : Colors.transparent,
    );
  }

  static BoxDecoration textFillFocusDecoration(
    BuildContext context, {
    required bool isFocused,
    double borderRadius = defaultBorderRadius,
    BorderRadius? radii,
  }) {
    return BoxDecoration(
      borderRadius: radii ?? BorderRadius.circular(borderRadius),
      color: isFocused ? tokens(context).text.withValues(alpha: 0.14) : Colors.transparent,
    );
  }
}
