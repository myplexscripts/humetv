import 'package:flutter/material.dart';
import '../services/settings_service.dart' show LibraryDensity;
import 'layout_constants.dart';
import 'platform_detector.dart';

class GridSizeCalculator {
  static double _lerp(double min, double max, double t) => min + (max - min) * t;

  /// Calculates the maximum cross-axis extent for grid items based on screen size and density.
  /// [density] is an int 1-5 (1 = most compact, 5 = most comfortable).
  ///
  /// HumeTV deliberately uses larger artwork than upstream Plezy. The goal is
  /// the Apple TV browsing rhythm: fewer, more cinematic cards with room for
  /// focus growth instead of dense desktop-style grids.
  static double getMaxCrossAxisExtent(BuildContext context, int density) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final f = LibraryDensity.factor(density);

    if (PlatformDetector.isTV()) return _lerp(185, 300, f);
    if (ScreenBreakpoints.isDesktopOrLarger(screenWidth)) return _lerp(165, 300, f);
    if (ScreenBreakpoints.isTablet(screenWidth)) return _lerp(140, 245, f);
    return _lerp(110, 205, f);
  }

  /// Calculates the number of columns for a given available width.
  ///
  /// Matches Flutter's SliverGridDelegateWithMaxCrossAxisExtent exactly, so
  /// keyboard and d-pad row navigation agrees with the rendered grid.
  static int getColumnCount(double crossAxisExtent, double maxCrossAxisExtent, {double? crossAxisSpacing}) {
    final effectiveSpacing = crossAxisSpacing ?? GridLayoutConstants.crossAxisSpacing;
    return (crossAxisExtent / (maxCrossAxisExtent + effectiveSpacing)).ceil().clamp(1, 100);
  }

  static double getCellWidthForColumnCount(double crossAxisExtent, int columnCount, {double? crossAxisSpacing}) {
    final effectiveSpacing = crossAxisSpacing ?? GridLayoutConstants.crossAxisSpacing;
    return (crossAxisExtent - (effectiveSpacing * (columnCount - 1))) / columnCount;
  }

  /// Computes the actual cell width that a grid with [getMaxCrossAxisExtent]
  /// would produce for the given [availableWidth].
  static double getCellWidth(double availableWidth, BuildContext context, int density) {
    final maxExtent = getMaxCrossAxisExtent(context, density);
    final columns = getColumnCount(availableWidth, maxExtent);
    return getCellWidthForColumnCount(availableWidth, columns);
  }

  static bool isFirstRow(int index, int columnCount) {
    return index < columnCount;
  }

  static bool isFirstColumn(int index, int columnCount) {
    return index % columnCount == 0;
  }
}
