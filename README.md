# EduLingo - Interactive Language Learning App

An engaging Flutter-based educational application that helps children learn sentence construction in English and Indonesian languages. Inspired by Duolingo's interactive learning approach, this app combines gamification elements with educational content to create an immersive learning experience.

## 🌟 Key Features

### Learning Experience
- Progressive difficulty levels (3 stages) with 20 questions per level
- Dynamic question selection system for varied learning experience
- Interactive drag-and-drop word arrangement interface
- Real-time feedback on answer correctness
- Text-to-speech functionality for proper pronunciation
- Bilingual support (English and Indonesian)

### Game Elements
- Lives system with 3 hearts
- Score tracking and progress monitoring
- Engaging animations and visual feedback
- Celebratory effects for correct answers
- Sound effects and background music
- Game over and level completion screens

### User Interface
- Clean, intuitive, and child-friendly design
- Responsive layout supporting various screen sizes
- Smooth transitions and animations
- High-contrast color scheme for better readability
- Accessible controls and clear navigation

## 🛠️ Technology Stack

### Frontend
- **Framework**: Flutter (latest stable version)
- **State Management**: Provider pattern for efficient state handling
- **Architecture**: Clean Architecture principles with SOLID design patterns

### Core Libraries
- `provider`: ^6.0.0 - For state management
- `flutter_tts`: ^3.0.0 - Text-to-speech functionality
- `audioplayers`: ^5.0.0 - Sound effects and music playback
- `lottie`: ^2.0.0 - High-quality animations
- `shared_preferences`: ^2.0.0 - Local data persistence
- `confetti`: ^0.7.0 - Celebration effects

### Development Tools
- Flutter SDK
- Dart DevTools
- VS Code with Flutter extensions
- Git for version control

## 🎮 Gameplay

1. **Level Selection**
   - Choose from three difficulty levels
   - Each level features 20 unique sentences
   - Progressive complexity in sentence structure

2. **Learning Process**
   - Listen to the target sentence
   - Arrange words in correct order
   - Receive immediate feedback
   - Track progress through level

3. **Scoring System**
   - Three lives per session
   - Points awarded for correct answers
   - Bonus points for quick responses
   - Final score display with achievements

## 📱 Screenshots

[Screenshots will be added showing:]
- Home screen
- Gameplay interface
- Level completion celebration
- Game over screen
- Settings menu

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

```bash
# Clone the repository
git clone https://github.com/purnadi-winarno/edu_app.git

# Navigate to project directory
cd edu_app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Configuration
- Adjust text-to-speech settings in `lib/services/tts_service.dart`
- Modify game parameters in `lib/models/game_state.dart`
- Customize animations in `lib/services/animation_service.dart`

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📈 Future Enhancements

- Additional language support
- Custom word lists and sentences
- User progress tracking and statistics
- Cloud sync for progress
- Multiplayer mode
- Achievement system
- Parent dashboard

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

[Your Name]
- GitHub: @purnadi-winarno
- LinkedIn: linkedin.com/in/purnadi-winarno
- email: purnadi.winarno@gmail.com

## 🙏 Acknowledgments

- Inspired by Duolingo's interactive learning approach
- Flutter team for the amazing framework
- Contributors and open source community
