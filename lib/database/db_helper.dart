import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/resep.dart';

class DBHelper {
  // Membuat instance single agar database tidak dibuka berkali-kali
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  // Membuka koneksi database
  // Membuka koneksi database
 // Membuka koneksi database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('resep_v3.db'); // <-- UBAH JADI v3
    return _database!;
  }

  // Membuat file database dan tabelnya
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Struktur tabel (Hanya dipanggil sekali saat aplikasi pertama kali diinstal)
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE resep(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        judul TEXT NOT NULL,
        kategori TEXT NOT NULL,
        waktu TEXT NOT NULL,
        bahan TEXT NOT NULL,
        langkah TEXT NOT NULL,
        imagePath TEXT 
      )
    ''');
  }

  // --- KUMPULAN FUNGSI CRUD KE DATABASE ---

  // 1. CREATE: Menyimpan resep baru
  Future<int> insertResep(Resep resep) async {
    final db = await instance.database;
    return await db.insert('resep', resep.toMap());
  }

  // 2. READ: Mengambil semua resep
  Future<List<Resep>> getAllResep() async {
    final db = await instance.database;
    // Mengambil data urut dari yang paling baru ditambahkan (id terbesar)
    final List<Map<String, dynamic>> maps = await db.query('resep', orderBy: 'id DESC');
    return maps.map((map) => Resep.fromMap(map)).toList();
  }

  // 3. UPDATE: Mengedit resep yang sudah ada
  Future<int> updateResep(Resep resep) async {
    final db = await instance.database;
    return db.update(
      'resep',
      resep.toMap(),
      where: 'id = ?',
      whereArgs: [resep.id],
    );
  }

  // 4. DELETE: Menghapus resep berdasarkan ID
  Future<int> deleteResep(int id) async {
    final db = await instance.database;
    return await db.delete(
      'resep',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}