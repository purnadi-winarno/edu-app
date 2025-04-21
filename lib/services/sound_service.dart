import 'package:audioplayers/audioplayers.dart';

class SoundService {
  AudioPlayer? _audioPlayer;
  bool _isMuted = false;
  bool _isDisposed = false;

  // Sound types
  static const String CLICK = 'click';
  static const String CORRECT = 'correct';
  static const String INCORRECT = 'incorrect';
  static const String WOW = 'wow';

  // Singleton pattern
  static final SoundService _instance = SoundService._internal();

  factory SoundService() {
    return _instance;
  }

  SoundService._internal();

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
        _isDisposed = true;
      }
    } catch (e) {
      print('Error disposing sound player: $e');
    }
  }
}
