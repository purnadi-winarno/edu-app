import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../services/tts_service.dart';

class AudioButton extends StatefulWidget {
  final String textToSpeak;
  final double size;
  final Color color;

  const AudioButton({
    super.key,
    required this.textToSpeak,
    this.size = 64.0,
    this.color = Colors.blue,
  });

  @override
  State<AudioButton> createState() => _AudioButtonState();
}

class _AudioButtonState extends State<AudioButton> {
  final TTSService _ttsService = TTSService();
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initTTS();
      _isInitialized = true;
    }
  }

  Future<void> _initTTS() async {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    await _ttsService.setLanguage(languageProvider.locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );

    return InkWell(
      onTap: () {
        // Set the language before speaking
        _ttsService.setLanguage(languageProvider.locale.languageCode);
        _ttsService.speak(widget.textToSpeak);
      },
      borderRadius: BorderRadius.circular(widget.size / 2),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.volume_up_rounded,
          color: Colors.white,
          size: widget.size * 0.6,
        ),
      ),
    );
  }
}
