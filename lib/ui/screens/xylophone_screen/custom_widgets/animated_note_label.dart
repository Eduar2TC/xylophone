import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedNoteLabel extends StatefulWidget {
  final Offset startPosition;
  final String label;
  final VoidCallback onComplete;

  const AnimatedNoteLabel({
    Key? key,
    required this.startPosition,
    required this.label,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<AnimatedNoteLabel> createState() => _AnimatedNoteLabelState();
}

class _AnimatedNoteLabelState extends State<AnimatedNoteLabel> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _vertical;
  late Animation<double> _horizontal;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    final random = Random();
    final dx = (random.nextDouble() - 0.5) * 200; // desplazamiento horizontal aleatorio

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _vertical = Tween<double>(begin: 0, end: -120).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _horizontal = Tween<double>(begin: 0, end: dx).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacity = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _scale = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.2, end: 1.5).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.5, end: 0.2).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Positioned(
          left: widget.startPosition.dx + _horizontal.value,
          top: widget.startPosition.dy + _vertical.value,
          child: Opacity(
            opacity: _opacity.value,
            child: Transform.scale(
              scale: _scale.value,
              child: Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 32,
                  fontFamily: 'MetronicProBold',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black)],
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
