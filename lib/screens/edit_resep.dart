import 'package:flutter/material.dart';
import 'package:minpro1/models/resep.dart';

class EditResepScreen extends StatefulWidget {
  // Menerima data resep yang akan diedit
  final Resep resep;

  const EditResepScreen({super.key, required this.resep});

  @override
  State<EditResepScreen> createState() => _EditResepScreenState();
}

class _EditResepScreenState extends State<EditResepScreen> {
  // Controller untuk teks
  late TextEditingController _judulController;
  late TextEditingController _waktuController;
  late TextEditingController _bahanController;
  late TextEditingController _langkahController;
  
  late String _kategoriPilihan;
  final List<String> _kategoriList = ["Berkuah", "Gorengan", "Sambal", "Manis"];

  @override
  void initState() {
    super.initState();
    // Mengisi controller dengan data resep yang lama saat halaman pertama kali dibuka
    _judulController = TextEditingController(text: widget.resep.judul);
    _waktuController = TextEditingController(text: widget.resep.waktu);
    _bahanController = TextEditingController(text: widget.resep.bahan);
    _langkahController = TextEditingController(text: widget.resep.langkah);
    
    // Mengecek apakah kategori lama ada di dalam list (untuk menghindari error dropdown)
    if (_kategoriList.contains(widget.resep.kategori)) {
      _kategoriPilihan = widget.resep.kategori;
    } else {
      _kategoriPilihan = _kategoriList.first;
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _waktuController.dispose();
    _bahanController.dispose();
    _langkahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Resep"),
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bahanController,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: "Bahan-bahan",
                alignLabelWithHint: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _langkahController,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: "Langkah Memasak",
                alignLabelWithHint: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (_judulController.text.isEmpty || _bahanController.text.isEmpty || _langkahController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Judul, Bahan, dan Langkah tidak boleh kosong!')),
                  );
                  return; 
                }

                // Bungkus data yang SUDAH DIUBAH menjadi objek Resep
                // Bungkus data yang SUDAH DIUBAH menjadi objek Resep
                final resepDiperbarui = Resep(
                  id: widget.resep.id, // WAJIB DITAMBAHKAN AGAR DATABASE TAHU MANA YANG DIUPDATE
                  judul: _judulController.text,
                  kategori: _kategoriPilihan,
                  waktu: _waktuController.text.isEmpty ? "-" : _waktuController.text,
                  bahan: _bahanController.text,
                  langkah: _langkahController.text,
                );

                // Kembalikan ke beranda
                Navigator.pop(context, resepDiperbarui);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600, // Warna beda untuk edit
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("Simpan Perubahan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}