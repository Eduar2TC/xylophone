import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:xylophone/custom_widgets/animate_tile.dart';
import 'package:xylophone/helpers/sound.dart';

class Tile extends StatelessWidget {
  final String name;
  final int sound;
  final Color color;
  final EdgeInsets padding;

  const Tile(
      {required this.name,
      required this.sound,
      required this.color,
      required this.padding});

  @override
  Widget build(BuildContext context) {
    return AnimateTile(
      padding: padding,
      tile: _Button(color: color, sound: sound, name: name),
    );
  }
}

class _Button extends StatefulWidget {
  const _Button({
    Key? key,
    required this.color,
    required this.sound,
    required this.name,
  }) : super(key: key);

  final Color color;
  final int sound;
  final String name;

  @override
  State<_Button> createState() => _ButtonState();
}

class _ButtonState extends State<_Button> {
  @override
  Widget build(BuildContext context) {
    AnimationController? animationController;
    return ShakeWidget(
      autoPlay: false,
      enableWebMouseHover: false,
      shakeConstant: ShakeLittleConstant1(),
      duration: const Duration(seconds: 1),
      onController: (controller) {
        animationController = controller;
      },
      child: TextButton(
        style: TextButton.styleFrom(
          elevation: 10,
          backgroundColor: widget.color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        onPressed: () {
          if (animationController?.isAnimating == false) {
            Sound.playSound(widget.sound);
            animationController?.reset();
            animationController?.forward();
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                          fontSize: 30,
                          color: Color(0xFF0F0F0F),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF0F0F0F),
                  ),
                  width: 25,
                  height: 25,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}




