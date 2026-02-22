import 'package:flutter/material.dart';
import 'package:minpro1/models/resep.dart';
import 'package:minpro1/widgets/kategori_chip.dart';
import 'package:minpro1/widgets/resep_card.dart';
import 'package:minpro1/screens/tambah_resep.dart';
import 'package:minpro1/screens/edit_resep.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

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
  // Data dummy sekarang menggunakan Class Resep (OOP) dan field baru
  final List<Resep> resepDummy = [
    Resep(
      judul: "Soto Ayam Lamongan", 
      kategori: "Berkuah", 
      waktu: "45 Menit",
      bahan: "- 1/2 kg Dada Ayam\n- 2 liter Air\n- Bumbu Halus (Bawang, Kunyit, Ketumbar)",
      langkah: "1. Rebus ayam hingga matang.\n2. Tumis bumbu halus lalu masukkan ke kuah.\n3. Tambahkan garam dan penyedap.",
    ),
    Resep(
      judul: "Tempe Mendoan", 
      kategori: "Gorengan", 
      waktu: "15 Menit",
      bahan: "- 1 Papan Tempe\n- Tepung Terigu\n- Daun Bawang Iris",
      langkah: "1. Iris tempe tipis-tipis.\n2. Campur tepung, bumbu, dan air.\n3. Celupkan tempe dan goreng setengah matang.",
    ),
    Resep(
      judul: "Sambal Terasi Bakar", 
      kategori: "Sambal", 
      waktu: "10 Menit",
      bahan: "- 10 Cabai Rawit\n- 1 sdt Terasi Bakar\n- 1 Buah Tomat",
      langkah: "1. Goreng cabai dan tomat.\n2. Ulek kasar bersama terasi bakar, garam, dan gula.",
    ),
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
            // --- Daftar Resep ---
            // --- Daftar Resep ---
            Expanded(
              child: resepTampil.isEmpty 
              ? const Center(child: Text("Resep tidak ditemukan 🥲"))
              : ListView.builder(
                itemCount: resepTampil.length,
                itemBuilder: (context, index) {
                  final resep = resepTampil[index];
                  
                  // Margin yang tadi kita hapus dari resep_card, kita pindahkan ke sini
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Slidable(
                      key: ValueKey(resep.judul),
                      
                      // endActionPane artinya menu muncul saat diswipe dari kanan ke kiri
                      // ... (kode atasnya sama)
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.50, // Diperbesar jadi 50% layar karena sekarang ada 2 tombol
                        children: [
                          // --- TOMBOL EDIT ---
                          SlidableAction(
                            onPressed: (context) async {
                              // Pindah ke Halaman Edit dan tunggu hasilnya
                              final resepDiperbarui = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditResepScreen(resep: resep),
                                ),
                              );

                              // Jika user menekan tombol "Simpan Perubahan"
                              if (resepDiperbarui != null && resepDiperbarui is Resep) {
                                setState(() {
                                  // Cari posisi (index) resep yang lama di dalam list dummy
                                  int index = resepDummy.indexOf(resep);
                                  if (index != -1) {
                                    // Ganti data lama dengan data baru
                                    resepDummy[index] = resepDiperbarui; 
                                  }
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Resep berhasil diperbarui!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                            backgroundColor: Colors.blue.shade400,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ), // Lengkung di sebelah kiri
                          ),

                          // --- TOMBOL HAPUS ---
                          SlidableAction(
                            onPressed: (context) {
                              setState(() {
                                resepDummy.remove(resep); 
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${resep.judul} berhasil dihapus'),
                                  backgroundColor: Colors.red.shade400,
                                ),
                              );
                            },
                            backgroundColor: Colors.red.shade400,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Hapus',
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ), // Lengkung di sebelah kanan
                          ),
                        ],
                      ),
                      // ... (kode child: ResepCard(resep: resep) sama)
                      
                      // Kartu resepmu
                      child: ResepCard(resep: resep),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Ubah menjadi async
        onPressed: () async {
          // Menunggu hasil (return data) dari halaman TambahResepScreen
          final hasil = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahResepScreen(),
            ),
          );

          // Jika hasilnya tidak kosong (berarti user menekan tombol Simpan)
          if (hasil != null && hasil is Resep) {
            setState(() {
              // Tambahkan resep baru ke dalam list dummy
              resepDummy.add(hasil); 
            });

            // Opsional: Tampilkan notifikasi sukses di bawah layar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${hasil.judul} berhasil ditambahkan!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}