import 'package:flutter/material.dart';
import 'package:xylophone/custom_widgets/tile.dart';

class XylophoneApp extends StatefulWidget {
  const XylophoneApp({Key? key}) : super(key: key);

  @override
  State<XylophoneApp> createState() => _XylophoneAppState();
}

class _XylophoneAppState extends State<XylophoneApp> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<EdgeInsets> padding = [
      EdgeInsets.fromLTRB(0, 0, width * 55/100, 10),
      EdgeInsets.fromLTRB(0, 0, width * (55-7.857)/100, 10), //55/7 = 7.857
      EdgeInsets.fromLTRB(0, 0, width * (55-7.857*2)/100, 10),
      EdgeInsets.fromLTRB(0, 0, width * (55-7.857*3)/100, 10),
      EdgeInsets.fromLTRB(0, 0, width * (55-7.857*4)/100, 10),
      EdgeInsets.fromLTRB(0, 0, width * (55-7.857*5)/100, 10),
      EdgeInsets.fromLTRB(0, 0, width * (55-7.857*6)/100, 10),
      EdgeInsets.fromLTRB(0, 0, width * 0/100, 10),
    ];

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
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: const Icon(
                                    Icons.remove_circle_rounded,
                                    color: Color(0xff8f8c93),
                                    size: 35,
                                  ),
                                ),
                                Text(
                                  'Xiphone'.toUpperCase(),
                                  style: const TextStyle(
                                      fontFamily: 'MetronicProBold',
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: const Icon(
                                    Icons.add_circle_outlined,
                                    color: Color(0xff8f8c93),
                                    size: 35,
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
                      children: [
                        Expanded(
                          flex: 1,
                          child: Tile(
                            name: 'C',
                            sound: 7,
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
