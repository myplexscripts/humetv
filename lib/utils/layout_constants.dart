import 'package:flutter/widgets.dart';
import 'platform_detector.dart';

/// Layout and sizing constants used throughout the application.
class ScreenBreakpoints {
  static const double mobile = 600;
  static const double wideTablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1600;

  // Legacy alias for backward compatibility.
  static const double tablet = mobile;

  static bool isMobile(double width) => width < mobile;
  static bool isTablet(double width) => width >= mobile && width < desktop;
  static bool isDesktop(double width) => width >= desktop && width < largeDesktop;
  static bool isDesktopOrLarger(double width) => width >= desktop;
  static bool isWideTabletOrLarger(double width) => width >= wideTablet;
}

/// Animation and notification durations.
class AppDurations {
  static const Duration animMedium = Duration(milliseconds: 320);
  static const Duration animSlow = Duration(milliseconds: 520);
  static const Duration snackBarDefault = Duration(seconds: 3);
  static const Duration snackBarLong = Duration(seconds: 4);
}

class GridLayoutConstants {
  static const double posterAspectRatio = 2 / 3.3;
  static const double fullCardPosterAspectRatio = 2 / 3;
  static const double episodeThumbnailAspectRatio = 16 / 9;
  static const double episodeGridCellAspectRatio = 1.4;

  /// 1:1 music artwork (albums/artists/tracks).
  static const double squareAspectRatio = 1 / 1;
  static const double squareGridCellAspectRatio = 2 / 2.3;

  /// HumeTV keeps visible breathing room between artwork instead of the
  /// near-edge-to-edge Material grid used by the upstream client.
  static const double squareGridSpacing = 16.0;

  static double get crossAxisSpacing => PlatformDetector.isAutomotive() ? 24 : 14;
  static double get mainAxisSpacing => PlatformDetector.isAutomotive() ? 24 : 18;

  static double fullCardGridSpacingForScale(double scale) => (18 * scale).clamp(14, 28).toDouble();

  /// Standard grid padding. Desktop/TV gets a cinematic content inset while
  /// compact touch layouts retain a smaller edge margin.
  static EdgeInsets get gridPadding {
    if (PlatformDetector.isAutomotive()) return const EdgeInsets.all(24);
    if (PlatformDetector.isTV()) return const EdgeInsets.fromLTRB(56, 8, 56, 36);
    return const EdgeInsets.fromLTRB(16, 8, 16, 24);
  }
}

class TvLayoutConstants {
  /// Apple TV-like safe content margins at 1080p.
  static const double horizontalInset = 88;
  static const double shelfHorizontalInset = 72;
  static const double shelfVerticalGap = 40;

  /// Keep hero copy deliberately narrow so backdrop artwork can breathe.
  static const double heroContentMaxWidth = 700;
  static const double heroLogoWidth = 500;
  static const double heroLogoHeight = 144;
  static const double compactHeroLogoWidth = 400;
  static const double compactHeroLogoHeight = 108;

  static double scaleForHeight(double height) => (height / 1080).clamp(0.85, 1.35).toDouble();
  static double scaleForSize(Size size) => scaleForHeight(size.height);
  static double scaleOf(BuildContext context) => scaleForSize(MediaQuery.sizeOf(context));
}
