import 'package:flutter/material.dart';
import 'package:tune/app.dart';
import 'package:tune/common/helpers/locator.dart';

import 'package:tune/common/widgets/friendly_error_view.dart';

late String serverUrl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (details) => FriendlyErrorView(details: details);

  setupLocator();

  runApp(const App());
}
