import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

//elevent labs api key: sk_75a22e764955b824aca1a1ea391a0595beb9fc17168c271d
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

  // Constructor
  GameState() {
    _initializeLanguage();
  }

  // Initialize language from shared preferences
  Future<void> _initializeLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? languageCode = prefs.getString('languageCode');
      if (languageCode != null && languageCode != _currentLanguage) {
        _currentLanguage = languageCode;
        if (_currentLevel > 0) {
          // Reload current level if needed
          setLevel(_currentLevel);
        }
      }
    } catch (e) {
      print('Error loading language in GameState: $e');
    }
  }

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

  // Indonesian sentences level 1 (20 pertanyaan)
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
    {"kalimat": "Andi bermain gitar"},
    {"kalimat": "Burung terbang tinggi"},
    {"kalimat": "Saya belajar matematika"},
    {"kalimat": "Teman meminjam buku"},
    {"kalimat": "Dia memakan apel"},
    {"kalimat": "Mereka menari bersama"},
    {"kalimat": "Kita berjalan kaki"},
    {"kalimat": "Sepeda berwarna merah"},
    {"kalimat": "Anjing menggonggong keras"},
    {"kalimat": "Petani mencangkul sawah"},
  ];

  // Indonesian sentences level 2 (20 pertanyaan)
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
    {"kalimat": "Anak bermain bola di taman"},
    {"kalimat": "Paman membeli mobil baru"},
    {"kalimat": "Bibi menjual sayur segar"},
    {"kalimat": "Kucing mengejar tikus kecil"},
    {"kalimat": "Murid mengerjakan tugas sekolah"},
    {"kalimat": "Polisi mengatur lalu lintas"},
    {"kalimat": "Nelayan menangkap ikan besar"},
    {"kalimat": "Pilot menerbangkan pesawat tinggi"},
    {"kalimat": "Penjual menawarkan barang bagus"},
    {"kalimat": "Perawat membantu pasien lanjut"},
  ];

  // Indonesian sentences level 3 (20 pertanyaan)
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
    {"kalimat": "Kita akan pergi ke pantai besok"},
    {"kalimat": "Dia membaca buku di perpustakaan sekolah"},
    {"kalimat": "Kucingku suka tidur di bawah meja"},
    {"kalimat": "Petani menanam padi saat musim hujan"},
    {"kalimat": "Pohon-pohon bergoyang tertiup angin kencang"},
    {"kalimat": "Ayah memasak makanan enak untuk keluarga"},
    {"kalimat": "Guru menjelaskan pelajaran dengan sabar"},
    {"kalimat": "Pengendara motor melaju dengan sangat hati-hati"},
    {"kalimat": "Ombak besar menghantam karang di tepi pantai"},
    {"kalimat": "Bunga-bunga di taman bermekaran sangat indah"},
  ];

  // English sentences level 1 (20 pertanyaan)
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
    {"kalimat": "Andy plays guitar"},
    {"kalimat": "Bird flies high"},
    {"kalimat": "I study mathematics"},
    {"kalimat": "Friend borrows book"},
    {"kalimat": "He eats apple"},
    {"kalimat": "They dance together"},
    {"kalimat": "We walk together"},
    {"kalimat": "Bicycle is red"},
    {"kalimat": "Dog barks loudly"},
    {"kalimat": "Farmer hoes field"},
  ];

  // English sentences level 2 (20 pertanyaan)
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
    {"kalimat": "Child plays ball in park"},
    {"kalimat": "Uncle buys new car"},
    {"kalimat": "Aunt sells fresh vegetables"},
    {"kalimat": "Cat chases small mouse"},
    {"kalimat": "Student does school assignment"},
    {"kalimat": "Police directs traffic flow"},
    {"kalimat": "Fisherman catches big fish"},
    {"kalimat": "Pilot flies plane high"},
    {"kalimat": "Seller offers good merchandise"},
    {"kalimat": "Nurse helps elderly patient"},
  ];

  // English sentences level 3 (20 pertanyaan)
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
    {"kalimat": "We will go to beach tomorrow"},
    {"kalimat": "He reads book in school library"},
    {"kalimat": "My cat likes sleeping under table"},
    {"kalimat": "Farmer plants rice during rainy season"},
    {"kalimat": "Trees sway blown by strong wind"},
    {"kalimat": "Father cooks delicious food for family"},
    {"kalimat": "Teacher explains lesson with patience"},
    {"kalimat": "Motorcycle rider drives very carefully"},
    {"kalimat": "Big waves hit rocks at seashore"},
    {"kalimat": "Flowers in garden bloom very beautifully"},
  ];

  // Initialize level
  void setLevel(int level) {
    _currentLevel = level;
    _lives = 3;
    _progress = 0;
    _currentQuestionIndex = 0;
    _consecutiveCorrectAnswers = 0;

    // Pilih kumpulan pertanyaan berdasarkan level dan bahasa
    List<Map<String, dynamic>> allQuestions;
    switch (level) {
      case 1:
        allQuestions = _currentLanguage == 'en' ? soalLevel1_en : soalLevel1_id;
        break;
      case 2:
        allQuestions = _currentLanguage == 'en' ? soalLevel2_en : soalLevel2_id;
        break;
      case 3:
        allQuestions = _currentLanguage == 'en' ? soalLevel3_en : soalLevel3_id;
        break;
      default:
        allQuestions = _currentLanguage == 'en' ? soalLevel1_en : soalLevel1_id;
    }

    // Acak semua pertanyaan
    allQuestions.shuffle(Random());

    // Ambil 10 pertanyaan pertama
    _currentLevelQuestions = allQuestions.take(10).toList();
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
