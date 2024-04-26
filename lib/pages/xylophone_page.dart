import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:xylophone/custom_widgets/rounded_button.dart';
import 'package:xylophone/custom_widgets/tile.dart';

class XylophoneApp extends StatefulWidget {
  const XylophoneApp({Key? key}) : super(key: key);

  @override
  State<XylophoneApp> createState() => _XylophoneAppState();
}

class _XylophoneAppState extends State<XylophoneApp> {
  late double width;
  late List<Expanded> listTiles;
  late List<Expanded> listTilesRemoved;
  @override
  void initState() {
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize / view.devicePixelRatio;
    width = size.width;
    //initial tile padding right = 55%
    //55/7 (numbers of tiles)= 7.857
    List<EdgeInsets> padding = List.generate(
      8,
      (index) {
        double paddingRight = width * (55 - 7.857 * index) / 100;
        return EdgeInsets.fromLTRB(0, 0, paddingRight, 10);
      },
    );

    listTiles = [
      Expanded(
        flex: 1,
        child: Tile(
          name: 'C',
          sound: 8,
          color: const Color(0xff7473D4),
          padding: padding[0],
        ),
      ),
      Expanded(
        flex: 1,
        child: Tile(
          name: 'B',
          sound: 7,
          color: const Color(0xFFdfcd6c),
          padding: padding[1],
        ),
      ),
      Expanded(
        flex: 1,
        child: Tile(
          name: 'A',
          sound: 6,
          color: const Color(0xFFe86b6a),
          padding: padding[2],
        ),
      ),
      Expanded(
        flex: 1,
        child: Tile(
          name: 'G',
          sound: 5,
          color: const Color(0xFF57bcac),
          padding: padding[3],
        ),
      ),
      Expanded(
        flex: 1,
        child: Tile(
          name: 'F',
          sound: 4,
          color: const Color(0xffa560c7),
          padding: padding[4],
        ),
      ),
      Expanded(
        flex: 1,
        child: Tile(
          name: 'E',
          sound: 3,
          color: const Color(0xffec9457),
          padding: padding[5],
        ),
      ),
      Expanded(
        flex: 1,
        child: Tile(
          name: 'D',
          sound: 2,
          color: const Color(0xff4cafe4),
          padding: padding[6],
        ),
      ),
      Expanded(
        flex: 1,
        child: Tile(
          name: 'C',
          sound: 1,
          color: const Color(0xff8cbe5e),
          padding: padding[7],
        ),
      ),
    ];
    listTilesRemoved = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void removeTile() {
      double paddingWidth = 55.0;
      setState(() {
        if (listTiles.isNotEmpty) {
          listTilesRemoved.add(listTiles.last);
          listTiles.removeLast();
          for (int i = 0; i < listTiles.length; i++) {
            Expanded expanded = listTiles[i];
            if (expanded.child is Tile) {
              Tile tile = expanded.child as Tile;
              EdgeInsets? oldPadding = tile.padding;
              if (oldPadding != null) {
                double newRightPadding = width *
                    (paddingWidth -
                        (paddingWidth / listTiles.length * i) -
                        paddingWidth / listTiles.length) /
                    100;
                EdgeInsets newPadding =
                    oldPadding.copyWith(right: newRightPadding);
                tile.padding = newPadding;
                listTiles[i] = Expanded(key: UniqueKey(), child: tile);
              }
            }
          }
          if (listTiles.isEmpty) {
            listTiles.add(
              Expanded(
                key: const Key('message'),
                child: Center(
                  child: TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 500),
                    curve: decelerateEasing,
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    builder: (context, value, _) => Transform.translate(
                      offset: Offset(-width / 2 + value * width / 2, 0),
                      child: const Text(
                        'No more tiles',
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
            );
          }
        }
      });
    }

    void addTile() {
      double paddingWidth = 55.0;
      setState(() {
        if (listTilesRemoved.isNotEmpty) {
          listTiles.add(listTilesRemoved.last);
          listTilesRemoved.removeLast();
          if (listTiles.first.key as Key == const Key('message')) {
            listTiles.remove(listTiles.first);
          }
          for (int i = 0; i < listTiles.length; i++) {
            Expanded expanded = listTiles[i];
            if (expanded.child is Tile) {
              Tile tile = expanded.child as Tile;
              EdgeInsets? oldPadding = tile.padding;
              if (oldPadding != null) {
                double newRightPadding = width *
                    (paddingWidth -
                        (paddingWidth / listTiles.length * i) -
                        paddingWidth / listTiles.length) /
                    100;
                EdgeInsets newPadding =
                    oldPadding.copyWith(right: newRightPadding);
                tile.padding = newPadding;
                listTiles[i] = Expanded(key: UniqueKey(), child: tile);
              }
            }
          }
        }
      });
    }

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
                              Text(
                                'Xiphone'.toUpperCase(),
                                style: const TextStyle(
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
                    children: listTiles,
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
