import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // <-- Tambahan Supabase
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
  
  // Variabel untuk indikator loading saat upload foto
  bool _isUploading = false; 

  // --- KODE BARU: Fungsi mengambil foto (Bisa Kamera / Galeri) ---
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 70); // Quality 70 agar tidak terlalu berat saat diupload
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // --- KODE BARU: Menu Pilihan Kamera/Galeri ---
  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.deepOrange),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.deepOrange),
              title: const Text('Jepret pakai Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
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
            // --- Wadah Foto ---
            GestureDetector(
              onTap: _isUploading ? null : _showPickerOptions, // Panggil menu pilihan di sini
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
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

            // --- Tombol Simpan & Logika Upload Supabase ---
            ElevatedButton(
              onPressed: _isUploading ? null : () async { // Kunci tombol saat sedang loading
                if (_judulController.text.isEmpty || _bahanController.text.isEmpty || _langkahController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Judul, Bahan, dan Langkah harus diisi!')));
                  return; 
                }

                setState(() { _isUploading = true; }); // Nyalakan animasi loading
                String? imageUrl; // Variabel untuk menyimpan link dari Supabase

                try {
                  // Jika user memilih foto, upload ke Supabase Storage!
                  if (_image != null) {
                    // 1. Buat nama file unik pakai waktu saat ini
                    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

                    // 2. Upload file fisik ke bucket 'resep_images'
                    await Supabase.instance.client.storage
                        .from('resep_images')
                        .upload(fileName, _image!);

                    // 3. Minta link URL publiknya dari Supabase
                    imageUrl = Supabase.instance.client.storage
                        .from('resep_images')
                        .getPublicUrl(fileName);
                  }

                  // 4. Siapkan data resep untuk dikirim kembali ke main.dart
                  final resepBaru = Resep(
                    judul: _judulController.text,
                    kategori: _kategoriPilihan,
                    waktu: _waktuController.text.isEmpty ? "-" : _waktuController.text,
                    bahan: _bahanController.text,
                    langkah: _langkahController.text,
                    imagePath: imageUrl, // <-- Nah! Sekarang isinya adalah LINK WEB, bukan path lokal
                  );

                  if (!mounted) return;
                  Navigator.pop(context, resepBaru);

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal upload foto: $e'), backgroundColor: Colors.red));
                } finally {
                  if (mounted) {
                    setState(() { _isUploading = false; }); // Matikan animasi loading
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              child: _isUploading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                : const Text("Simpan Resep", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}