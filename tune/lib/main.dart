import 'package:flutter/material.dart';
import 'app.dart';
import 'common/helpers/locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  runApp(const App());
}
