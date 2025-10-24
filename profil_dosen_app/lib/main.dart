import 'package:flutter/material.dart';
import 'models/dosen.dart';

void main() {
  runApp(const ProfilDosenApp());
}

class ProfilDosenApp extends StatelessWidget {
  const ProfilDosenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Dosen App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const DaftarDosenPage(),
    );
  }
}

class DaftarDosenPage extends StatelessWidget {
  const DaftarDosenPage({super.key});

  final List<Dosen> daftarDosen = const [
    Dosen(
      nama: 'Hery Afriadi, SE, S.Kom, M.Si',
      nip: '00000 00000 0 001',
      jabatan: 'Kaprodi',
      email: 'HeryAfriadi@gmail.com',
      image: 'assets/dosen1.jpg',
    ),
    Dosen(
      nama: 'Dila Nurlaila, M.Kom',
      nip: '00000 00000 0 002',
      jabatan: 'Dosen Luar Biasa',
      email: 'DilaNurlaila@gmail.com',
      image: 'assets/dosen2.jpg',
    ),
    Dosen(
      nama: 'Ahmad Nasukha, S.Hum, M.Si',
      nip: '00000 00000 0 003',
      jabatan: 'Dosen Tetap',
      email: 'AhmadNasukha@gmail.com',
      image: 'assets/dosen3.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        title: const Text('Daftar Dosen'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: daftarDosen.length,
        itemBuilder: (context, index) {
          final dosen = daftarDosen[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  dosen.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                dosen.nama,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              subtitle: Text(dosen.jabatan),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailDosenPage(dosen: dosen),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DetailDosenPage extends StatelessWidget {
  final Dosen dosen;
  const DetailDosenPage({super.key, required this.dosen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        title: const Text('Detail Dosen'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                dosen.image,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              dosen.nama,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            const SizedBox(height: 10),
            infoItem('NIP', dosen.nip),
            infoItem('Jabatan', dosen.jabatan),
            infoItem('Email', dosen.email),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoItem(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 15, color: Colors.black87),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
