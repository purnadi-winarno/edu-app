import 'dart:math';

class AnimationService {
  // Singleton pattern
  static final AnimationService _instance = AnimationService._internal();

  factory AnimationService() {
    return _instance;
  }

  AnimationService._internal();

  // List of success animations
  final List<String> successAnimations = [
    'assets/animations/thumbs_up.json',
    'assets/animations/success_check.json',
    'assets/animations/trophy.json',
    'assets/animations/celebration.json',
  ];

  // Get a random success animation
  String getRandomSuccessAnimation() {
    final random = Random();
    return successAnimations[random.nextInt(successAnimations.length)];
  }

  // Determine if we should show special animation based on consecutive correct answers
  bool shouldShowSpecialAnimation(int consecutiveCorrectAnswers) {
    return consecutiveCorrectAnswers > 0 && consecutiveCorrectAnswers % 3 == 0;
  }
}
