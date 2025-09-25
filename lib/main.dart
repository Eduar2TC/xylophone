import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xylophone/pages/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const Home());
}
