import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:plezy/theme/mono_theme.dart';
import 'package:plezy/widgets/app_icon.dart';

void main() {
  test('all theme typography uses the bundled Inter family', () {
    final theme = monoTheme(dark: true);
    for (final style in [
      theme.textTheme.displayLarge,
      theme.textTheme.headlineLarge,
      theme.textTheme.titleMedium,
      theme.textTheme.bodyLarge,
      theme.textTheme.bodySmall,
      theme.textTheme.labelLarge,
      theme.appBarTheme.titleTextStyle,
    ]) {
      expect(style?.fontFamily, 'Inter');
    }
  });

  testWidgets('remote navigation icons render bundled Lucide with semantics', (tester) async {
    final semantics = tester.ensureSemantics();
    addTearDown(semantics.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: monoTheme(dark: true),
        home: const Scaffold(body: AppIcon(Symbols.search_rounded, size: 28, semanticLabel: 'Search')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.bySemanticsLabel('Search'), findsOneWidget);
    expect(tester.getSize(find.byType(SvgPicture)), const Size(28, 28));
    expect(tester.takeException(), isNull);
  });

  testWidgets('actual Inter fonts are packaged for offline TV startup', (tester) async {
    for (final weight in [400, 500, 600, 700]) {
      final bytes = await rootBundle.load('assets/fonts/Inter-$weight.ttf');
      expect(bytes.lengthInBytes, greaterThan(10000));
      expect(bytes.getUint32(0), 0x00010000);
    }
  });
}
