import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tune/features/welcome/pages/welcome_page.dart';
import 'tune_flutter.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeMode>(
      bloc: locator<ThemeModeCubit>(),
      builder: (context, themeMode) {
        return MaterialApp(
          title: AppValues.title,
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: MaterialThemes.light,
          darkTheme: MaterialThemes.dark,
          builder: (context, child) {
            final mediaQueryData = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQueryData.copyWith(
                textScaler: mediaQueryData.textScaler.clamp(maxScaleFactor: 1.1),
              ),
              child: child!,
            );
          },
          home: const WelcomePage(),
        );
      },
    );
  }
}
