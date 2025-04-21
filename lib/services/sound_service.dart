import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class SoundService {
  AudioPlayer? _audioPlayer;
  AudioPlayer? _longSoundPlayer; // Player khusus untuk suara panjang
  bool _isMuted = false;
  bool _isDisposed = false;
  Completer<void>? _soundCompleter;

  // Sound types
  static const String CLICK = 'click';
  static const String CORRECT = 'correct';
  static const String INCORRECT = 'incorrect';
  static const String WOW = 'wow';
  static const String GAME_OVER = 'game_over';
  static const String LEVEL_COMPLETE = 'level_complete';

  // Singleton pattern
  static final SoundService _instance = SoundService._internal();

  factory SoundService() {
    return _instance;
  }

  SoundService._internal() {
    _initLongSoundPlayer();
  }

  // Initialize long sound player with listeners
  void _initLongSoundPlayer() {
    _longSoundPlayer = AudioPlayer();

    // Listen for completion of sounds
    _longSoundPlayer?.onPlayerComplete.listen((event) {
      print("Sound completed playing");
      if (_soundCompleter != null && !_soundCompleter!.isCompleted) {
        _soundCompleter!.complete();
      }
    });
  }

  // Ensure audio player is initialized
  AudioPlayer _getPlayer() {
    if (_isDisposed) {
      _isDisposed = false;
      _audioPlayer = AudioPlayer();
    }
    _audioPlayer ??= AudioPlayer();
    return _audioPlayer!;
  }

  // Play a sound file from assets
  Future<void> _playSound(String soundFile) async {
    try {
      final player = _getPlayer();
      await player.play(AssetSource('sounds/$soundFile'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  // Play a long sound and wait for completion
  Future<void> _playLongSound(String soundFile) async {
    if (_isMuted) return;

    try {
      // Ensure player is initialized and stop any previous playback
      if (_longSoundPlayer == null) {
        _initLongSoundPlayer();
      } else {
        await _longSoundPlayer?.stop();
      }

      // Create a completer to track completion
      _soundCompleter = Completer<void>();

      // Set volume to full and increase playback rate slightly
      await _longSoundPlayer?.setVolume(1.0);
      await _longSoundPlayer?.setPlaybackRate(1.0);

      // We can't remove listeners from streams easily in Flutter
      // Just create a new listener - the old one will complete automatically

      // Delay slightly to ensure player is ready
      await Future.delayed(const Duration(milliseconds: 300));

      // Play the sound
      print('Playing long sound: $soundFile');
      await _longSoundPlayer?.play(
        AssetSource('sounds/$soundFile'),
        volume: 1.0,
      );

      // Wait for completion or timeout after 15 seconds
      return await Future.any([
        _soundCompleter?.future ?? Future.value(),
        Future.delayed(const Duration(seconds: 15)).then((_) {
          print('Sound playback timed out: $soundFile');
          if (_soundCompleter != null && !_soundCompleter!.isCompleted) {
            _soundCompleter!.complete();
          }
        }),
      ]);
    } catch (e) {
      print('Error playing long sound: $e');
      // Complete the completer in case of error
      if (_soundCompleter != null && !_soundCompleter!.isCompleted) {
        _soundCompleter!.complete();
      }
    }
  }

  // Play a click sound when selecting options
  Future<void> playClickSound() async {
    if (_isMuted) return;
    await _playSound('click.mp3');
  }

  // Play a correct answer sound
  Future<void> playCorrectSound() async {
    if (_isMuted) return;
    await _playSound('ding.mp3');
  }

  // Play an incorrect answer sound
  Future<void> playIncorrectSound() async {
    if (_isMuted) return;
    await _playSound('incorrect.wav');
  }

  // Play a wow sound for special achievements
  Future<void> playWowSound() async {
    if (_isMuted) return;
    await _playSound('wow.mp3');
  }

  // Play game over sound
  Future<void> playGameOverSound() async {
    if (_isMuted) return;

    print("Playing game over sound - START");

    try {
      // Explicitly re-create player untuk suara panjang
      _longSoundPlayer?.dispose();
      _longSoundPlayer = AudioPlayer();

      // Create a completer
      _soundCompleter = Completer<void>();

      // Set listener for completion
      final subscription = _longSoundPlayer!.onPlayerComplete.listen((_) {
        print("Game over sound completed naturally");
        if (_soundCompleter != null && !_soundCompleter!.isCompleted) {
          _soundCompleter!.complete();
        }
      });

      // Play sound
      await _longSoundPlayer?.setVolume(1.0);
      await _longSoundPlayer?.play(AssetSource('sounds/game_over.wav'));

      // Wait for completion or timeout
      await Future.any([
        _soundCompleter!.future,
        Future.delayed(const Duration(seconds: 8)).then((_) {
          print("Game over sound timeout");
          if (_soundCompleter != null && !_soundCompleter!.isCompleted) {
            _soundCompleter!.complete();
          }
        }),
      ]);

      // Clean up
      subscription.cancel();
      print("Game over sound - FINISHED");
    } catch (e) {
      print("Error playing game over sound: $e");
      if (_soundCompleter != null && !_soundCompleter!.isCompleted) {
        _soundCompleter!.complete();
      }
    }
  }

  // Play level complete sound
  Future<void> playGameLevelCompleteSound() async {
    if (_isMuted) return;

    print("Playing level complete sound - START");

    try {
      // Explicitly re-create player untuk suara panjang
      _longSoundPlayer?.dispose();
      _longSoundPlayer = AudioPlayer();

      // Create a completer
      _soundCompleter = Completer<void>();

      // Set listener for completion
      final subscription = _longSoundPlayer!.onPlayerComplete.listen((_) {
        print("Level complete sound completed naturally");
        if (_soundCompleter != null && !_soundCompleter!.isCompleted) {
          _soundCompleter!.complete();
        }
      });

      // Play sound
      await _longSoundPlayer?.setVolume(1.0);
      await _longSoundPlayer?.play(
        AssetSource('sounds/game_level_complete.wav'),
      );

      // Wait for completion or timeout
      await Future.any([
        _soundCompleter!.future,
        Future.delayed(const Duration(seconds: 8)).then((_) {
          print("Level complete sound timeout");
          if (_soundCompleter != null && !_soundCompleter!.isCompleted) {
            _soundCompleter!.complete();
          }
        }),
      ]);

      // Clean up
      subscription.cancel();
      print("Level complete sound - FINISHED");
    } catch (e) {
      print("Error playing level complete sound: $e");
      if (_soundCompleter != null && !_soundCompleter!.isCompleted) {
        _soundCompleter!.complete();
      }
    }
  }

  // Play a sound by type
  Future<void> playSound(String type) async {
    if (_isMuted) return;

    switch (type) {
      case CLICK:
        await playClickSound();
        break;
      case CORRECT:
        await playCorrectSound();
        break;
      case INCORRECT:
        await playIncorrectSound();
        break;
      case WOW:
        await playWowSound();
        break;
      case GAME_OVER:
        await playGameOverSound();
        break;
      case LEVEL_COMPLETE:
        await playGameLevelCompleteSound();
        break;
    }
  }

  // Mute or unmute sounds
  void setMuted(bool muted) {
    _isMuted = muted;
  }

  // Toggle mute state
  void toggleMute() {
    _isMuted = !_isMuted;
  }

  // Get mute state
  bool isMuted() {
    return _isMuted;
  }

  // Dispose resources
  void dispose() {
    try {
      if (_audioPlayer != null) {
        _audioPlayer!.dispose();
        _audioPlayer = null;
      }

      if (_longSoundPlayer != null) {
        _longSoundPlayer!.dispose();
        _longSoundPlayer = null;
      }

      _isDisposed = true;
    } catch (e) {
      print('Error disposing sound player: $e');
    }
  }
}
