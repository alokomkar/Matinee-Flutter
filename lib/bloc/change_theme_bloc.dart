import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'change_theme_event.dart';
import 'change_theme_state.dart';

class ChangeThemeBloc extends Bloc<ChangeThemeEvent, ChangeThemeState> {

  void onLightThemeChange() => dispatch(LightTheme());
  void onDarkThemeChange() => dispatch(DarkTheme());
  void onAmoledThemeChange() => dispatch(AmoledTheme());
  void onDecideThemeChange() => dispatch(DecideTheme());

  @override
  ChangeThemeState get initialState => ChangeThemeState.lightTheme();

  @override
  Stream<ChangeThemeState> mapEventToState(ChangeThemeEvent event) async* {
    if (event is DecideTheme) {
      final int optionValue = await getOption();
      switch( optionValue ) {
        case 0 : yield ChangeThemeState.lightTheme();
        break;
        case 1 : yield ChangeThemeState.darkTheme();
        break;
        case 2 : yield ChangeThemeState.amoledTheme();
        break;
      }
    }

    try {
      if (event is LightTheme) {
        yield ChangeThemeState.lightTheme();
          _saveOptionValue(0);
      }
      if (event is DarkTheme) {
        yield ChangeThemeState.darkTheme();
          _saveOptionValue(1);
      }
      if (event is AmoledTheme) {
        yield ChangeThemeState.amoledTheme();
          _saveOptionValue(2);
      }
    } catch (_) {
      throw Exception("Could not persist change");
    }

  }

  Future<Null> _saveOptionValue(int optionValue) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('theme_option', optionValue);
  }

  Future<int> getOption() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int option = preferences.get('theme_option') ?? 1;
    return option;
  }
}

final ChangeThemeBloc changeThemeBloc = ChangeThemeBloc()
  ..onDecideThemeChange();
