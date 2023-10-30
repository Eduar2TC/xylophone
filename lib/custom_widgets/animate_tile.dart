import 'package:flutter/material.dart';

class AnimateTile extends StatefulWidget {
  final Widget? tile;
  final EdgeInsets? padding;
  const AnimateTile({super.key, this.tile, this.padding});

  @override
  State<AnimateTile> createState() => _AnimateTileState();
}

class _AnimateTileState extends State<AnimateTile> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, _) => Padding(
        padding: EdgeInsets.only(
          right: widget.padding!.right * value,
          left: widget.padding!.left,
          top: widget.padding!.top,
          bottom: widget.padding!.bottom,
        ),
        child: widget.tile,
      ),
    );
  }
}
