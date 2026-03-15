import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Tambahin ini
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
  final List<String> _kategoriList = ["Berkuah", "Goreng/tumis", "Sambal", "Manis"];

  String? _imagePath;
  bool _isUploading = false; // Indikator loading
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.resep.judul);
    _waktuController = TextEditingController(text: widget.resep.waktu);
    _bahanController = TextEditingController(text: widget.resep.bahan);
    _langkahController = TextEditingController(text: widget.resep.langkah);
    
    _imagePath = widget.resep.imagePath;

    if (_kategoriList.contains(widget.resep.kategori)) {
      _kategoriPilihan = widget.resep.kategori;
    } else {
      _kategoriPilihan = _kategoriList.first;
    }
  }

  // Fungsi ambil foto (diperbarui biar bisa kamera/galeri)
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // --- Wadah Foto (Pintar: Bisa bedain Link Internet vs File Lokal) ---
            GestureDetector(
              onTap: _isUploading ? null : _pickImage,
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
                            child: _imagePath!.startsWith('http')
                                ? Image.network(_imagePath!, fit: BoxFit.cover) // Kalau foto lama (internet)
                                : Image.file(File(_imagePath!), fit: BoxFit.cover), // Kalau foto baru (lokal)
                          ),
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

            TextFormField(controller: _judulController, decoration: InputDecoration(labelText: "Judul Masakan", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _kategoriPilihan,
              decoration: InputDecoration(labelText: "Kategori", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
              items: _kategoriList.map((String kategori) {
                return DropdownMenuItem<String>(value: kategori, child: Text(kategori));
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) { setState(() { _kategoriPilihan = newValue; }); }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(controller: _waktuController, decoration: InputDecoration(labelText: "Waktu Memasak", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 16),
            TextFormField(controller: _bahanController, maxLines: 4, decoration: InputDecoration(labelText: "Bahan-bahan", alignLabelWithHint: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 16),
            TextFormField(controller: _langkahController, maxLines: 5, decoration: InputDecoration(labelText: "Langkah Memasak", alignLabelWithHint: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 32),
            
            ElevatedButton(
              onPressed: _isUploading ? null : () async {
                if (_judulController.text.isEmpty || _bahanController.text.isEmpty || _langkahController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Judul, Bahan, dan Langkah tidak boleh kosong!')));
                  return; 
                }

                setState(() { _isUploading = true; });
                String? finalImageUrl = _imagePath;

                try {
                  // LOGIKA UPLOAD: Jika _imagePath bukan 'http', berarti itu foto baru dari galeri
                  if (_imagePath != null && !_imagePath!.startsWith('http')) {
                    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
                    if (widget.resep.imagePath != null && widget.resep.imagePath!.startsWith('http')) {
    final String oldFileName = widget.resep.imagePath!.split('/').last;
    await Supabase.instance.client.storage
        .from('resep_images')
        .remove([oldFileName]);
  }
                    // Upload ke Supabase
                    await Supabase.instance.client.storage
                        .from('resep_images')
                        .upload(fileName, File(_imagePath!));

                    // Ambil URL barunya
                    finalImageUrl = Supabase.instance.client.storage
                        .from('resep_images')
                        .getPublicUrl(fileName);
                    
                    // OPSIONAL: Disini kamu bisa tambah kode hapus foto lama kalau mau rajin, 
                    // tapi biarkan begini dulu supaya aman buat tugas kuliah.
                  }

                  final resepDiperbarui = Resep(
                    id: widget.resep.id,
                    judul: _judulController.text,
                    kategori: _kategoriPilihan,
                    waktu: _waktuController.text.isEmpty ? "-" : _waktuController.text,
                    bahan: _bahanController.text,
                    langkah: _langkahController.text,
                    imagePath: finalImageUrl, 
                  );

                  if (!mounted) return;
                  Navigator.pop(context, resepDiperbarui);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memperbarui: $e')));
                } finally {
                  if (mounted) setState(() { _isUploading = false; });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: _isUploading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text("Simpan Perubahan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}