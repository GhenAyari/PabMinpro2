import 'package:flutter/material.dart';

class KategoriChip extends StatelessWidget {
  final String namaKategori;
  final bool isSelected;
  final VoidCallback onTap;

  const KategoriChip({
    super.key,
    required this.namaKategori,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          // Ganti Colors.white menjadi Theme.of(context).cardColor
          color: isSelected ? Colors.deepOrange : Theme.of(context).cardColor, 
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.deepOrange : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            namaKategori,
            style: TextStyle(
              // Ganti Colors.black87 menjadi warna default tema
              color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color, 
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}