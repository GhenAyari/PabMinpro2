class Resep {
  int? id;
  final String judul;
  final String kategori;
  final String waktu;
  final String bahan;
  final String langkah;
  final String? imagePath; // <-- Variabel baru untuk foto (Opsional)

  Resep({
    this.id,
    required this.judul,
    required this.kategori,
    required this.waktu,
    required this.bahan,
    required this.langkah,
    this.imagePath, 
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'kategori': kategori,
      'waktu': waktu,
      'bahan': bahan,
      'langkah': langkah,
      'imagePath': imagePath, // <-- Simpan ke database
    };
  }

  factory Resep.fromMap(Map<String, dynamic> map) {
    return Resep(
      id: map['id'],
      judul: map['judul'],
      kategori: map['kategori'],
      waktu: map['waktu'],
      bahan: map['bahan'],
      langkah: map['langkah'],
      imagePath: map['imagePath'], // <-- Ambil dari database
    );
  }
}