import 'package:flutter/material.dart';
import 'dart:math';

class GameState extends ChangeNotifier {
  // Current level
  int _currentLevel = 0;
  int get currentLevel => _currentLevel;

  // Lives system
  int _lives = 3;
  int get lives => _lives;

  // Progress tracking
  int _progress = 0;
  int _totalQuestions = 0;
  double get progressPercentage =>
      _totalQuestions > 0 ? _progress / _totalQuestions : 0.0;

  // Current question data
  int _currentQuestionIndex = 0;
  List<Map<String, dynamic>> _currentLevelQuestions = [];
  List<String> _shuffledWords = [];
  List<String> _selectedWords = [];

  // Getter for current question
  Map<String, dynamic>? get currentQuestion {
    if (_currentLevelQuestions.isEmpty ||
        _currentQuestionIndex >= _currentLevelQuestions.length) {
      return null;
    }
    return _currentLevelQuestions[_currentQuestionIndex];
  }

  // Getters for UI
  List<String> get shuffledWords => _shuffledWords;
  List<String> get selectedWords => _selectedWords;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get totalQuestions => _totalQuestions;
  bool get isLastQuestion =>
      _currentQuestionIndex >= _currentLevelQuestions.length - 1;

  // Sample data for levels
  final List<Map<String, dynamic>> soalLevel1 = [
    {"kalimat": "Surti makan sayur"},
    {"kalimat": "Kucing tidur di sofa"},
    {"kalimat": "Ayah pergi kerja"},
  ];

  final List<Map<String, dynamic>> soalLevel2 = [
    {"kalimat": "Budi bermain bola di lapangan"},
    {"kalimat": "Ibu memasak nasi goreng"},
    {"kalimat": "Adik sedang belajar matematika"},
  ];

  final List<Map<String, dynamic>> soalLevel3 = [
    {"kalimat": "Hari ini cuaca sangat cerah"},
    {"kalimat": "Kupu-kupu terbang di taman bunga"},
    {"kalimat": "Saya suka makan es krim coklat"},
  ];

  // Initialize level
  void setLevel(int level) {
    _currentLevel = level;
    _lives = 3;
    _progress = 0;
    _currentQuestionIndex = 0;

    switch (level) {
      case 1:
        _currentLevelQuestions = soalLevel1;
        break;
      case 2:
        _currentLevelQuestions = soalLevel2;
        break;
      case 3:
        _currentLevelQuestions = soalLevel3;
        break;
      default:
        _currentLevelQuestions = soalLevel1;
    }

    _totalQuestions = _currentLevelQuestions.length;
    _loadCurrentQuestion();
    notifyListeners();
  }

  // Load current question and shuffle words
  void _loadCurrentQuestion() {
    if (currentQuestion != null) {
      final sentence = currentQuestion!["kalimat"] as String;
      final words = sentence.split(' ');

      _shuffledWords = List.from(words);
      _shuffledWords.shuffle(Random());
      _selectedWords = [];
    }
  }

  // Add word to selected words
  void selectWord(String word) {
    if (_shuffledWords.contains(word)) {
      _shuffledWords.remove(word);
      _selectedWords.add(word);
      notifyListeners();
    }
  }

  // Remove word from selected words
  void unselectWord(String word) {
    if (_selectedWords.contains(word)) {
      _selectedWords.remove(word);
      _shuffledWords.add(word);
      notifyListeners();
    }
  }

  // Check if answer is correct
  bool checkAnswer() {
    if (currentQuestion == null) return false;

    final correctSentence = currentQuestion!["kalimat"] as String;
    final userSentence = _selectedWords.join(' ');

    return correctSentence == userSentence;
  }

  // Handle correct answer
  void handleCorrectAnswer() {
    _progress++;
    moveToNextQuestion();
  }

  // Handle incorrect answer
  void handleIncorrectAnswer() {
    _lives--;
    notifyListeners();
  }

  // Move to next question
  void moveToNextQuestion() {
    if (_currentQuestionIndex < _currentLevelQuestions.length - 1) {
      _currentQuestionIndex++;
      _loadCurrentQuestion();
    }
    notifyListeners();
  }

  // Reset game
  void resetGame() {
    _currentLevel = 0;
    _lives = 3;
    _progress = 0;
    _currentQuestionIndex = 0;
    _currentLevelQuestions = [];
    _shuffledWords = [];
    _selectedWords = [];
    notifyListeners();
  }

  // Check if game is over
  bool isGameOver() {
    return _lives <= 0;
  }
}
