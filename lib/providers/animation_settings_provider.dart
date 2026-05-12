import 'package:flutter/material.dart';
import 'package:xylophone/core/helpers/prefs_helper.dart';

class AnimationSettingsProvider extends ChangeNotifier {
  static const _kLabelAnimationEnabled = 'label_animation_enabled';
  static const _kParticlesEnabled = 'particles_enabled';
  static const _kVibrationAnimationEnabled = 'vibration_animation_enabled';

  bool _labelAnimationEnabled = true;
  bool _particlesEnabled = true;
  bool _vibrationAnimationEnabled = true;

  AnimationSettingsProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await PrefsHelper.prefs;
    _labelAnimationEnabled = prefs.getBool(_kLabelAnimationEnabled) ?? true;
    _particlesEnabled = prefs.getBool(_kParticlesEnabled) ?? true;
    _vibrationAnimationEnabled = prefs.getBool(_kVibrationAnimationEnabled) ?? true;
    notifyListeners();
  }

  // --- getters ---
  bool get labelAnimationEnabled => _labelAnimationEnabled;
  bool get particlesEnabled => _particlesEnabled;
  bool get vibrationAnimationEnabled => _vibrationAnimationEnabled;
  // --- setters (persisten en SharedPreferences) ---
  Future<void> setLabelAnimationEnabled(bool v) async {
    _labelAnimationEnabled = v;
    (await PrefsHelper.prefs).setBool(_kLabelAnimationEnabled, v);
    notifyListeners();
  }

  Future<void> setParticlesEnabled(bool v) async {
    _particlesEnabled = v;
    (await PrefsHelper.prefs).setBool(_kParticlesEnabled, v);
    notifyListeners();
  }
  void setVibrationAnimationEnabled(bool v) async {
    _vibrationAnimationEnabled = v;
    (await PrefsHelper.prefs).setBool(_kVibrationAnimationEnabled, v);
    notifyListeners();
  }
}