import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import '../models/game_state.dart';
import '../services/tts_service.dart';
import '../services/sound_service.dart';
import '../services/animation_service.dart';
import '../widgets/game_progress_bar.dart';
import '../widgets/lives_counter.dart';
import '../widgets/word_button.dart';
import '../widgets/audio_button.dart';
import '../widgets/lottie_overlay.dart';
import 'result_page.dart';
import 'game_over_page.dart';
import '../providers/language_provider.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TTSService _ttsService = TTSService();
  final SoundService _soundService = SoundService();
  final AnimationService _animationService = AnimationService();
  bool _showFeedback = false;
  bool _isCorrect = false;
  bool _showAnimation = false;
  bool _isLivesAnimating = false;
  String _currentAnimation = 'assets/animations/thumbs_up.json';

  @override
  void initState() {
    super.initState();
    // Initialize and speak the first question
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameState = Provider.of<GameState>(context, listen: false);
      final languageProvider = Provider.of<LanguageProvider>(
        context,
        listen: false,
      );

      // Set TTS language based on app language
      _ttsService.setLanguage(languageProvider.locale.languageCode);

      if (gameState.currentQuestion != null) {
        _ttsService.speak(gameState.currentQuestion!['kalimat']);
      }
    });
  }

  @override
  void dispose() {
    _ttsService.dispose();
    _soundService.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    final gameState = Provider.of<GameState>(context, listen: false);
    final isCorrect = gameState.checkAnswer();

    // Perbarui state terlebih dahulu
    if (isCorrect) {
      gameState.handleCorrectAnswerWithoutMoving();

      // Cek apakah ini adalah jawaban benar yang ke-3, 6, 9, dll
      bool isSpecialMilestone = _animationService.shouldShowSpecialAnimation(
        gameState.consecutiveCorrectAnswers,
      );

      if (isSpecialMilestone) {
        // Mainkan sound wow dan langsung tampilkan animasi tanpa alert
        _soundService.playSound('wow');

        // Tampilkan animasi overlay
        setState(() {
          _currentAnimation = _animationService.getRandomSuccessAnimation();
          _showAnimation = true;
          // Tidak menampilkan feedback alert
          _showFeedback = false;
        });

        // Tunggu animasi selesai, lalu lanjut ke pertanyaan berikutnya
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;

          setState(() {
            _showAnimation = false;
          });

          // Lanjut ke pertanyaan berikutnya
          _moveToNextQuestion(gameState);
        });
      } else {
        // Jika bukan milestone khusus, tampilkan feedback biasa
        _soundService.playCorrectSound();
        setState(() {
          _showFeedback = true;
          _isCorrect = true;
        });

        // Tunggu feedback selesai
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;

          setState(() {
            _showFeedback = false;
          });

          // Lanjut ke pertanyaan berikutnya
          _moveToNextQuestion(gameState);
        });
      }
    } else {
      // Jika jawaban salah, mainkan sound dan tampilkan feedback
      _soundService.playIncorrectSound();

      // Animasikan hati berkurang
      setState(() {
        _showFeedback = true;
        _isCorrect = false;
        _isLivesAnimating = true;
      });

      // Tunggu dan lanjutkan
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;

        setState(() {
          _showFeedback = false;
          _isLivesAnimating = false;
        });

        gameState.handleIncorrectAnswer();

        // Cek if game over
        if (gameState.isGameOver()) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const GameOverPage()),
          );
        }
      });
    }
  }

  // Method untuk pindah ke pertanyaan berikutnya
  void _moveToNextQuestion(GameState gameState) {
    // Cek jika ini pertanyaan terakhir
    if (gameState.isLastQuestion) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResultPage()),
      );
      return;
    }

    // Pindah ke pertanyaan selanjutnya
    gameState.moveToNextQuestion();

    // Dapatkan bahasa saat ini dan baca pertanyaan berikutnya
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    _ttsService.setLanguage(languageProvider.locale.languageCode);

    if (gameState.currentQuestion != null) {
      _ttsService.speak(gameState.currentQuestion!['kalimat']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return LottieOverlay(
          isPlaying: _showAnimation,
          animationPath: _currentAnimation,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Level ${gameState.currentLevel}'),
              centerTitle: true,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: LivesCounter(
                    lives: gameState.lives,
                    isAnimating: _isLivesAnimating,
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Progress bar
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GameProgressBar(
                        progress: gameState.progressPercentage,
                        progressColor: Colors.green,
                        width: MediaQuery.of(context).size.width - 32.0,
                      ),
                    ),

                    // Question counter
                    Text(
                      localizations.questionText(
                        '${gameState.currentQuestionIndex + 1}',
                        '${gameState.totalQuestions}',
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Audio button
                    if (gameState.currentQuestion != null)
                      AudioButton(
                        textToSpeak: gameState.currentQuestion!['kalimat'],
                        size: 80,
                      ),

                    const SizedBox(height: 40),

                    // Selected words area (answer construction)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      constraints: const BoxConstraints(minHeight: 100),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          ...gameState.selectedWords.map((word) {
                            return WordButton(
                              word: word,
                              isSelected: true,
                              onTap: () => gameState.unselectWord(word),
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Available words (options)
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          ...gameState.shuffledWords.map((word) {
                            return WordButton(
                              word: word,
                              onTap: () => gameState.selectWord(word),
                            );
                          }),
                        ],
                      ),
                    ),

                    // Check button
                    ElevatedButton(
                      onPressed:
                          gameState.selectedWords.isNotEmpty && !_showFeedback
                              ? _checkAnswer
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        localizations.checkAnswerButton,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Feedback overlay
            bottomSheet:
                _showFeedback
                    ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      color: _isCorrect ? Colors.green : Colors.red,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Lottie animation for correct feedback only
                          if (_isCorrect)
                            Lottie.asset(
                              'assets/animations/success_check.json',
                              width: 80,
                              height: 80,
                              animate: true,
                            ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!_isCorrect)
                                Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              const SizedBox(width: 12),
                              Text(
                                _isCorrect
                                    ? localizations.correctFeedback
                                    : localizations.incorrectFeedback,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // Add spacer to cover the check answer button
                          const SizedBox(height: 60),
                        ],
                      ),
                    )
                    : null,
          ),
        );
      },
    );
  }
}
