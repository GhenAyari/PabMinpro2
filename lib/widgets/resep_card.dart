import 'dart:io';
import 'package:flutter/material.dart';
import 'package:minpro1/models/resep.dart';


import 'package:minpro1/screens/detail_resep.dart'; 

class ResepCard extends StatelessWidget {
  final Resep resep;

  const ResepCard({super.key, required this.resep});

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
       
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailResepScreen(resep: resep),
          ),
        );
      },
      borderRadius: BorderRadius.circular(15), // Membuat efek sentuhan membulat
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // --- BAGIAN FOTO ---
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.orange.shade100,
                child: _tampilkanFoto(), 
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resep.judul,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    resep.kategori,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 14, color: Colors.deepOrange),
                      const SizedBox(width: 4),
                      Text(
                        resep.waktu,
                        style: const TextStyle(fontSize: 12, color: Colors.deepOrange, fontWeight: FontWeight.w500),
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

  Widget _tampilkanFoto() {
    if (resep.imagePath != null && resep.imagePath!.isNotEmpty) {
      if (resep.imagePath!.startsWith('http')) {
        return Image.network(
          resep.imagePath!,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator(color: Colors.deepOrange, strokeWidth: 2));
          },
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
        );
      } else {
        return Image.file(
          File(resep.imagePath!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
        );
      }
    }
    return const Icon(Icons.restaurant, color: Colors.deepOrange, size: 40);
  }
}