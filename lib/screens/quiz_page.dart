import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../services/tts_service.dart';
import '../widgets/game_progress_bar.dart';
import '../widgets/lives_counter.dart';
import '../widgets/word_button.dart';
import '../widgets/audio_button.dart';
import '../widgets/confetti_overlay.dart';
import 'result_page.dart';
import 'game_over_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TTSService _ttsService = TTSService();
  bool _showFeedback = false;
  bool _isCorrect = false;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    // Initialize and speak the first question
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameState = Provider.of<GameState>(context, listen: false);
      if (gameState.currentQuestion != null) {
        _ttsService.speak(gameState.currentQuestion!['kalimat']);
      }
    });
  }

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    final gameState = Provider.of<GameState>(context, listen: false);
    final isCorrect = gameState.checkAnswer();

    setState(() {
      _showFeedback = true;
      _isCorrect = isCorrect;
      if (isCorrect) {
        _showConfetti = true;
      }
    });

    // Wait and then proceed
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _showFeedback = false;
        _showConfetti = false;
      });

      if (isCorrect) {
        gameState.handleCorrectAnswer();

        // Check if this was the last question
        if (gameState.isLastQuestion) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ResultPage()),
          );
          return;
        }

        // Speak the next question
        if (gameState.currentQuestion != null) {
          _ttsService.speak(gameState.currentQuestion!['kalimat']);
        }
      } else {
        gameState.handleIncorrectAnswer();

        // Check if game over
        if (gameState.isGameOver()) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const GameOverPage()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return ConfettiOverlay(
          isPlaying: _showConfetti,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Level ${gameState.currentLevel}'),
              centerTitle: true,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: LivesCounter(lives: gameState.lives),
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
                      ),
                    ),

                    // Question counter
                    Text(
                      'Soal ${gameState.currentQuestionIndex + 1} dari ${gameState.totalQuestions}',
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
                          }).toList(),
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
                          }).toList(),
                        ],
                      ),
                    ),

                    // Check button
                    ElevatedButton(
                      onPressed:
                          gameState.selectedWords.isNotEmpty
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
                      child: const Text(
                        'Periksa Jawaban',
                        style: TextStyle(
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
                      padding: const EdgeInsets.all(16),
                      color: _isCorrect ? Colors.green : Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isCorrect ? Icons.check_circle : Icons.cancel,
                            color: Colors.white,
                            size: 30,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _isCorrect ? 'Benar! 👏' : 'Salah 😔 Coba lagi!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
