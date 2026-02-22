import 'package:flutter/material.dart';
import 'package:minpro1/models/resep.dart';

class TambahResepScreen extends StatefulWidget {
  const TambahResepScreen({super.key});

  @override
  State<TambahResepScreen> createState() => _TambahResepScreenState();
}

class _TambahResepScreenState extends State<TambahResepScreen> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  // Dua controller baru
  final TextEditingController _bahanController = TextEditingController();
  final TextEditingController _langkahController = TextEditingController();
  
  String _kategoriPilihan = 'Berkuah';
  final List<String> _kategoriList = ["Berkuah", "Gorengan", "Sambal", "Manis"];

  @override
  void dispose() {
    _judulController.dispose();
    _waktuController.dispose();
    // Jangan lupa di-dispose
    _bahanController.dispose();
    _langkahController.dispose();
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
            const SizedBox(height: 16),
            
            // --- Input Bahan Masakan ---
            TextFormField(
              controller: _bahanController,
              maxLines: 4, // Membuat kotak input lebih tinggi (multiline)
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: "Bahan-bahan",
                alignLabelWithHint: true, // Label ada di pojok kiri atas
                hintText: "Contoh:\n- 1/2 kg Ayam\n- 2 siung Bawang Putih",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 16),

            // --- Input Langkah Memasak ---
            TextFormField(
              controller: _langkahController,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: "Langkah Memasak",
                alignLabelWithHint: true,
                hintText: "Contoh:\n1. Cuci bersih ayam.\n2. Tumis bumbu hingga harum.",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                // Validasi agar field penting tidak kosong
                if (_judulController.text.isEmpty || _bahanController.text.isEmpty || _langkahController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Judul, Bahan, dan Langkah harus diisi!')),
                  );
                  return; 
                }

                // Bungkus semua data ke objek Resep baru
                final resepBaru = Resep(
                  judul: _judulController.text,
                  kategori: _kategoriPilihan,
                  waktu: _waktuController.text.isEmpty ? "-" : _waktuController.text,
                  bahan: _bahanController.text,
                  langkah: _langkahController.text,
                );

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