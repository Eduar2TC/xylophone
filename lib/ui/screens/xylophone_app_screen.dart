import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xylophone/providers/notes_provider.dart';
import 'package:xylophone/ui/screens/custom_widgets/circle_button.dart';
import 'package:xylophone/ui/screens/custom_widgets/note_container.dart';

class XylophoneApp extends StatefulWidget {
  const XylophoneApp({Key? key}) : super(key: key);

  @override
  State<XylophoneApp> createState() => _XylophoneAppState();
}

class _XylophoneAppState extends State<XylophoneApp> {
  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final notes = notesProvider.notes;
    final width = MediaQuery.of(context).size.width;
    // Dynamic padding
    const double basePadding = 55.0;
    final notesList = List.generate(
      notes.length,
      (i) {
        // Calculate padding based on the list note index
        double paddingRight = width * (basePadding - (basePadding / notes.length * i) - basePadding / notes.length) / 100;
        return Expanded(
          flex: 1,
          child: NoteContainer(
            name: notes[i].name,
            sound: notes[i].sound,
            color: notes[i].color,
            padding: EdgeInsets.fromLTRB(0, 0, paddingRight, 10),
          ),
        );
      },
    );

    void removeNote() {
      if (notes.isNotEmpty) {
        notesProvider.removeNote(notes.length - 1);
      }
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
                                child: CircleButton(
                                  iconData: Icons.remove,
                                  onPress: removeNote,
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
                                child: CircleButton(
                                  iconData: Icons.add,
                                  onPress: notesProvider.addNote,
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
                    children: notes.isNotEmpty
                        ? notesList
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
