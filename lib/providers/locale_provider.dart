import 'package:flutter/material.dart';
import 'package:xylophone/core/constants/l10n_constants.dart';
import 'package:xylophone/core/helpers/prefs_helper.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  LocaleProvider() {
    loadLocale();
  }

  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
    (await PrefsHelper.prefs).setString('selected_locale', locale.languageCode);
  }

  Future<void> loadLocale() async {
    final code = (await PrefsHelper.prefs).getString('selected_locale');
    if (code != null) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  void clearLocale() {
    _locale = const Locale('en');
    notifyListeners();
  }
}
