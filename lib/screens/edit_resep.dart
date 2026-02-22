import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minpro1/models/resep.dart';

class EditResepScreen extends StatefulWidget {
  final Resep resep;

  const EditResepScreen({super.key, required this.resep});

  @override
  State<EditResepScreen> createState() => _EditResepScreenState();
}

class _EditResepScreenState extends State<EditResepScreen> {
  late TextEditingController _judulController;
  late TextEditingController _waktuController;
  late TextEditingController _bahanController;
  late TextEditingController _langkahController;
  
  late String _kategoriPilihan;
  final List<String> _kategoriList = ["Berkuah", "Gorengan", "Sambal", "Manis"];

  // --- Variabel untuk menampung path foto ---
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.resep.judul);
    _waktuController = TextEditingController(text: widget.resep.waktu);
    _bahanController = TextEditingController(text: widget.resep.bahan);
    _langkahController = TextEditingController(text: widget.resep.langkah);
    
    // Mengambil data foto lama jika ada
    _imagePath = widget.resep.imagePath;

    if (_kategoriList.contains(widget.resep.kategori)) {
      _kategoriPilihan = widget.resep.kategori;
    } else {
      _kategoriPilihan = _kategoriList.first;
    }
  }

  // Fungsi untuk mengganti foto
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
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
        title: const Text("Edit Resep"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // --- Tombol Ganti Foto ---
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
                child: _imagePath != null && _imagePath!.isNotEmpty
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(File(_imagePath!), fit: BoxFit.cover),
                          ),
                          // Ikon kecil di pojok untuk menandakan bisa diubah
                          Positioned(
                            right: 10,
                            bottom: 10,
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: const Icon(Icons.edit, color: Colors.white, size: 20),
                            ),
                          )
                        ],
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                          SizedBox(height: 8),
                          Text("Tambah Foto", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: _judulController,
              decoration: InputDecoration(labelText: "Judul Masakan", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _kategoriPilihan,
              decoration: InputDecoration(labelText: "Kategori", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
              items: _kategoriList.map((String kategori) {
                return DropdownMenuItem<String>(value: kategori, child: Text(kategori));
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
              decoration: InputDecoration(labelText: "Waktu Memasak", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bahanController,
              maxLines: 4,
              decoration: InputDecoration(labelText: "Bahan-bahan", alignLabelWithHint: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _langkahController,
              maxLines: 5,
              decoration: InputDecoration(labelText: "Langkah Memasak", alignLabelWithHint: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
            ),
            const SizedBox(height: 32),
            
            ElevatedButton(
              onPressed: () {
                if (_judulController.text.isEmpty || _bahanController.text.isEmpty || _langkahController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Judul, Bahan, dan Langkah tidak boleh kosong!')));
                  return; 
                }

                // Bungkus data dengan imagePath yang baru/lama
                final resepDiperbarui = Resep(
                  id: widget.resep.id,
                  judul: _judulController.text,
                  kategori: _kategoriPilihan,
                  waktu: _waktuController.text.isEmpty ? "-" : _waktuController.text,
                  bahan: _bahanController.text,
                  langkah: _langkahController.text,
                  imagePath: _imagePath, // <-- Path foto ikut disimpan
                );

                Navigator.pop(context, resepDiperbarui);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
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