class Resep {
  final String judul;
  final String kategori;
  final String waktu;
  final String bahan;   // Tambahan baru
  final String langkah; // Tambahan baru

  Resep({
    required this.judul,
    required this.kategori,
    required this.waktu,
    required this.bahan,
    required this.langkah,
  });
}