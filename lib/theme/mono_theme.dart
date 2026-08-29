import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'gapped_track_shape.dart';
import 'mono_tokens.dart';

final Map<({bool dark, bool oled, TargetPlatform platform}), ThemeData> _monoThemeCache = {};

ThemeData monoTheme({required bool dark, bool oled = false}) {
  final key = (dark: dark || oled, oled: oled, platform: defaultTargetPlatform);
  final cached = _monoThemeCache[key];
  if (cached != null) return cached;

  final theme = _buildMonoTheme(dark: key.dark, oled: key.oled, platform: key.platform);
  _monoThemeCache[key] = theme;
  return theme;
}

ThemeData _buildMonoTheme({required bool dark, required bool oled, required TargetPlatform platform}) {
  // HumeTV visual system: Apple TV inspired, neutral, cinematic and artwork-first.
  // The UI stays intentionally quiet so posters and backdrops provide the colour.
  final ({Color bg, Color surface, Color surfaceRaised, Color outline, Color text, Color textMuted}) c;
  if (oled) {
    c = (
      bg: const Color(0xFF000000),
      surface: const Color(0xFF101010),
      surfaceRaised: const Color(0xFF1C1C1E),
      outline: const Color(0x24FFFFFF),
      text: const Color(0xFFF5F5F7),
      textMuted: const Color(0xFFA1A1A6),
    );
  } else if (dark) {
    c = (
      bg: const Color(0xFF000000),
      surface: const Color(0xFF141414),
      surfaceRaised: const Color(0xFF1C1C1E),
      outline: const Color(0x20FFFFFF),
      text: const Color(0xFFF5F5F7),
      textMuted: const Color(0xFFA1A1A6),
    );
  } else {
    c = (
      bg: const Color(0xFFF5F5F7),
      surface: const Color(0xFFFFFFFF),
      surfaceRaised: const Color(0xFFEDEDEF),
      outline: const Color(0x18000000),
      text: const Color(0xFF1D1D1F),
      textMuted: const Color(0xFF6E6E73),
    );
  }

  final isDark = dark || oled;
  final clickableCursor = WidgetStateProperty.resolveWith<MouseCursor>(
    (states) => states.contains(WidgetState.disabled) ? MouseCursor.defer : SystemMouseCursors.click,
  );

  final buttonStyle = ButtonStyle(
    mouseCursor: clickableCursor,
    minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
    padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
    elevation: const WidgetStatePropertyAll(0),
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) return c.surfaceRaised.withValues(alpha: 0.55);
      return c.text;
    }),
    foregroundColor: WidgetStatePropertyAll(isDark ? const Color(0xFF111111) : Colors.white),
    overlayColor: WidgetStatePropertyAll(c.textMuted.withValues(alpha: 0.12)),
    shape: const WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(22))),
    ),
  );

  final baseTextTheme = Typography.englishLike2021.apply(bodyColor: c.text, displayColor: c.text);

  final base = ThemeData(
    platform: platform,
    useMaterial3: true,
    brightness: isDark ? Brightness.dark : Brightness.light,
    colorScheme: ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: c.text,
      onPrimary: isDark ? const Color(0xFF111111) : Colors.white,
      secondary: c.textMuted,
      onSecondary: c.bg,
      surface: c.surface,
      onSurface: c.text,
      error: const Color(0xFFFF453A),
      onError: Colors.white,
      tertiary: c.text,
      onTertiary: c.bg,
      primaryContainer: c.surfaceRaised,
      onPrimaryContainer: c.text,
      secondaryContainer: c.surfaceRaised,
      onSecondaryContainer: c.text,
      surfaceContainerHighest: c.surfaceRaised,
      surfaceContainerLow: c.surface,
      surfaceDim: c.bg,
      surfaceBright: c.surfaceRaised,
      outline: c.outline,
      shadow: Colors.black.withValues(alpha: 0.35),
      scrim: Colors.black,
      inverseSurface: c.text,
      onInverseSurface: c.bg,
      inversePrimary: c.bg,
    ),
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    focusColor: Colors.white.withValues(alpha: isDark ? 0.16 : 0.12),
    hoverColor: c.text.withValues(alpha: 0.07),
    dividerColor: c.outline,
    scaffoldBackgroundColor: c.bg,
    canvasColor: c.bg,
    appBarTheme: AppBarTheme(
      backgroundColor: c.bg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      foregroundColor: c.text,
      toolbarHeight: 64,
      titleSpacing: 24,
      titleTextStyle: TextStyle(
        color: c.text,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
    ),
    textTheme: baseTextTheme.copyWith(
      displayLarge: TextStyle(color: c.text, fontSize: 48, fontWeight: FontWeight.w700, letterSpacing: -1.4),
      displayMedium: TextStyle(color: c.text, fontSize: 40, fontWeight: FontWeight.w700, letterSpacing: -1.1),
      displaySmall: TextStyle(color: c.text, fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: -0.9),
      headlineLarge: TextStyle(color: c.text, fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.8),
      headlineMedium: TextStyle(color: c.text, fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.6),
      headlineSmall: TextStyle(color: c.text, fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.45),
      titleLarge: TextStyle(color: c.text, fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.35),
      titleMedium: TextStyle(color: c.text, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.2),
      titleSmall: TextStyle(color: c.textMuted, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.1),
      bodyLarge: TextStyle(color: c.text, fontSize: 18, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(color: c.text, fontSize: 16, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(color: c.textMuted, fontSize: 16, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(color: c.text, fontSize: 16, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(color: c.textMuted, fontSize: 16, fontWeight: FontWeight.w600),
      labelSmall: TextStyle(color: c.textMuted, fontSize: 16, fontWeight: FontWeight.w500),
    ),
    cardTheme: CardThemeData(
      color: c.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: .zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
    ),
    inputDecorationTheme: _inputDecorationTheme(c.text, c.textMuted, c.surfaceRaised),
    elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
    filledButtonTheme: FilledButtonThemeData(style: buttonStyle),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        mouseCursor: clickableCursor,
        minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
        foregroundColor: WidgetStatePropertyAll(c.text),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        mouseCursor: clickableCursor,
        minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
        foregroundColor: WidgetStatePropertyAll(c.text),
        side: WidgetStatePropertyAll(BorderSide(color: c.outline)),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        mouseCursor: clickableCursor,
        minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
        foregroundColor: WidgetStatePropertyAll(c.text),
        overlayColor: WidgetStatePropertyAll(c.text.withValues(alpha: 0.08)),
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: c.text,
      inactiveTrackColor: c.text.withValues(alpha: 0.18),
      trackHeight: 6,
      trackGap: 4,
      thumbSize: const WidgetStatePropertyAll(Size(4, 18)),
      thumbShape: const HandleThumbShape(),
      trackShape: const GappedTrackShape(),
      tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2),
      // ignore: deprecated_member_use
      year2023: false,
    ),
    dividerTheme: DividerThemeData(space: 0, thickness: 1, color: c.outline),
    listTileTheme: ListTileThemeData(
      dense: false,
      minTileHeight: 52,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      iconColor: c.text,
      textColor: c.text,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: c.bg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      height: 72,
      indicatorColor: c.text.withValues(alpha: 0.10),
      indicatorShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          color: selected ? c.text : c.textMuted,
          fontSize: 16,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final active = states.contains(WidgetState.selected);
        return IconThemeData(opacity: active ? 1 : 0.7, size: 24, color: active ? c.text : c.textMuted);
      }),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.surface,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: c.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 18,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(28))),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: c.surfaceRaised,
      contentTextStyle: TextStyle(color: c.text, fontSize: 16),
      actionTextColor: c.text,
      elevation: 12,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      insetPadding: const EdgeInsets.all(20),
    ),
  );

  return base.copyWith(
    extensions: [
      MonoTokens(
        radiusSm: 12,
        radiusMd: 18,
        radiusLg: 28,
        radiusXs: 8,
        groupGap: 4,
        space: 16,
        fast: const Duration(milliseconds: 140),
        normal: const Duration(milliseconds: 220),
        slow: const Duration(milliseconds: 360),
        expressive: const Duration(milliseconds: 420),
        bg: c.bg,
        surface: c.surface,
        outline: c.outline,
        text: c.text,
        textMuted: c.textMuted,
      ),
    ],
  );
}

InputDecorationTheme _inputDecorationTheme(Color text, Color textMuted, Color surfaceRaised) {
  final unfocusedFill = surfaceRaised.withValues(alpha: 0.72);
  final focusedFill = surfaceRaised;
  const border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
    borderSide: BorderSide.none,
  );
  return InputDecorationTheme(
    filled: true,
    fillColor: WidgetStateColor.resolveWith(
      (states) => states.contains(WidgetState.focused) ? focusedFill : unfocusedFill,
    ),
    isDense: false,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: border,
    enabledBorder: border,
    focusedBorder: border,
    hintStyle: TextStyle(color: textMuted, fontSize: 16),
    labelStyle: TextStyle(color: textMuted, fontSize: 16),
  );
}
