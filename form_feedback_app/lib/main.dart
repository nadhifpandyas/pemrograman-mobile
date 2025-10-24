import 'package:flutter/material.dart';

void main() {
  runApp(const FormFeedbackApp());
}

class FormFeedbackApp extends StatelessWidget {
  const FormFeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Feedback App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
      ),
      home: const FeedbackFormPage(),
    );
  }
}

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _komentarController = TextEditingController();
  double _rating = 3; // default rating

  void _kirimFeedback() {
    if (_namaController.text.isEmpty || _komentarController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua kolom!')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FeedbackResultPage(
          nama: _namaController.text,
          komentar: _komentarController.text,
          rating: _rating.toInt(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Feedback'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan Feedback Anda:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Input nama
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 15),

            // Input komentar
            TextField(
              controller: _komentarController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Komentar',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.comment),
              ),
            ),
            const SizedBox(height: 20),

            // Rating slider
            const Text(
              'Rating (1–5)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Slider(
              value: _rating,
              min: 1,
              max: 5,
              divisions: 4,
              label: _rating.toStringAsFixed(0),
              activeColor: Colors.teal,
              onChanged: (value) {
                setState(() {
                  _rating = value;
                });
              },
            ),
            Center(
              child: Text(
                'Rating: ${_rating.toInt()} ⭐',
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const Spacer(),

            // Tombol kirim
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _kirimFeedback,
                icon: const Icon(Icons.send),
                label: const Text('Kirim Feedback'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedbackResultPage extends StatelessWidget {
  final String nama;
  final String komentar;
  final int rating;

  const FeedbackResultPage({
    super.key,
    required this.nama,
    required this.komentar,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 6,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terima kasih atas feedback Anda, $nama!',
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Komentar:',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500),
              ),
              Text(
                komentar,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 16),
              Text(
                'Rating: $rating ⭐',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Kembali'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
