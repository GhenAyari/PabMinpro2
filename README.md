<h1 align="center">Aplikasi Resep Masakan Sederhana</h1>

<p align="center">
  Sebuah aplikasi mobile sederhana untuk mencatat, menyimpan, dan mengelola resep masakan favoritmu setiap hari. Dibangun menggunakan <b>Flutter</b>.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android">
</p>

---

## ✨ Fitur Utama

Aplikasi ini dilengkapi dengan berbagai fitur interaktif untuk memudahkan pengguna dalam mengelola resep:

* **📝 CRUD Resep (Create, Read, Update, Delete)**: Tambah resep baru, lihat detail, edit, dan hapus resep dengan mudah.
* **📸 Lampiran Foto (Opsional)**: Terintegrasi dengan galeri/kamera perangkat (Image Picker) untuk menambahkan visual masakan ke dalam resep.
* **🌓 Dark Mode & Light Mode**: Tampilan antarmuka yang adaptif dan nyaman di mata, bisa diganti kapan saja.
* **🔍 Pencarian (Search)**: Temukan resep masakan dengan cepat hanya dengan mengetikkan nama masakannya.
* **🗂️ Kategori Masakan**: Filter resep berdasarkan kategori (Semua, Berkuah, Gorengan, dll).
* **👆 Swipe-to-Action**: Cukup usap (swipe) kartu resep ke kiri untuk memunculkan aksi **Edit** atau **Hapus** dengan interaksi yang *smooth*.

---

## 🍕 Widget yang digunakan

* **MaterialApp:** Pondasi utama seluruh aplikasi. Di sinilah  mengatur nama aplikasi, warna dasar, dan tema (Terang/Gelap).

* **Scaffold:** Kerangka dasar sebuah halaman putih. Dia yang menyediakan tempat untuk AppBar (kepala halaman), body (isi halaman), dan floatingActionButton (tombol melayang).

* **ValueListenableBuilder**: Widget super yang kita pakai terakhir tadi. Fungsinya untuk mendengarkan perubahan (ketika tombol tema diklik) dan langsung me-refresh seluruh UI tanpa harus memuat ulang halaman.

* **Column & Row:** Menyusun widget secara vertikal (atas ke bawah) dan horizontal (kiri ke kanan).

* **ListView & ListView.builder:** Membuat daftar yang bisa di-scroll. Kita pakai ini untuk deretan kategori dan daftar kartu resep di beranda.

* **Container:** Kotak serbaguna. Kita pakai untuk membuat latar belakang kartu resep, memberikan bayangan (shadow), dan lekukan sudut (border radius).

* **Expanded:** Memaksa suatu widget untuk mengisi seluruh sisa ruang kosong yang tersedia di layar (kita pakai agar daftar resep mengisi layar sampai bawah).

* **Padding & SizedBox:** Memberikan jarak atau spasi antar elemen agar tidak berdesakan.

* **Stack & Positioned:** Memungkinkan kita menumpuk widget. Kita menggunakan ini di Halaman Edit untuk menaruh ikon "pensil kecil" persis di atas pojok foto masakan.



---

## 📂 Struktur Direktori

Berikut adalah gambaran arsitektur dan struktur *folder* dari aplikasi ini yang dibuat dengan menggunakan paradigma OOP agar lebih terstruktur dan menghindari spaghetti code.

```text
lib/
│
├── models/
│   └── recipe_model.dart       # Mendefinisikan struktur data resep (Id, Judul, Kategori, Foto, dll)
│
├── screens/
│   ├── home_screen.dart        # Halaman utama (Daftar resep, Pencarian, Filter Kategori)
│   ├── add_recipe_screen.dart  # Form input untuk menambah resep baru & upload foto
│   └── recipe_detail_screen.dart # Halaman untuk membaca detail bahan dan langkah memasak
│
├── widgets/
│   ├── recipe_card.dart        # UI Komponen untuk kartu resep di halaman utama
│   └── slidable_action.dart    # Komponen untuk fitur swipe-to-edit/delete
│
├── utils/
│   └── theme.dart              # Konfigurasi warna untuk Light & Dark mode
│
└── main.dart                   # Entry point aplikasi Flutter

