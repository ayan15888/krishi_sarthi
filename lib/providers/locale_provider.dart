import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');
  bool _isLanguageSelected = false;

  Locale get locale => _locale;
  bool get isLanguageSelected => _isLanguageSelected;

  LocaleProvider() {
    _loadLocale();
  }

  void setLocale(Locale locale) async {
    if (!['en', 'as'].contains(locale.languageCode)) return;
    _locale = locale;
    _isLanguageSelected = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    await prefs.setBool('is_language_selected', true);
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    _isLanguageSelected = prefs.getBool('is_language_selected') ?? false;
    _locale = Locale(languageCode);
    notifyListeners();
  }
}
