# Aplikasi Edukasi Anak (Mini Duolingo Clone)

## Deskripsi
Aplikasi mobile edukasi berbasis Flutter untuk anak-anak. Tujuannya adalah membantu anak belajar menyusun kalimat dari audio yang dibacakan. Gaya permainan mirip Duolingo, tetapi lebih sederhana dan fun.

## Bahasa dan Tools
- Bahasa: Dart
- Framework: Flutter
- Package:
  - `flutter_tts` untuk Text-to-Speech
  - `lottie` untuk animasi
  - `confetti` untuk efek akhir
  - Optional: `provider` atau `riverpod` untuk state management

---

## Step-by-Step Development

### 1. Halaman Menu Awal (HomePage)
- Buat tampilan sederhana dan menarik untuk anak, dengan tombol interaksi dan animasi untuk memilih level (misalnya "Level 1", "Level 2").
- Tambahkan tombol untuk memulai permainan (misalnya "Mulai Permainan").
- **Tanya ke Cursor:** “Create basic HomePage with a Start button and Level selection”

### 2. Halaman Pilih Level
- Tampilkan pilihan level (misalnya 3 level).
- Gunakan `ElevatedButton` dengan icon/svgicon atau widget lainnya untuk memilih level.
- **Tanya ke Cursor:** “Create Level selection page with buttons for each level”

### 3. Halaman Quiz
- Tampilkan soal (berupa icon speaker) yang autoplay dan bisa direplay dengan menekan icon speaker, beserta options penggalan kata dari kalimat yang diacak seperti duolingo.
- Berikan tombol untuk memutar audio (menggunakan `flutter_tts`).
- Implementasikan sistem nyawa dan progress bar.
- **Tanya ke Cursor:** “Create QuizPage with randomized words, audio button, and lives/progress bar”

### 4. Feedback UI (Benar/Salah)
- Setelah anak menyusun kata, tampilkan feedback (benar atau salah).
- **Tanya ke Cursor:** “Create feedback UI after quiz attempt showing correct/incorrect result”

### 5. Tambahkan Animasi Lottie
- Implementasikan animasi Lottie saat jawaban benar (misalnya animasi senang).
- Tampilkan animasi lain saat jawaban salah.
- **Tanya ke Cursor:** “Add Lottie animation for correct/wrong answer feedback”

### 6. Implementasikan Sistem Nyawa (Lives)
- Setiap jawaban salah mengurangi nyawa (mulai dengan 3 nyawa).
- Jika nyawa habis, tampilkan halaman "Game Over".
- **Tanya ke Cursor:** “Implement lives system, show Game Over page when lives run out”

### 7. Tambah Animasi Confetti
- Setelah anak selesai dengan level atau soal, tampilkan animasi confetti untuk merayakan pencapaian.
- **Tanya ke Cursor:** “Add confetti animation at the end of the quiz”

### 8. Tambah Progress Bar
- Buat progress bar yang bertambah setiap kali jawaban benar.
- Progress bar harus berisi 100% setelah semua soal diselesaikan.
- **Tanya ke Cursor:** “Create progress bar that increases as answers are correct”

### 9. Buat Halaman Hasil
- Tampilkan hasil setelah quiz selesai (jumlah jawaban benar, total nyawa yang tersisa).
- Berikan opsi untuk mengulang permainan atau kembali ke menu awal.
- **Tanya ke Cursor:** “Create result page displaying score and lives left, with options to retry or go back to home”

---

## Struktur Data Contoh

```dart
final List<Map<String, dynamic>> soalLevel1 = [
  {
    "kalimat": "Surti makan sayur",
  },
  {
    "kalimat": "Kucing tidur di sofa",
  },
  {
    "kalimat": "Ayah pergi kerja",
  },
];

buat secara bertahap agar memudahkan saya untuk mengikuti workflow dan testing per step. update dokumen ini dengan rancangan step by step, dan berikan tanda checklist setiap step yang sudah selesai diimplementasikan
