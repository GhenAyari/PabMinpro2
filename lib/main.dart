import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:minpro1/models/resep.dart';
import 'package:minpro1/widgets/kategori_chip.dart';
import 'package:minpro1/widgets/resep_card.dart';
import 'package:minpro1/screens/tambah_resep.dart';
import 'package:minpro1/screens/edit_resep.dart';
import 'package:minpro1/database/db_helper.dart'; // Import Database Helper

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

  // 1. Variabel penampung data dari database
  List<Resep> daftarResep = [];
  bool isLoading = true; // Indikator loading saat mengambil data

  @override
  void initState() {
    super.initState();
    _refreshResep(); // 2. Ambil data dari database saat aplikasi pertama dibuka
  }

  // 3. Fungsi untuk mengambil data dari SQLite
  Future<void> _refreshResep() async {
    setState(() => isLoading = true);
    
    try {
      final data = await DBHelper.instance.getAllResep();
      setState(() {
        daftarResep = data;
      });
    } catch (e) {
      // Jika terjadi error, errornya akan dicetak ke terminal VS Code
      debugPrint("Terjadi Error pada Database: $e");
    } finally {
      // Blok finally AKAN SELALU DIJALANKAN, sehingga loading pasti berhenti
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Logika filter sekarang menggunakan daftarResep dari database
    List<Resep> resepTampil = daftarResep.where((resep) {
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
      body: isLoading 
      ? const Center(child: CircularProgressIndicator(color: Colors.deepOrange)) // Tampilan saat loading
      : Padding(
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
              ? const Center(child: Text("Belum ada resep. Yuk tambah resep pertamamu! 🍽️"))
              : ListView.builder(
                itemCount: resepTampil.length,
                itemBuilder: (context, index) {
                  final resep = resepTampil[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Slidable(
                      key: ValueKey(resep.id), // Gunakan ID asli dari database
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.50,
                        children: [
                          // --- TOMBOL EDIT ---
                          SlidableAction(
                            onPressed: (context) async {
                              final resepDiperbarui = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditResepScreen(resep: resep),
                                ),
                              );

                              if (resepDiperbarui != null && resepDiperbarui is Resep) {
                                // 4. UPDATE KE DATABASE
                                await DBHelper.instance.updateResep(resepDiperbarui);
                                _refreshResep(); // Refresh layar
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Resep berhasil diperbarui!'), backgroundColor: Colors.green),
                                );
                              }
                            },
                            backgroundColor: Colors.blue.shade400,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                          ),

                          // --- TOMBOL HAPUS ---
                          SlidableAction(
                            onPressed: (context) async {
                              // 5. HAPUS DARI DATABASE
                              await DBHelper.instance.deleteResep(resep.id!);
                              _refreshResep(); // Refresh layar

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${resep.judul} berhasil dihapus'), backgroundColor: Colors.red.shade400),
                              );
                            },
                            backgroundColor: Colors.red.shade400,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Hapus',
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                          ),
                        ],
                      ),
                      child: ResepCard(resep: resep),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      
      // --- TOMBOL TAMBAH RESEP BARU ---
      // --- TOMBOL TAMBAH RESEP BARU ---
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final hasil = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahResepScreen()),
          );

          if (hasil != null && hasil is Resep) {
            // PASANG JEBAKAN TRY-CATCH DI SINI
            try {
              await DBHelper.instance.insertResep(hasil);
              _refreshResep(); 
              
              if (!mounted) return; 
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${hasil.judul} berhasil ditambahkan!'), backgroundColor: Colors.green),
              );
            } catch (error) {
              // JIKA GAGAL, TAMPILKAN ERROR-NYA KE LAYAR HP
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('GAGAL MENYIMPAN: $error'), 
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 5), // Tahan 5 detik agar bisa dibaca
                ),
              );
            }
          }
        },
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}