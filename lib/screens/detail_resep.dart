import 'package:flutter/material.dart';
import 'package:minpro1/models/resep.dart'; // Sesuaikan import model
import 'dart:io';

class DetailResepScreen extends StatelessWidget {
  // Menerima data resep dari halaman sebelumnya
  final Resep resep;

  const DetailResepScreen({super.key, required this.resep});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Resep"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // Menggunakan SingleChildScrollView agar halamannya bisa di-scroll ke bawah
      // jika teks bahan dan langkahnya sangat panjang
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Gambar Placeholder Besar ---
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.orange.shade100,
              // Cek apakah resep punya foto
              child: resep.imagePath != null && resep.imagePath!.isNotEmpty
                  ? Image.file(File(resep.imagePath!), fit: BoxFit.cover)
                  : const Icon(Icons.restaurant_menu, size: 100, color: Colors.deepOrange),
            ),
            
            // --- Konten Teks ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Resep
                  Text(
                    resep.judul,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  
                  // Label Kategori dan Waktu
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          resep.kategori,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.timer_outlined, size: 20, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        resep.waktu,
                        style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(thickness: 1), // Garis pembatas
                  ),
                  
                  // --- Bagian Bahan-bahan ---
                  const Row(
                    children: [
                      Icon(Icons.kitchen, color: Colors.deepOrange),
                      SizedBox(width: 8),
                      Text(
                        "Bahan-bahan",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    resep.bahan,
                    style: const TextStyle(fontSize: 16, height: 1.6), // height 1.6 memberi jarak antar baris
                  ),
                  const SizedBox(height: 24),
                  
                  // --- Bagian Langkah Memasak ---
                  const Row(
                    children: [
                      Icon(Icons.format_list_numbered, color: Colors.deepOrange),
                      SizedBox(width: 8),
                      Text(
                        "Langkah Memasak",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    resep.langkah,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 40), // Ruang kosong di paling bawah
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}