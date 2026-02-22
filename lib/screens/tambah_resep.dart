import 'package:flutter/material.dart';

class TambahResepScreen extends StatefulWidget {
  const TambahResepScreen({super.key});

  @override
  State<TambahResepScreen> createState() => _TambahResepScreenState();
}

class _TambahResepScreenState extends State<TambahResepScreen> {
  // Controller untuk menangkap inputan teks
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  
  // State untuk Dropdown Kategori
  String _kategoriPilihan = 'Berkuah';
  final List<String> _kategoriList = ["Berkuah", "Gorengan", "Sambal", "Manis"];

  // Wajib membersihkan controller saat halaman ditutup agar tidak bocor memori (memory leak)
  @override
  void dispose() {
    _judulController.dispose();
    _waktuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Resep Baru"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87, // Warna teks dan tombol back
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // --- Input Judul Masakan ---
            TextFormField(
              controller: _judulController,
              decoration: InputDecoration(
                labelText: "Judul Masakan",
                hintText: "Contoh: Ayam Goreng Lengkuas",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Dropdown Kategori ---
            DropdownButtonFormField<String>(
              value: _kategoriPilihan,
              decoration: InputDecoration(
                labelText: "Kategori",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              items: _kategoriList.map((String kategori) {
                return DropdownMenuItem<String>(
                  value: kategori,
                  child: Text(kategori),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _kategoriPilihan = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // --- Input Waktu Memasak ---
            TextFormField(
              controller: _waktuController,
              decoration: InputDecoration(
                labelText: "Waktu Memasak",
                hintText: "Contoh: 30 Menit",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // --- Tombol Simpan ---
            ElevatedButton(
              onPressed: () {
                // Untuk sekarang, tombol ini hanya akan menutup halaman dan kembali ke Beranda
                // Nanti kita tambahkan logika untuk menyimpan datanya
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Simpan Resep",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}