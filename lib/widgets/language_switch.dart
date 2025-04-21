import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../services/tts_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isEnglish = languageProvider.locale.languageCode == 'en';
    final ttsService = TTSService(); // Get TTSService instance

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Flag icon
        Container(
          height: 24,
          width: 24,
          margin: const EdgeInsets.only(right: 8),
          child: Image.asset(
            isEnglish
                ? 'assets/images/flag_us.png'
                : 'assets/images/flag_id.png',
            fit: BoxFit.cover,
          ),
        ),

        // Switch
        Switch(
          value: !isEnglish,
          activeColor: Colors.red,
          trackOutlineColor: WidgetStateProperty.resolveWith<Color>(
            (states) =>
                states.contains(WidgetState.selected)
                    ? Colors.blue
                    : Colors.green,
          ),
          thumbColor: WidgetStateProperty.resolveWith<Color>(
            (states) =>
                states.contains(WidgetState.selected)
                    ? const Color.fromARGB(255, 20, 70, 111)
                    : const Color.fromARGB(255, 92, 236, 97),
          ),
          trackColor: WidgetStateProperty.resolveWith<Color>(
            (states) =>
                states.contains(WidgetState.selected)
                    ? Colors.blue.withOpacity(0.5)
                    : Colors.green.withOpacity(0.5),
          ),
          onChanged: (value) {
            // Update language and also update TTS
            languageProvider.toggleLanguage(context: context);
            // value is true for Indonesian, false for English
            ttsService.setLanguage(!value ? 'en' : 'id');
          },
        ),

        // Language label
        if (MediaQuery.of(context).size.width > 360)
          Text(
            AppLocalizations.of(context)!.languageSwitch,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
      ],
    );
  }
}
