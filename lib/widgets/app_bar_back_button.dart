import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../focus/focusable_wrapper.dart';
import '../i18n/strings.g.dart';
import 'app_icon.dart';

/// Defines the visual style of the back button
enum BackButtonStyle {
  /// Back button with a soft translucent background used in detail screens.
  circular,

  /// Plain back button without background used in sheets and simple contexts.
  plain,

  /// Back button styled for video player overlay.
  video,
}

/// Reusable HumeTV back control.
///
/// The visual treatment intentionally follows the restrained Apple TV pattern:
/// a compact chevron, generous 44px target and soft translucent focus/hover fill.
class AppBarBackButton extends StatefulWidget {
  const AppBarBackButton({
    super.key,
    this.style = BackButtonStyle.circular,
    this.onPressed,
    this.color,
    this.semanticLabel,
    this.focusNode,
  });

  final BackButtonStyle style;
  final VoidCallback? onPressed;
  final Color? color;
  final String? semanticLabel;
  final FocusNode? focusNode;

  @override
  State<AppBarBackButton> createState() => _AppBarBackButtonState();
}

class _AppBarBackButtonState extends State<AppBarBackButton> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 180), vsync: this);
    _backgroundAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHoverChange(bool isHovered) {
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _handlePressed() {
    if (widget.onPressed != null) {
      widget.onPressed!();
    } else {
      Navigator.of(context).pop();
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode _, KeyEvent event) {
    if (event.logicalKey != LogicalKeyboardKey.space) return KeyEventResult.ignored;
    if (event is KeyDownEvent) _handlePressed();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    final Color effectiveColor;
    switch (widget.style) {
      case BackButtonStyle.plain:
        effectiveColor = widget.color ?? theme.colorScheme.onSurface;
      case BackButtonStyle.circular:
      case BackButtonStyle.video:
        effectiveColor = widget.color ?? Colors.white;
    }

    final Color baseColor;
    final Color hoverColor;
    switch (widget.style) {
      case BackButtonStyle.circular:
        baseColor = Colors.black.withValues(alpha: 0.34);
        hoverColor = Colors.white.withValues(alpha: 0.18);
      case BackButtonStyle.plain:
        baseColor = Colors.transparent;
        hoverColor = (isDarkTheme ? Colors.white : Colors.black).withValues(alpha: 0.10);
      case BackButtonStyle.video:
        baseColor = Colors.black.withValues(alpha: 0.18);
        hoverColor = Colors.white.withValues(alpha: 0.16);
    }

    final semanticLabel = widget.semanticLabel ?? t.common.back;
    final button = FocusableWrapper(
      focusNode: widget.focusNode,
      semanticLabel: semanticLabel,
      onSelect: _handlePressed,
      onKeyEvent: _handleKeyEvent,
      autoScroll: false,
      disableScale: true,
      descendantsAreFocusable: false,
      borderRadius: 22,
      child: Tooltip(
        message: semanticLabel,
        excludeFromSemantics: true,
        child: MouseRegion(
          onEnter: (_) => _onHoverChange(true),
          onExit: (_) => _onHoverChange(false),
          child: GestureDetector(
            excludeFromSemantics: true,
            onTap: _handlePressed,
            child: AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) {
                final currentColor = Color.lerp(baseColor, hoverColor, _backgroundAnimation.value);

                return Container(
                  margin: const EdgeInsets.all(6),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: currentColor,
                    borderRadius: BorderRadius.circular(22),
                    border: widget.style == BackButtonStyle.circular
                        ? Border.all(color: Colors.white.withValues(alpha: 0.08))
                        : null,
                  ),
                  child: AppIcon(Symbols.chevron_left_rounded, fill: 1, color: effectiveColor, size: 28),
                );
              },
            ),
          ),
        ),
      ),
    );

    return widget.style == BackButtonStyle.circular ? SafeArea(child: button) : button;
  }
}
