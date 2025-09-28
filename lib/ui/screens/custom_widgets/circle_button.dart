import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({super.key, this.iconData, this.onPress});
  final IconData? iconData;
  final Function()? onPress;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPress!();
      },
      style: TextButton.styleFrom(
        shape: const CircleBorder(),
        iconColor: const Color(0xFF0F0F0F),
        backgroundColor: const Color(0xff8f8c93),
        foregroundColor: const Color.fromARGB(255, 63, 4, 227),
        animationDuration: const Duration(milliseconds: 100),
        padding: EdgeInsets.zero,
        elevation: 100,
        minimumSize: const Size(35, 35),
        maximumSize: const Size(50, 50),
      ),
      child: Icon(
        size: 30,
        iconData,
      ),
    );
  }
}
