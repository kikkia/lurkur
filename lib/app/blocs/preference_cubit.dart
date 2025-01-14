import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores data on the user's device.
///
/// This data is only intended to be used for a user's preference and is subject
/// to deletion at the user's or device's discretion.
class PreferenceCubit extends Cubit<PreferenceState> {
  static const _themeBrightness = 'theme brightness';
  static const _themeColor = 'theme color';
  static const _themeDensity = 'theme density';
  static const _autoPlayVideos = 'auto play videos';
  static const _hiddenSubreddits = 'hidden subreddits';

  PreferenceCubit() : super(const PreferenceState.empty());

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<PreferenceState> get _nextState async {
    const empty = PreferenceState.empty();
    final prefs = await _prefs;
    return PreferenceState(
      themeBrightness: ThemeBrightness.values.firstWhere(
        (tb) => tb.value == prefs.getString(_themeBrightness),
        orElse: () => empty.themeBrightness,
      ),
      themeColor: ThemeColor.values.firstWhere(
        (tc) => tc.value == prefs.getString(_themeColor),
        orElse: () => empty.themeColor,
      ),
      themeDensity: ThemeDensity.values.firstWhere(
        (td) => td.value == prefs.getString(_themeDensity),
        orElse: () => empty.themeDensity,
      ),
      autoPlayVideos: prefs.getBool(_autoPlayVideos) ?? empty.autoPlayVideos,
      hiddenSubreddits:
          prefs.getStringList(_hiddenSubreddits)?.toSet() ?? const {},
    );
  }

  void init() async {
    emit(await _nextState);
  }

  void nextThemeBrightness() async {
    (await _prefs).setString(
      _themeBrightness,
      ThemeBrightness.values.next(state.themeBrightness).value,
    );
    emit(await _nextState);
  }

  void nextThemeColor() async {
    (await _prefs).setString(
      _themeColor,
      ThemeColor.values.next(state.themeColor).value,
    );
    emit(await _nextState);
  }

  void nextThemeDensity() async {
    (await _prefs).setString(
      _themeDensity,
      ThemeDensity.values.next(state.themeDensity).value,
    );
    emit(await _nextState);
  }

  void nextAutoPlayVideos() async {
    (await _prefs).setBool(
      _autoPlayVideos,
      !state.autoPlayVideos,
    );
    emit(await _nextState);
  }

  void hideSubreddit(String subreddit) async {
    (await _prefs).setStringList(
      _hiddenSubreddits,
      {
        ...state.hiddenSubreddits,
        subreddit,
      }.toList(),
    );
    emit(await _nextState);
  }

  void showSubreddit(String subreddit) async {
    (await _prefs).setStringList(
      _hiddenSubreddits,
      ({
        ...state.hiddenSubreddits,
      }..remove(subreddit))
          .toList(),
    );
    emit(await _nextState);
  }

  void clearAllPreferences() async {
    (await _prefs).clear();
    emit(await _nextState);
  }
}

extension _ListX<T> on List<T> {
  T next(T value) => this[(indexOf(value) + 1) % length];
}

/// A static type, synchronous representation of the user's stored preferences.
///
/// Note that defaults may be provided if the value isn't actually stored.
final class PreferenceState {
  const PreferenceState({
    required this.themeBrightness,
    required this.themeColor,
    required this.themeDensity,
    required this.autoPlayVideos,
    required this.hiddenSubreddits,
  });

  const PreferenceState.empty()
      : themeBrightness = ThemeBrightness.auto,
        themeColor = ThemeColor.blue,
        themeDensity = ThemeDensity.large,
        autoPlayVideos = true,
        hiddenSubreddits = const {};

  final ThemeBrightness themeBrightness;

  final ThemeColor themeColor;

  final ThemeDensity themeDensity;

  final bool autoPlayVideos;

  final Set<String> hiddenSubreddits;
}

enum ThemeBrightness {
  light('light'),
  dark('dark'),
  auto('auto');

  final String value;

  const ThemeBrightness(this.value);
}

enum ThemeColor {
  red('red'),
  orange('orange'),
  yellow('yellow'),
  green('green'),
  blue('blue'),
  indigo('indigo'),
  violet('violet');

  final String value;

  const ThemeColor(this.value);
}

enum ThemeDensity {
  small('small'),
  medium('medium'),
  large('large');

  final String value;

  const ThemeDensity(this.value);
}
