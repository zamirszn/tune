import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Drives the app-wide [ThemeMode]. Registered as a singleton in the
/// locator and read once at the root of [App] via BlocBuilder.
class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit() : super(ThemeMode.system);

  // TODO: persist selection to shared_preferences
  void toggle() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }

  void setMode(ThemeMode mode) => emit(mode);
}
