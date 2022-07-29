
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const defaultTheme = ThemeMode.system;

extension ThemeModeEx on ThemeMode {
  String get key => toString().split('.').first;
}

ThemeMode toMode(String str) {
  return ThemeMode.values.where((val) => val.name == str).first;
}

Future<void> saveThemeMode(ThemeMode mode) async {
  final pref = await SharedPreferences.getInstance();
  pref.setString(defaultTheme.key, mode.name);
}

Future<ThemeMode> loadThemeMode(SharedPreferences? pref) async {
  if (pref != null) {
    return toMode(pref.getString(defaultTheme.key) ?? defaultTheme.name);
  }
  final _pref = await SharedPreferences.getInstance();
  final mode = toMode(_pref.getString(defaultTheme.key) ?? defaultTheme.name);
  return mode;
}