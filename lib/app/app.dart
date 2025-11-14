import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:xylophone/core/constants/l10n_constants.dart';
import 'package:xylophone/core/l10n/arb_output/generated/app_localizations.dart';
import 'package:xylophone/providers/locale_provider.dart';
import 'package:xylophone/providers/theme_provider.dart';
import 'package:xylophone/ui/screens/xylophone_screen/xylophone_app_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final localProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const XylophoneAppScreen(),
      supportedLocales: L10n.all,
      locale: localProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: themeProvider.themeData,
      themeMode: themeProvider.themeMode,
    );
  }
}
