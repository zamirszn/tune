import 'package:get_it/get_it.dart';
import '../../features/menu/cubits/theme_mode_cubit.dart';

/// Global service locator. Register app-wide singletons (Cubits, clients)
/// here in [setupLocator], called once from main() before runApp.
final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<ThemeModeCubit>(ThemeModeCubit());

  // Register the YT Music API client / player service here once the
  // data layer is built, e.g.:
  // locator.registerSingleton<PlayerCubit>(PlayerCubit());
}
