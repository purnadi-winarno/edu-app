# Edu App - Mini Duolingo Clone

A Flutter application for children to learn how to construct sentences in English and Indonesian languages.

## Features

- 3 levels of difficulty with different sentence complexity (10 questions per level)
- Text-to-speech capability to hear the sentences
- Sound effects for interactions and feedback
- Interactive word selection UI similar to Duolingo
- Lives system (3 hearts)
- Progress tracking
- Confetti celebration on correct answers
- Result screen with score
- Internationalization (English and Indonesian languages)

## How to Play

1. Start by selecting a level
2. Listen to the audio of a sentence by tapping the speaker button
3. Arrange the words in the correct order by tapping on them
4. Click "Check Answer" to verify your answer
5. If correct, you'll advance to the next question with a celebration animation
6. If wrong, you'll lose a heart
7. Complete all questions in a level to see your final score

## Language Support

- English - default language 
- Indonesian - switch using the language toggle in the top-right corner of the home screen

## Technical Details

This app uses:
- Flutter for the UI and logic
- Provider for state management
- flutter_tts for text-to-speech functionality
- audioplayers for sound effects
- confetti for celebrations
- shared_preferences for storing language preference

## Getting Started

To run this app:

```bash
flutter pub get
flutter run
```

## Screenshots

(Screenshots will be added here)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
