import 'package:get_it/get_it.dart';
import 'package:tune/features/menu/cubits/theme_mode_cubit.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<ThemeModeCubit>(ThemeModeCubit());
}
