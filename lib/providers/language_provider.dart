import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../services/tts_service.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('id'); // Default to Indonesian
  final TTSService _ttsService = TTSService();

  Locale get locale => _locale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  // Load the saved language from shared preferences
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      _locale = Locale(languageCode);
      // Also update TTS service language
      await _ttsService.setLanguage(languageCode);
      notifyListeners();
    }
  }

  // Set and save a new language
  Future<void> setLocale(Locale locale, {BuildContext? context}) async {
    if (_locale == locale) return;

    _locale = locale;

    // Save the language preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);

    // Update TTS language
    await _ttsService.setLanguage(locale.languageCode);

    // Update GameState if context is provided
    if (context != null) {
      final gameState = Provider.of<GameState>(context, listen: false);
      gameState.setLanguage(locale.languageCode);
    }

    notifyListeners();
  }

  // Toggle between English and Indonesian
  Future<void> toggleLanguage({BuildContext? context}) async {
    final newLocale =
        _locale.languageCode == 'en' ? const Locale('id') : const Locale('en');
    await setLocale(newLocale, context: context);
  }
}
