import 'package:flutter/material.dart';
import '../models/resep.dart'; 
import '../screens/detail_resep.dart'; // Wajib import halaman detail yang baru dibuat
import 'dart:io';

class ResepCard extends StatelessWidget {
  final Resep resep;

  const ResepCard({
    super.key,
    required this.resep,
  });

  @override
  Widget build(BuildContext context) {
    // GestureDetector membuat seluruh area kartu bisa diklik
    return GestureDetector(
      onTap: () {
        // Navigasi ke Halaman Detail sambil membawa data resep yang diklik
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailResepScreen(resep: resep),
          ),
        );
      },
      child: Container(
        // margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(15),
                // Tampilkan foto jika ada, jika tidak biarkan kosong
                image: resep.imagePath != null && resep.imagePath!.isNotEmpty
                    ? DecorationImage(
                        image: FileImage(File(resep.imagePath!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              // Tampilkan ikon garpu pisau HANYA jika foto tidak ada
              child: resep.imagePath == null || resep.imagePath!.isEmpty
                  ? const Icon(Icons.restaurant, color: Colors.deepOrange, size: 40)
                  : null,
            ),  
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resep.judul,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    resep.kategori,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 16, color: Colors.deepOrange),
                      const SizedBox(width: 4),
                      Text(
                        resep.waktu,
                        style: const TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}