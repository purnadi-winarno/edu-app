import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/game_state.dart';
import '../services/sound_service.dart';
import 'level_selection_page.dart';
import 'home_page.dart';

class GameOverPage extends StatefulWidget {
  const GameOverPage({super.key});

  @override
  State<GameOverPage> createState() => _GameOverPageState();
}

class _GameOverPageState extends State<GameOverPage> {
  final SoundService _soundService = SoundService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundCompleted = false;

  @override
  void initState() {
    super.initState();

    // Deteksi kapan sound selesai
    _audioPlayer.onPlayerComplete.listen((_) {
      print("Game over sound completed naturally");
      if (mounted) {
        setState(() {
          _soundCompleted = true;
        });
      }
    });

    // Play game over sound
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Starting game over sound");
      _playGameOverSound();
    });
  }

  // Putar sound dengan cara manual
  Future<void> _playGameOverSound() async {
    try {
      // Set volume maksimal
      await _audioPlayer.setVolume(1.0);

      // Mainkan suara
      print("Playing game over sound");
      await _audioPlayer.play(AssetSource('sounds/game_over.wav'));

      // Set timeout jaga-jaga
      Future.delayed(const Duration(seconds: 10), () {
        if (!_soundCompleted && mounted) {
          print("Game over sound timeout safety");
          setState(() {
            _soundCompleted = true;
          });
        }
      });
    } catch (e) {
      print("Error playing game over sound: $e");
      // Jika terjadi error, anggap sudah selesai
      setState(() {
        _soundCompleted = true;
      });
    }
  }

  @override
  void dispose() {
    // Clean up audio resources
    _audioPlayer.dispose();
    super.dispose();
  }

  // Metode untuk kembali ke level selection dengan delay
  void _navigateToLevelSelection() {
    // Jika suara belum selesai, berikan feedback
    if (!_soundCompleted) {
      print("Menunggu suara selesai...");
      // Tambahkan feedback visual atau hapus jika tidak diinginkan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mohon tunggu..."),
          duration: Duration(milliseconds: 500),
        ),
      );
      return;
    }

    Provider.of<GameState>(context, listen: false).resetGame();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LevelSelectionPage()),
    );
  }

  // Metode untuk kembali ke home page dengan delay
  void _navigateToHome() {
    Provider.of<GameState>(context, listen: false).resetGame();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade300, Colors.red.shade700],
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
                  localizations.gameOverTitle,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Center(
                    child: Lottie.asset(
                      'assets/animations/sad.json',
                      fit: BoxFit.cover,
                      repeat: true,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  localizations.livesExhausted,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  localizations.dontGiveUp,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _navigateToLevelSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red.shade700,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    localizations.tryAgainButton,
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
}
