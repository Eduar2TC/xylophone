import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xylophone/providers/notes_provider.dart';
import 'package:xylophone/ui/screens/settings_screen/settings_screen.dart';
import 'package:xylophone/ui/screens/xylophone_screen/custom_widgets/circle_button.dart';
import 'package:xylophone/ui/screens/xylophone_screen/custom_widgets/note_container.dart';

/// Xylophone main screen with a master AnimationController and per-item
/// Interval-based animations (staggered entrance) without per-item timers.
///
/// Behavior:
/// - On the first appearance the master controller runs once and each item
///   animates in its slice of the controller timeline (staggered entrance).
/// - Subsequent adds/removes during runtime animate immediately (no delay
///   accumulation). New items won't replay the initial stagger unless the
///   controller is restarted intentionally.
class XylophoneAppScreen extends StatefulWidget {
  const XylophoneAppScreen({Key? key}) : super(key: key);

  @override
  State<XylophoneAppScreen> createState() => _XylophoneAppScreenState();
}

class _XylophoneAppScreenState extends State<XylophoneAppScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _masterController;

  @override
  void initState() {
    super.initState();
    // Total duration controls the overall speed of the stagger.
    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Start the master animation once on screen creation to produce the initial
    // staggered entrance.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _masterController.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _masterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final notes = notesProvider.notes;
    final width = MediaQuery.of(context).size.width;
    const double basePadding = 55.0;

    // Guard against zero-length to avoid division by zero.
    final int total = notes.isNotEmpty ? notes.length : 1;
    final double band = 1.0 / total;

    final notesList = List.generate(
      notes.length,
      (i) {
        // Padding calculation to visually offset bars.
        final double paddingRight = width * (basePadding - (basePadding / notes.length * i) - basePadding / notes.length) / 100;

        // Each item gets a sub-interval of the master's [0,1] timeline.
        final double start = (i * band).clamp(0.0, 1.0);
        // Slightly shorten each band's end for smoother overlap; clamp to 1.0.
        final double end = ((i + 1) * band).clamp(0.0, 1.0);

        final animation = CurvedAnimation(
          parent: _masterController,
          curve: Interval(start, end, curve: Curves.easeOut),
        );

        final slideAnim = Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero).animate(animation);
        final scaleAnim = Tween<double>(begin: 0.96, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.elasticOut),
        );

        return Expanded(
          flex: 1,
          child: FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: slideAnim,
              child: ScaleTransition(
                scale: scaleAnim,
                child: NoteContainer(
                  key: ValueKey('note_${notes[i].sound}_$i'),
                  name: notes[i].name,
                  sound: notes[i].sound,
                  color: notes[i].color,
                  padding: EdgeInsets.fromLTRB(0, 0, paddingRight, 10),
                ),
              ),
            ),
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    // Left control rail
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: 60,
                            color: Theme.of(context).appBarTheme.backgroundColor,
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

                    // Right area with staggered notes
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: notes.isNotEmpty
                            ? notesList
                            : [
                                Expanded(
                                  child: Center(
                                    child: TweenAnimationBuilder<double>(
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.decelerate,
                                      tween: Tween<double>(begin: 0.0, end: 1.0),
                                      builder: (context, value, _) => Transform.translate(
                                        offset: Offset(-width / 2 + value * width / 2, 0),
                                        child: AnimatedOpacity(
                                          duration: const Duration(milliseconds: 500),
                                          opacity: value,
                                          child: const Text(
                                            'No notes available',
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

                // Settings button
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    highlightColor: Colors.lightBlueAccent.withAlpha(50),
                    icon: const Icon(Icons.settings, color: Colors.white, size: 52),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                      );
                    },
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
