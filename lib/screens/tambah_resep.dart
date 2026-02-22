import 'package:flutter/material.dart';
import 'package:minpro1/models/resep.dart'; // Import model resep di sini

class TambahResepScreen extends StatefulWidget {
  const TambahResepScreen({super.key});

  @override
  State<TambahResepScreen> createState() => _TambahResepScreenState();
}

class _TambahResepScreenState extends State<TambahResepScreen> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  
  String _kategoriPilihan = 'Berkuah';
  final List<String> _kategoriList = ["Berkuah", "Gorengan", "Sambal", "Manis"];

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
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _judulController,
              decoration: InputDecoration(
                labelText: "Judul Masakan",
                hintText: "Contoh: Ayam Goreng Lengkuas",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _kategoriPilihan,
              decoration: InputDecoration(
                labelText: "Kategori",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              items: _kategoriList.map((String kategori) {
                return DropdownMenuItem<String>(
                  value: kategori,
                  child: Text(kategori),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() { _kategoriPilihan = newValue; });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _waktuController,
              decoration: InputDecoration(
                labelText: "Waktu Memasak",
                hintText: "Contoh: 30 Menit",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // 1. Validasi: Pastikan form tidak kosong
                if (_judulController.text.isEmpty || _waktuController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Judul dan Waktu harus diisi!')),
                  );
                  return; // Hentikan eksekusi jika kosong
                }

                // 2. Bungkus data ke dalam objek Resep
                final resepBaru = Resep(
                  judul: _judulController.text,
                  kategori: _kategoriPilihan,
                  waktu: _waktuController.text,
                );

                // 3. Kembali ke halaman sebelumnya SAMBIL membawa data resepBaru
                Navigator.pop(context, resepBaru);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("Simpan Resep", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}