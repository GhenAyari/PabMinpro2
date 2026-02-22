import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiResepKu());
}

class AplikasiResepKu extends StatelessWidget {
  const AplikasiResepKu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Resepku',
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        scaffoldBackgroundColor: const Color(0xFFF7F7F9), // Warna latar lembut
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true, // Menggunakan desain Material 3 yang modern
      ),
      home: const BerandaResep(),
    );
  }
}

class BerandaResep extends StatefulWidget {
  const BerandaResep({super.key});

  @override
  State<BerandaResep> createState() => _BerandaResepState();
}

class _BerandaResepState extends State<BerandaResep> {
  // Data sementara (Dummy Data) untuk kategori
  final List<String> kategori = ["Semua", "Berkuah", "Gorengan", "Sambal", "Manis"];
  String kategoriPilihan = "Semua";

  // Data sementara (Dummy Data) untuk resep
  final List<Map<String, dynamic>> resepDummy = [
    {
      "judul": "Soto Ayam Lamongan",
      "kategori": "Berkuah",
      "waktu": "45 Menit",
    },
    {
      "judul": "Tempe Mendoan",
      "kategori": "Gorengan",
      "waktu": "15 Menit",
    },
    {
      "judul": "Sambal Terasi Bakar",
      "kategori": "Sambal",
      "waktu": "10 Menit",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Halo, Koki!",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            Text(
              "Mau masak apa hari ini?",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Kolom Pencarian ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Cari resep masakan...",
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Daftar Kategori (Horizontal) ---
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: kategori.length,
                itemBuilder: (context, index) {
                  final namaKategori = kategori[index];
                  final isSelected = namaKategori == kategoriPilihan;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        kategoriPilihan = namaKategori;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.deepOrange : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.deepOrange : Colors.grey.shade300,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          namaKategori,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // --- Daftar Resep (Vertical) ---
            Expanded(
              child: ListView.builder(
                itemCount: resepDummy.length,
                itemBuilder: (context, index) {
                  final resep = resepDummy[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                        // Placeholder Gambar
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.restaurant, color: Colors.deepOrange, size: 40),
                        ),
                        const SizedBox(width: 16),
                        // Detail Singkat Resep
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                resep['judul'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                resep['kategori'],
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.timer_outlined, size: 16, color: Colors.deepOrange),
                                  const SizedBox(width: 4),
                                  Text(
                                    resep['waktu'],
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // --- Tombol Tambah Resep ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Nanti diisi aksi untuk pindah ke halaman Tambah Resep
        },
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}