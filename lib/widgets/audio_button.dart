import 'package:flutter/material.dart';
import '../services/tts_service.dart';

class AudioButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final ttsService = TTSService();

    return InkWell(
      onTap: () {
        ttsService.speak(textToSpeak);
      },
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
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
          size: size * 0.6,
        ),
      ),
    );
  }
}
