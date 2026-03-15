import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  File? _image;
  final ImagePicker _picker = ImagePicker();
  
  bool _isUploading = false; 

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 70); 
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }


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
      
            GestureDetector(
              onTap: _isUploading ? null : _showPickerOptions, 
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

            ElevatedButton(
              onPressed: _isUploading ? null : () async { 
                if (_judulController.text.isEmpty || _bahanController.text.isEmpty || _langkahController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Judul, Bahan, dan Langkah harus diisi!')));
                  return; 
                }

                setState(() { _isUploading = true; }); 
                String? imageUrl; 

                try {
              
                  if (_image != null) {
                    
                    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

          
                    await Supabase.instance.client.storage
                        .from('resep_images')
                        .upload(fileName, _image!);

                    imageUrl = Supabase.instance.client.storage
                        .from('resep_images')
                        .getPublicUrl(fileName);
                  }

              
                  final resepBaru = Resep(
                    judul: _judulController.text,
                    kategori: _kategoriPilihan,
                    waktu: _waktuController.text.isEmpty ? "-" : _waktuController.text,
                    bahan: _bahanController.text,
                    langkah: _langkahController.text,
                    imagePath: imageUrl, 
                  );

                  if (!mounted) return;
                  Navigator.pop(context, resepBaru);

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal upload foto: $e'), backgroundColor: Colors.red));
                } finally {
                  if (mounted) {
                    setState(() { _isUploading = false; }); 
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