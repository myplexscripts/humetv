import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'lucide_symbol_assets.dart';

/// Renders bundled Lucide artwork while retaining Plezy's icon identifiers.
/// Brand/custom icons outside the mapped UI vocabulary retain their renderer.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
    this.shadows,
    this.semanticLabel,
    this.textDirection,
  });

  final IconData? icon;
  final double? size;
  final Color? color;
  final double? fill;
  final double? weight;
  final double? grade;
  final double? opticalSize;
  final List<Shadow>? shadows;
  final String? semanticLabel;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    if (icon == null) return const SizedBox.shrink();
    final asset = lucideAssetFor(icon!);
    if (asset != null) {
      final theme = IconTheme.of(context);
      final resolvedSize = size ?? theme.size ?? 24;
      final resolvedColor = color ?? theme.color ?? Colors.white;
      return SvgPicture.asset(
        asset,
        width: resolvedSize,
        height: resolvedSize,
        colorFilter: ColorFilter.mode(
          resolvedColor.withValues(alpha: resolvedColor.a * (theme.opacity ?? 1)),
          BlendMode.srcIn,
        ),
        semanticsLabel: semanticLabel,
        matchTextDirection: icon!.matchTextDirection,
      );
    }
    return Icon(
      icon,
      size: size,
      color: color,
      fill: fill ?? AppIconDefaults.fill,
      weight: weight ?? AppIconDefaults.weight,
      grade: grade ?? AppIconDefaults.grade,
      opticalSize: opticalSize ?? AppIconDefaults.opticalSize,
      shadows: shadows ?? AppIconDefaults.shadows,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );
  }
}

/// Central place to adjust default Material Symbol variations.
class AppIconDefaults {
  static double fill = 1;
  static double weight = 700;
  static double? grade;
  static double? opticalSize;
  static Color? color;
  static List<Shadow>? shadows;

  static void update({
    double? fill,
    double? weight,
    double? grade,
    double? opticalSize,
    Color? color,
    List<Shadow>? shadows,
  }) {
    if (fill != null) AppIconDefaults.fill = fill;
    if (weight != null) AppIconDefaults.weight = weight;
    if (grade != null) AppIconDefaults.grade = grade;
    if (opticalSize != null) AppIconDefaults.opticalSize = opticalSize;
    if (color != null) AppIconDefaults.color = color;
    if (shadows != null) AppIconDefaults.shadows = shadows;
  }
}
