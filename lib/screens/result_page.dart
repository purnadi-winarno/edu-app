import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/game_state.dart';
import '../services/sound_service.dart';
import 'level_selection_page.dart';
import 'home_page.dart';
import 'dart:async';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with TickerProviderStateMixin {
  late AnimationController _scoreAnimationController;
  late AnimationController _lottieController;
  late AnimationController _livesAnimationController;
  late Animation<int> _scoreAnimation;
  late Animation<int> _livesAnimation;

  final SoundService _soundService = SoundService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundCompleted = false;

  bool _showLivesText = false;
  bool _showLivesValue = false;
  bool _completedTextAnimDone = false;

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

    // Animation for lives counting
    _livesAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    final gameState = Provider.of<GameState>(context, listen: false);
    final int finalScore = gameState.progressPercentage * 100 ~/ 1;
    final int lives = gameState.lives;

    _scoreAnimation = IntTween(begin: 0, end: finalScore).animate(
      CurvedAnimation(parent: _scoreAnimationController, curve: Curves.easeOut),
    );

    _livesAnimation = IntTween(begin: 0, end: lives).animate(
      CurvedAnimation(parent: _livesAnimationController, curve: Curves.easeOut),
    );

    // Listen for sound completion
    _audioPlayer.onPlayerComplete.listen((_) {
      print("Level complete sound completed naturally");
      if (mounted) {
        setState(() {
          _soundCompleted = true;
        });
      }
    });

    // Start animations after build completes with staggered timing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimations();
      _playLevelCompleteSound();
    });
  }

  // Play level complete sound
  Future<void> _playLevelCompleteSound() async {
    try {
      // Set volume maksimal
      await _audioPlayer.setVolume(1.0);

      // Mainkan suara
      print("Playing level complete sound");
      await _audioPlayer.play(AssetSource('sounds/game_level_complete.wav'));

      // Set timeout jaga-jaga
      Future.delayed(const Duration(seconds: 10), () {
        if (!_soundCompleted && mounted) {
          print("Level complete sound timeout safety");
          setState(() {
            _soundCompleted = true;
          });
        }
      });
    } catch (e) {
      print("Error playing level complete sound: $e");
      // Jika terjadi error, anggap sudah selesai
      setState(() {
        _soundCompleted = true;
      });
    }
  }

  void _startAnimations() {
    // Start trophy animation
    _lottieController.forward();

    // Start score animation after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      _scoreAnimationController.forward();
      _soundService.playSound('click');

      // Listen for score animation completion
      _scoreAnimationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Show lives text after score animation completes
          setState(() {
            _showLivesText = true;
          });

          _soundService.playSound('click');

          // Show lives value after a short delay
          Future.delayed(const Duration(milliseconds: 600), () {
            setState(() {
              _showLivesValue = true;
            });

            // Start lives animation
            _livesAnimationController.forward();
            _soundService.playSound('click');
          });
        }
      });
    });
  }

  // Metode untuk navigasi ke level selanjutnya
  void _navigateToNextLevel() {
    // Jika suara belum selesai, berikan feedback
    if (!_soundCompleted) {
      print("Menunggu suara selesai...");
      // Tambahkan feedback visual
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mohon tunggu..."),
          duration: Duration(milliseconds: 500),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LevelSelectionPage()),
    );
  }

  // Metode untuk kembali ke menu utama
  void _navigateToHome() {
    // Jika suara belum selesai, berikan feedback
    if (!_soundCompleted) {
      print("Menunggu suara selesai...");
      // Tambahkan feedback visual
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mohon tunggu..."),
          duration: Duration(milliseconds: 500),
        ),
      );
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    _lottieController.dispose();
    _livesAnimationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final localizations = AppLocalizations.of(context)!;
    final int level = gameState.currentLevel;
    final int lives = gameState.lives;

    return Scaffold(
      body: Container(
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
                FittedBox(
                  child: Text(
                    localizations.congratulationsTitle,
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Lottie.asset(
                  'assets/animations/celebration.json',
                  width: 200,
                  fit: BoxFit.cover,
                  repeat: true,
                ),
                const SizedBox(height: 30),
                // Animated completion text
                _buildAnimatedCompletionText(localizations, level),
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
                // Animated lives section
                if (_showLivesText)
                  AnimatedBuilder(
                    animation: _livesAnimationController,
                    builder: (context, child) {
                      return _buildResultCard(
                        localizations.remainingLives,
                        _showLivesValue ? '${_livesAnimation.value}' : '',
                      );
                    },
                  ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _navigateToNextLevel,
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
                  onPressed: _navigateToHome,
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
    );
  }

  // Animated completion text with "Completed" word animated
  Widget _buildAnimatedCompletionText(
    AppLocalizations localizations,
    int level,
  ) {
    // Parse the text to isolate "Level X" and "Completed!"
    final String levelText = 'Level $level';
    final String completedText = 'Completed!';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$levelText ',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 1),
          curve: Curves.elasticOut,
          onEnd: () {
            setState(() {
              _completedTextAnimDone = true;
            });
          },
          builder: (context, value, child) {
            return Transform.scale(scale: value, child: child);
          },
          child: Text(
            completedText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.yellow,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
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
