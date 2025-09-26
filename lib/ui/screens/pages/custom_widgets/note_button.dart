import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:xylophone/core/helpers/sound.dart';

class NoteButton extends StatefulWidget {
  final Color color;
  final int sound;
  final String name;

  const NoteButton({
    super.key,
    required this.color,
    required this.sound,
    required this.name,
  });

  @override
  State<NoteButton> createState() => _NoteButtonState();
}

class _NoteButtonState extends State<NoteButton> {
  @override
  Widget build(BuildContext context) {
    AnimationController? animationController;
    return ShakeWidget(
      key: Key(widget.name),
      autoPlay: false,
      enableWebMouseHover: false,
      shakeConstant: ShakeLittleConstant1(),
      duration: const Duration(seconds: 3),
      onController: (controller) {
        animationController = controller;
      },
      child: TextButton(
        style: TextButton.styleFrom(
          elevation: 10,
          backgroundColor: widget.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        onPressed: () {
          Sound.playSound(widget.sound);
          animationController?.reset();
          animationController?.forward();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
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
                        fontWeight: FontWeight.bold,
                      ),
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
