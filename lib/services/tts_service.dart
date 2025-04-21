import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  String _currentLanguage = 'id'; // Default to Indonesian

  // Initialize with a specific language
  Future<void> initialize([String? language]) async {
    try {
      if (language != null) {
        _currentLanguage = language;
      }

      String langCode = _currentLanguage == 'id' ? 'id-ID' : 'en-US';
      print('TTS: Initializing with language $langCode');

      await _flutterTts.setLanguage(langCode);
      await _flutterTts.setSpeechRate(0.5); // Slower rate for children
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _isInitialized = true;
    } catch (e) {
      print('Error initializing TTS: $e');
    }
  }

  // Set the language
  Future<void> setLanguage(String language) async {
    try {
      print('TTS: Changing language from $_currentLanguage to $language');

      if (_currentLanguage == language) {
        print('TTS: Language already set to $language, no change needed');
        return;
      }

      _currentLanguage = language;
      String langCode = _currentLanguage == 'id' ? 'id-ID' : 'en-US';
      print('TTS: Setting language to $langCode');

      await _flutterTts.setLanguage(langCode);

      // Reset voice properties for the new language
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setPitch(1.0);
    } catch (e) {
      print('Error setting TTS language: $e');
    }
  }

  Future<void> speak(String text) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      print('TTS: Speaking text in $_currentLanguage: "$text"');
      await _flutterTts.stop(); // Stop any ongoing speech
      await _flutterTts.speak(text);
    } catch (e) {
      print('Error speaking text: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      print('Error stopping TTS: $e');
    }
  }

  void dispose() {
    try {
      _flutterTts.stop();
    } catch (e) {
      print('Error disposing TTS: $e');
    }
  }
}
