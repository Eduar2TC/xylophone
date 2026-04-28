import 'dart:math';

import 'package:flutter/material.dart';

/// Show sparks on top of the app.
///
/// This helper inserts an [OverlayEntry] and animates a small burst of circular
/// particles originating from the provided global position. The overlay entry
/// is removed automatically when the animation finishes.
///
/// Example:
/// ```dart
/// final RenderBox box = context.findRenderObject() as RenderBox;
/// final global = box.localToGlobal(details.localPosition);
/// showSparksOverlay(context, global, color: Colors.yellow, count: 12);
/// ```
void showSparksOverlay(
  BuildContext context,
  Offset globalPosition, {
  Color color = Colors.white,
  int count = 10,
  Duration duration = const Duration(milliseconds: 600),
  double maxDistance = 80.0,
}) {
  final overlay = Overlay.of(context);

  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (ctx) {
      return _SparksOverlay(
        startPosition: globalPosition,
        color: color,
        count: count,
        duration: duration,
        maxDistance: maxDistance,
        onComplete: () {
          try {
            entry.remove();
          } catch (_) {
            // ignore removal errors
          }
        },
      );
    },
  );

  overlay.insert(entry);
}

class _SparksOverlay extends StatefulWidget {
  final Offset startPosition;
  final Color color;
  final int count;
  final Duration duration;
  final double maxDistance;
  final VoidCallback onComplete;

  const _SparksOverlay({
    Key? key,
    required this.startPosition,
    required this.color,
    required this.count,
    required this.duration,
    required this.maxDistance,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<_SparksOverlay> createState() => _SparksOverlayState();
}

class _SparksOverlayState extends State<_SparksOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<double> _angles;
  late final List<double> _speeds;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete();
        }
      });

    _angles = List<double>.generate(widget.count, (_) => _random.nextDouble() * pi * 2);
    // Speeds between 0.6 and 1.5
    _speeds = List<double>.generate(widget.count, (_) => 0.6 + _random.nextDouble() * 0.9);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildParticle(int index, double t) {
    final angle = _angles[index];
    final speed = _speeds[index];
    // ease-out for distance
    final easedT = Curves.easeOut.transform(t);
    final distance = widget.maxDistance * speed * easedT;
    final dx = cos(angle) * distance;
    final dy = sin(angle) * distance;
    final opacity = (1.0 - t).clamp(0.0, 1.0);
    // size varies a bit per particle and shrinks slightly as it moves
    final baseSize = (3.0 + 6.0 * (1 - speed)).clamp(2.0, 10.0);
    final size = baseSize * (1.0 + 0.2 * (1 - easedT));

    return Positioned(
      left: widget.startPosition.dx - size / 2 + dx,
      top: widget.startPosition.dy - size / 2 + dy,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: widget.color.withOpacity(0.9 * opacity), blurRadius: 6 * opacity, spreadRadius: 1 * opacity),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use an IgnorePointer so the overlay doesn't block user gestures.
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          // The overlay must cover the whole screen so positioned offsets (global coords)
          return Stack(
            fit: StackFit.expand,
            children: List<Widget>.generate(widget.count, (i) => _buildParticle(i, t)),
          );
        },
      ),
    );
  }
}
