import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:minpro1/models/resep.dart';
import 'package:minpro1/widgets/kategori_chip.dart';
import 'package:minpro1/widgets/resep_card.dart';
import 'package:minpro1/screens/tambah_resep.dart';
import 'package:minpro1/screens/edit_resep.dart';
import 'package:minpro1/database/db_helper.dart';

// 1. Variabel global untuk merekam status Tema (menyala dari awal dengan Light Mode)
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const AplikasiResepKu());
}

class AplikasiResepKu extends StatelessWidget {
  const AplikasiResepKu({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. ValueListenableBuilder bertugas memantau tombol tema dan me-refresh seluruh aplikasi
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Resepku',
          themeMode: currentMode, // Mengikuti status dari Notifier
          
          // --- TEMA TERANG (LIGHT MODE) ---
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.deepOrange,
            scaffoldBackgroundColor: const Color(0xFFF7F7F9),
            cardColor: Colors.white, // Latar kartu resep terang
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange, brightness: Brightness.light),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
          ),
          
          // --- TEMA GELAP (DARK MODE) ---
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.deepOrange,
            scaffoldBackgroundColor: const Color(0xFF121212), // Latar layar gelap
            cardColor: const Color(0xFF1E1E1E), // Latar kartu resep lebih abu-abu
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange, brightness: Brightness.dark),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
          ),
          home: const BerandaResep(),
        );
      }
    );
  }
}

class BerandaResep extends StatefulWidget {
  const BerandaResep({super.key});

  @override
  State<BerandaResep> createState() => _BerandaResepState();
}

class _BerandaResepState extends State<BerandaResep> {
  final List<String> kategori = ["Semua", "Berkuah", "Goreng/tumis", "Sambal", "Manis"];
  String kategoriPilihan = "Semua";
  String kataKunciPencarian = "";

  List<Resep> daftarResep = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshResep();
  }

  Future<void> _refreshResep() async {
    setState(() => isLoading = true);
    try {
      final data = await DBHelper.instance.getAllResep();
      setState(() {
        daftarResep = data;
      });
    } catch (e) {
      debugPrint("Terjadi Error pada Database: $e");
    } finally {
      setState(() { isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Resep> resepTampil = daftarResep.where((resep) {
      final cocokKategori = kategoriPilihan == "Semua" || resep.kategori == kategoriPilihan;
      final cocokPencarian = resep.judul.toLowerCase().contains(kataKunciPencarian.toLowerCase());
      return cocokKategori && cocokPencarian;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        // Hapus penentuan warna teks (color: Colors.black) agar menyesuaikan tema otomatis
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("mantap!", style: TextStyle(fontSize: 16)),
            Text("handak masak apa pian?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
        // 3. Tombol Sun/Moon di pojok kanan atas
        actions: [
          IconButton(
            icon: Icon(
              themeNotifier.value == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              // Ganti nilai dari Light ke Dark, atau sebaliknya
              themeNotifier.value = themeNotifier.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: isLoading 
      ? const Center(child: CircularProgressIndicator(color: Colors.deepOrange))
      : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Kolom Pencarian ---
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor, // <-- Mengikuti warna tema
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() { kataKunciPencarian = value; });
                },
                decoration: const InputDecoration(
                  hintText: "becari dulu",
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
              ? const Center(child: Text("Belum ada resep. ayodah tambah 🍽️"))
              : ListView.builder(
                itemCount: resepTampil.length,
                itemBuilder: (context, index) {
                  final resep = resepTampil[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Slidable(
                      key: ValueKey(resep.id),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.50,
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              final resepDiperbarui = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditResepScreen(resep: resep)));
                              if (resepDiperbarui != null && resepDiperbarui is Resep) {
                                await DBHelper.instance.updateResep(resepDiperbarui);
                                _refreshResep(); 
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resep berhasil diperbarui!'), backgroundColor: Colors.green));
                              }
                            },
                            backgroundColor: Colors.blue.shade400, foregroundColor: Colors.white, icon: Icons.edit, label: 'Edit', borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                          ),
                          SlidableAction(
                            onPressed: (context) async {
                              await DBHelper.instance.deleteResep(resep.id!);
                              _refreshResep();
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${resep.judul} berhasil dihapus'), backgroundColor: Colors.red.shade400));
                            },
                            backgroundColor: Colors.red.shade400, foregroundColor: Colors.white, icon: Icons.delete, label: 'Hapus', borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
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
      
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final hasil = await Navigator.push(context, MaterialPageRoute(builder: (context) => const TambahResepScreen()));
          if (hasil != null && hasil is Resep) {
            try {
              await DBHelper.instance.insertResep(hasil);
              _refreshResep(); 
              if (!mounted) return; 
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${hasil.judul} berhasil ditambahkan!'), backgroundColor: Colors.green));
            } catch (error) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('GAGAL MENYIMPAN: $error'), backgroundColor: Colors.red, duration: const Duration(seconds: 5)));
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