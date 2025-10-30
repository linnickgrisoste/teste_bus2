import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.enabled = true,
    this.beginOffsetY = 0.2,
    this.curve = Curves.easeOutCubic,
    this.delay = const Duration(milliseconds: 400),
    this.duration = const Duration(milliseconds: 300),
  });

  final Curve curve;
  final Widget child;
  final bool enabled;
  final Duration delay;
  final Duration duration;
  final double beginOffsetY;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return child
        .animate(delay: delay, autoPlay: enabled, onPlay: (controller) => controller.forward())
        .slide(begin: Offset(0, beginOffsetY), end: Offset.zero, duration: duration, curve: curve)
        .fadeIn(duration: duration, curve: curve);
  }
}
