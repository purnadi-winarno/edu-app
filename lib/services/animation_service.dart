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
    'assets/animations/bintang_kacamata.json',
    'assets/animations/bintang.json',
    'assets/animations/fireworks1.json',
    'assets/animations/fireworks2.json',
    'assets/animations/happy_tree.json',
    'assets/animations/happy_water_melon.json',
    'assets/animations/rocket.json',
    'assets/animations/rocket1.json',
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
