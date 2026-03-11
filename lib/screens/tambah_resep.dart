import 'dart:io'; // Untuk membaca File gambar
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Package galeri
import 'package:minpro1/models/resep.dart';

class TambahResepScreen extends StatefulWidget {
  const TambahResepScreen({super.key});

  @override
  State<TambahResepScreen> createState() => _TambahResepScreenState();
}

class _TambahResepScreenState extends State<TambahResepScreen> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  final TextEditingController _bahanController = TextEditingController();
  final TextEditingController _langkahController = TextEditingController();
  
  String _kategoriPilihan = 'Berkuah';
  final List<String> _kategoriList = ["Berkuah", "Goreng/tumis", "Sambal", "Manis"];

  // --- Variabel untuk Foto ---
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Fungsi untuk membuka galeri
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
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
        title: const Text("Tambah Resep Baru"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // --- Tombol Upload Foto ---
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                ),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                          SizedBox(height: 8),
                          Text("Tambah Foto (Opsional)", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // ... (Kode TextField Judul, Kategori, Waktu, Bahan, Langkah tetap sama seperti sebelumnya) ...
            TextFormField(controller: _judulController, decoration: InputDecoration(labelText: "Judul Masakan", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(value: _kategoriPilihan, decoration: InputDecoration(labelText: "Kategori", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))), items: _kategoriList.map((String kategori) { return DropdownMenuItem<String>(value: kategori, child: Text(kategori)); }).toList(), onChanged: (String? newValue) { if (newValue != null) { setState(() { _kategoriPilihan = newValue; }); } }),
            const SizedBox(height: 16),
            TextFormField(controller: _waktuController, decoration: InputDecoration(labelText: "Waktu Memasak", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 16),
            TextFormField(controller: _bahanController, maxLines: 4, decoration: InputDecoration(labelText: "Bahan-bahan", alignLabelWithHint: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 16),
            TextFormField(controller: _langkahController, maxLines: 5, decoration: InputDecoration(labelText: "Langkah Memasak", alignLabelWithHint: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                if (_judulController.text.isEmpty || _bahanController.text.isEmpty || _langkahController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Judul, Bahan, dan Langkah harus diisi!')));
                  return; 
                }

                final resepBaru = Resep(
                  judul: _judulController.text,
                  kategori: _kategoriPilihan,
                  waktu: _waktuController.text.isEmpty ? "-" : _waktuController.text,
                  bahan: _bahanController.text,
                  langkah: _langkahController.text,
                  imagePath: _image?.path, // <-- Menyimpan lokasi foto ke objek resep
                );

                Navigator.pop(context, resepBaru);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              child: const Text("Simpan Resep", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}