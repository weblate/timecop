// Copyright 2020 Kenton Hamaluik
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timecop/models/theme_type.dart';
import 'settings_provider.dart';

class SharedPrefsSettingsProvider extends SettingsProvider {
  final SharedPreferences _prefs;
  SharedPrefsSettingsProvider(this._prefs) : assert(_prefs != null);

  @override
  bool getBool(String key) => _prefs.getBool(key);

  @override
  void setBool(String key, bool value) => (value == null)
      ? _prefs.remove(key)
      : _prefs.setBool(
          key, value); //todo remove null check with null safety implementation

  @override
  int getInt(String key) => _prefs.getInt(key);

  @override
  void setInt(String key, int value) => (value == null)
      ? _prefs.remove(key)
      : _prefs.setInt(
          key, value); //todo remove null check with null safety implementation

  static Future<SharedPrefsSettingsProvider> load() async {
    return SharedPrefsSettingsProvider(await SharedPreferences.getInstance());
  }

  @override
  ThemeType getTheme() {
    String t = _prefs.getString("theme");
    return themeFromString(t) ?? ThemeType.auto;
  }

  @override
  void setTheme(ThemeType theme) {
    if (theme == null) {
      //todo remove null check with null safety implementation
      _prefs.remove("theme");
    } else {
      _prefs.setString("theme", theme.stringify);
    }
  }

  @override
  Locale getLocale() {
    String languageCode = _prefs.getString("languageCode");
    if (languageCode == null) {
      return null;
    }
    String countryCode = _prefs.getString("countryCode");
    return Locale.fromSubtags(
        languageCode: languageCode, countryCode: countryCode);
  }

  @override
  void setLocale(Locale locale) {
    if (locale?.languageCode ==
        null) //todo remove null check with null safety implementation
      _prefs.remove("languageCode");
    else {
      _prefs.setString("languageCode", locale?.languageCode);
    }

    if (locale?.countryCode == null) {
      //todo remove null check with null safety implementation
      _prefs.remove("countryCode");
    } else {
      _prefs.setString("countryCode", locale?.countryCode);
    }
  }
}
