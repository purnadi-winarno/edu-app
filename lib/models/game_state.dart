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

  // Current language
  String _currentLanguage = 'id'; // Default to Indonesian

  // Track consecutive correct answers
  int _consecutiveCorrectAnswers = 0;
  int get consecutiveCorrectAnswers => _consecutiveCorrectAnswers;

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

  // Indonesian sentences
  final List<Map<String, dynamic>> soalLevel1_id = [
    {"kalimat": "Surti makan sayur"},
    {"kalimat": "Kucing tidur di sofa"},
    {"kalimat": "Ayah pergi kerja"},
    {"kalimat": "Ibu masak nasi"},
    {"kalimat": "Adik bermain bola"},
    {"kalimat": "Kakak membaca buku"},
    {"kalimat": "Nenek duduk di kursi"},
    {"kalimat": "Kakek minum teh"},
    {"kalimat": "Ani menulis surat"},
    {"kalimat": "Budi menggambar rumah"},
  ];

  final List<Map<String, dynamic>> soalLevel2_id = [
    {"kalimat": "Budi bermain bola di lapangan"},
    {"kalimat": "Ibu memasak nasi goreng"},
    {"kalimat": "Adik sedang belajar matematika"},
    {"kalimat": "Ayah membaca koran pagi"},
    {"kalimat": "Kakak menonton film lucu"},
    {"kalimat": "Nenek menjahit baju baru"},
    {"kalimat": "Guru mengajar di kelas"},
    {"kalimat": "Petani menanam padi di sawah"},
    {"kalimat": "Dokter memeriksa pasien sakit"},
    {"kalimat": "Koki membuat kue lezat"},
  ];

  final List<Map<String, dynamic>> soalLevel3_id = [
    {"kalimat": "Hari ini cuaca sangat cerah"},
    {"kalimat": "Kupu-kupu terbang di taman bunga"},
    {"kalimat": "Saya suka makan es krim coklat"},
    {"kalimat": "Anak-anak bermain di pantai indah"},
    {"kalimat": "Mereka berkemah di hutan pinus"},
    {"kalimat": "Pesawat terbang melewati awan putih"},
    {"kalimat": "Burung-burung berkicau di pagi hari"},
    {"kalimat": "Para nelayan berlayar mencari ikan"},
    {"kalimat": "Pemain musik memainkan lagu indah"},
    {"kalimat": "Kereta api melaju dengan cepat"},
  ];

  // English sentences
  final List<Map<String, dynamic>> soalLevel1_en = [
    {"kalimat": "Surti eats vegetables"},
    {"kalimat": "Cat sleeps on sofa"},
    {"kalimat": "Father goes to work"},
    {"kalimat": "Mother cooks rice"},
    {"kalimat": "Little brother plays ball"},
    {"kalimat": "Sister reads book"},
    {"kalimat": "Grandmother sits on chair"},
    {"kalimat": "Grandfather drinks tea"},
    {"kalimat": "Ani writes letter"},
    {"kalimat": "Budi draws house"},
  ];

  final List<Map<String, dynamic>> soalLevel2_en = [
    {"kalimat": "Budi plays ball in field"},
    {"kalimat": "Mother cooks fried rice"},
    {"kalimat": "Brother is studying mathematics"},
    {"kalimat": "Father reads morning newspaper"},
    {"kalimat": "Sister watches funny movie"},
    {"kalimat": "Grandmother sews new clothes"},
    {"kalimat": "Teacher teaches in class"},
    {"kalimat": "Farmer plants rice in field"},
    {"kalimat": "Doctor examines sick patient"},
    {"kalimat": "Chef makes delicious cake"},
  ];

  final List<Map<String, dynamic>> soalLevel3_en = [
    {"kalimat": "Today the weather is very clear"},
    {"kalimat": "Butterfly flies in flower garden"},
    {"kalimat": "I like eating chocolate ice cream"},
    {"kalimat": "Children play on beautiful beach"},
    {"kalimat": "They camp in pine forest"},
    {"kalimat": "Airplane passes through white clouds"},
    {"kalimat": "Birds chirp in morning"},
    {"kalimat": "Fishermen sail searching for fish"},
    {"kalimat": "Musicians play beautiful song"},
    {"kalimat": "Train moves very quickly"},
  ];

  // Initialize level
  void setLevel(int level) {
    _currentLevel = level;
    _lives = 3;
    _progress = 0;
    _currentQuestionIndex = 0;

    switch (level) {
      case 1:
        _currentLevelQuestions =
            _currentLanguage == 'en' ? soalLevel1_en : soalLevel1_id;
        break;
      case 2:
        _currentLevelQuestions =
            _currentLanguage == 'en' ? soalLevel2_en : soalLevel2_id;
        break;
      case 3:
        _currentLevelQuestions =
            _currentLanguage == 'en' ? soalLevel3_en : soalLevel3_id;
        break;
      default:
        _currentLevelQuestions =
            _currentLanguage == 'en' ? soalLevel1_en : soalLevel1_id;
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
    _consecutiveCorrectAnswers++;
    moveToNextQuestion();
  }

  // Handle correct answer without moving to next question
  void handleCorrectAnswerWithoutMoving() {
    _progress++;
    _consecutiveCorrectAnswers++;
    notifyListeners();
  }

  // Handle incorrect answer
  void handleIncorrectAnswer() {
    _lives--;
    _consecutiveCorrectAnswers = 0;
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
    _consecutiveCorrectAnswers = 0;
    _currentLevelQuestions = [];
    _shuffledWords = [];
    _selectedWords = [];
    notifyListeners();
  }

  // Check if game is over
  bool isGameOver() {
    return _lives <= 0;
  }

  // Set the language
  void setLanguage(String languageCode) {
    if (_currentLanguage != languageCode) {
      _currentLanguage = languageCode;
      if (_currentLevel > 0) {
        // Reload current level with new language
        setLevel(_currentLevel);
      }
    }
  }
}
