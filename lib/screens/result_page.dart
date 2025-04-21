import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/game_state.dart';
import 'level_selection_page.dart';
import 'home_page.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with TickerProviderStateMixin {
  late AnimationController _scoreAnimationController;
  late AnimationController _lottieController;
  late Animation<int> _scoreAnimation;

  @override
  void initState() {
    super.initState();

    // Animation for score counting
    _scoreAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Animation for celebration
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    final gameState = Provider.of<GameState>(context, listen: false);
    final int finalScore = gameState.progressPercentage * 100 ~/ 1;

    _scoreAnimation = IntTween(begin: 0, end: finalScore).animate(
      CurvedAnimation(parent: _scoreAnimationController, curve: Curves.easeOut),
    );

    // Start animations after build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scoreAnimationController.forward();
      _lottieController.forward();
    });
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final localizations = AppLocalizations.of(context)!;
    final int level = gameState.currentLevel;
    final int lives = gameState.lives;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.shade300, Colors.blue.shade700],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(
                      localizations.congratulationsTitle,
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Lottie.asset(
                      'assets/animations/trophy.json',
                      controller: _lottieController,
                      width: 150,
                      height: 150,
                      repeat: false,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      localizations.levelComplete('$level'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Animated score
                    AnimatedBuilder(
                      animation: _scoreAnimationController,
                      builder: (context, child) {
                        return _buildResultCard(
                          localizations.finalScore,
                          '${_scoreAnimation.value}%',
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildResultCard(localizations.remainingLives, '$lives'),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LevelSelectionPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue.shade700,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        localizations.nextLevelButton,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(
                        localizations.backToMenuButton,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Lottie.asset(
              'assets/animations/celebration.json',
              width: double.infinity,
              fit: BoxFit.cover,
              repeat: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
