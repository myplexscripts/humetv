import 'package:flutter/material.dart';
import '../services/device_performance.dart';
import 'mono_tokens.dart';

/// HumeTV motion vocabulary.
///
/// Transitions favour a quick response followed by a long, soft settle, which
/// better matches a living-room interface than the sharper Material motion
/// used by the upstream client. Reduced-performance devices still snap.
class MonoMotion {
  MonoMotion._();

  /// Soft deceleration for larger focus and layout changes.
  static const Curve emphasized = Curves.easeOutQuart;

  /// App-wide standard curve for scrolling, fills and small transitions.
  static const Curve standard = Curves.easeOutCubic;

  static Duration shape(BuildContext context) => DevicePerformance.reducedDuration(tokens(context).expressive);
  static Duration fill(BuildContext context) => DevicePerformance.reducedDuration(tokens(context).normal);
  static Duration press(BuildContext context) => DevicePerformance.reducedDuration(tokens(context).fast);
}
