import 'dart:math';

import 'package:flutter/material.dart';

/// Show sparks on top of the app.
///
/// This helper inserts an [OverlayEntry] and animates a burst of elongated
/// spark particles originating from the provided global position. Sizes and
/// distances are automatically scaled by the device pixel ratio so sparks
/// look identical on high-density (e.g. 3×) and low-density screens.
///
/// The overlay entry is removed automatically when the animation finishes.
///
/// Example:
/// ```dart
/// final RenderBox box = context.findRenderObject() as RenderBox;
/// final global = box.localToGlobal(details.localPosition);
/// showSparksOverlay(context, global, color: Colors.orange, count: 14);
/// ```
void showSparksOverlay(
  BuildContext context,
  Offset globalPosition, {
  Color color = Colors.white,
  int count = 12,
  Duration duration = const Duration(milliseconds: 700),
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

// ---------------------------------------------------------------------------
// Internal data model
// ---------------------------------------------------------------------------

class _SparkParticle {
  final double angle;
  final double speed; // 0.5 – 1.5
  final double length; // logical pixels, before DPR scaling
  final double width;
  final double angularVariance; // slight trajectory drift

  const _SparkParticle({
    required this.angle,
    required this.speed,
    required this.length,
    required this.width,
    required this.angularVariance,
  });
}

// ---------------------------------------------------------------------------
// Widget
// ---------------------------------------------------------------------------

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
  late final List<_SparkParticle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _particles = List<_SparkParticle>.generate(widget.count, (_) {
      final speed = 0.5 + _random.nextDouble() * 1.0;
      // Longer, thinner sparks look more realistic; vary per particle.
      final length = 6.0 + _random.nextDouble() * 10.0;
      final width = 1.0 + _random.nextDouble() * 1.5;
      return _SparkParticle(
        angle: _random.nextDouble() * pi * 2,
        speed: speed,
        length: length,
        width: width,
        angularVariance: (_random.nextDouble() - 0.5) * 0.4,
      );
    });

    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onComplete();
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Query the device pixel ratio once here and forward it to the painter
    // so every size/distance is multiplied accordingly.
    final dpr = MediaQuery.devicePixelRatioOf(context);

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: _SparksPainter(
              particles: _particles,
              progress: _controller.value,
              origin: widget.startPosition,
              color: widget.color,
              maxDistance: widget.maxDistance,
              devicePixelRatio: dpr,
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CustomPainter — draws elongated sparks with gravity & glow
// ---------------------------------------------------------------------------

class _SparksPainter extends CustomPainter {
  final List<_SparkParticle> particles;
  final double progress; // 0.0 → 1.0
  final Offset origin;
  final Color color;
  final double maxDistance;
  final double devicePixelRatio;

  const _SparksPainter({
    required this.particles,
    required this.progress,
    required this.origin,
    required this.color,
    required this.maxDistance,
    required this.devicePixelRatio,
  });

  @override
  bool shouldRepaint(_SparksPainter old) => old.progress != progress || old.origin != origin;

  @override
  void paint(Canvas canvas, Size size) {
    // Scale factor: on a 3× screen a "1 logical pixel" spark looks tiny.
    // We scale by sqrt(dpr) — not the full dpr — to keep sizes comfortable
    // on very high-density displays while still being visible everywhere.
    final scale = sqrt(devicePixelRatio);

    final eased = Curves.easeOut.transform(progress);
    // Gravity accumulates as a function of progress² (parabolic arc).
    final gravity = maxDistance * 0.4 * progress * progress * scale;

    for (final p in particles) {
      final distance = maxDistance * p.speed * eased * scale;

      // Slightly bend the angle over time (angular variance drifts with t).
      final currentAngle = p.angle + p.angularVariance * progress;

      final dx = cos(currentAngle) * distance;
      final dy = sin(currentAngle) * distance + gravity;

      final tipX = origin.dx + dx;
      final tipY = origin.dy + dy;
      // Tail is behind the tip in the travel direction, scaled too.
      final tailX = tipX - cos(currentAngle) * p.length * scale;
      final tailY = tipY - sin(currentAngle) * p.length * scale;

      // Opacity: fade out in the last 40% of the animation.
      final opacity = (1.0 - ((progress - 0.6) / 0.4).clamp(0.0, 1.0));

      // ── Glow pass (wide, very transparent) ──────────────────────────────
      final glowPaint = Paint()
        ..color = color.withOpacity(0.25 * opacity)
        ..strokeWidth = p.width * scale * 3.5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawLine(Offset(tailX, tailY), Offset(tipX, tipY), glowPaint);

      // ── Core pass (narrow, bright) ───────────────────────────────────────
      final corePaint = Paint()
        ..color = color.withOpacity(opacity)
        ..strokeWidth = p.width * scale
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(Offset(tailX, tailY), Offset(tipX, tipY), corePaint);

      // ── Bright head dot ──────────────────────────────────────────────────
      final dotRadius = p.width * scale * 1.2;
      final dotPaint = Paint()
        ..color = Color.lerp(color, Colors.white, 0.6)!.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(tipX, tipY), dotRadius, dotPaint);
    }
  }
}
