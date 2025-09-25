import 'package:flutter/material.dart';
import 'package:xylophone/custom_widgets/rounded_button.dart';
import 'package:xylophone/custom_widgets/tile.dart';
import 'package:xylophone/helpers/constants.dart';

class XylophoneApp extends StatefulWidget {
  const XylophoneApp({Key? key}) : super(key: key);

  @override
  State<XylophoneApp> createState() => _XylophoneAppState();
}

class _XylophoneAppState extends State<XylophoneApp> {
  int tilesCount = 8;

  void removeTile() {
    setState(() {
      if (tilesCount > 0) {
        tilesCount--;
      }
    });
  }

  void addTile() {
    setState(() {
      if (tilesCount < 8) {
        tilesCount++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Dynamic padding
    const double basePadding = 55.0;
    final tiles = List.generate(
      tilesCount,
      (i) {
        // Calculate padding based on the tile index
        double paddingRight = width * (basePadding - (basePadding / tilesCount * i) - basePadding / tilesCount) / 100;
        return Expanded(
          flex: 1,
          child: Tile(
            name: tileData[i]['name'],
            sound: tileData[i]['sound'],
            color: tileData[i]['color'],
            padding: EdgeInsets.fromLTRB(0, 0, paddingRight, 10),
          ),
        );
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xff3b3e47),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            color: const Color(0xFF0F0F0F),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        width: 60,
                        color: const Color(0xFF0F0F0F),
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: RoundedButton(
                                  iconData: Icons.remove,
                                  onPress: removeTile,
                                ),
                              ),
                              const Text(
                                'XIPHONE',
                                style: TextStyle(
                                  fontFamily: 'MetronicProBold',
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: RoundedButton(
                                  iconData: Icons.add,
                                  onPress: addTile,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: tilesCount > 0
                        ? tiles
                        : [
                            Expanded(
                              child: Center(
                                child: TweenAnimationBuilder(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.decelerate,
                                  tween: Tween<double>(begin: 0.0, end: 1.0),
                                  builder: (context, value, _) => Transform.translate(
                                    offset: Offset(-width / 2 + value * width / 2, 0),
                                    child: AnimatedOpacity(
                                      duration: const Duration(milliseconds: 500),
                                      opacity: value,
                                      child: const Text(
                                        'Not notes available',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontFamily: 'MetronicProBold',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
