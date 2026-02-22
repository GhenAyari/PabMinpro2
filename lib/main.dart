import 'package:flutter/material.dart';
import 'package:minpro1/models/resep.dart';
import 'package:minpro1/widgets/kategori_chip.dart';
import 'package:minpro1/widgets/resep_card.dart';

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
        scaffoldBackgroundColor: const Color(0xFFF7F7F9),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
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
  final List<String> kategori = ["Semua", "Berkuah", "Gorengan", "Sambal", "Manis"];
  String kategoriPilihan = "Semua";
  String kataKunciPencarian = "";

  // Data dummy sekarang menggunakan Class Resep (OOP)
  final List<Resep> resepDummy = [
    Resep(judul: "Soto Ayam Lamongan", kategori: "Berkuah", waktu: "45 Menit"),
    Resep(judul: "Tempe Mendoan", kategori: "Gorengan", waktu: "15 Menit"),
    Resep(judul: "Sambal Terasi Bakar", kategori: "Sambal", waktu: "10 Menit"),
  ];

  @override
  Widget build(BuildContext context) {
    // Logika filter tetap sama, hanya memanggil dari objek
    List<Resep> resepTampil = resepDummy.where((resep) {
      final cocokKategori = kategoriPilihan == "Semua" || resep.kategori == kategoriPilihan;
      final cocokPencarian = resep.judul.toLowerCase().contains(kataKunciPencarian.toLowerCase());
      return cocokKategori && cocokPencarian;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Halo, Koki!", style: TextStyle(color: Colors.black87, fontSize: 16)),
            Text("Mau masak apa hari ini?", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
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
                  BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() { kataKunciPencarian = value; });
                },
                decoration: const InputDecoration(
                  hintText: "Cari resep masakan...",
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Daftar Kategori ---
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: kategori.length,
                itemBuilder: (context, index) {
                  final namaKategori = kategori[index];
                  return KategoriChip(
                    namaKategori: namaKategori,
                    isSelected: namaKategori == kategoriPilihan,
                    onTap: () {
                      setState(() { kategoriPilihan = namaKategori; });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // --- Daftar Resep ---
            Expanded(
              child: resepTampil.isEmpty 
              ? const Center(child: Text("Resep tidak ditemukan 🥲"))
              : ListView.builder(
                itemCount: resepTampil.length,
                itemBuilder: (context, index) {
                  return ResepCard(resep: resepTampil[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}