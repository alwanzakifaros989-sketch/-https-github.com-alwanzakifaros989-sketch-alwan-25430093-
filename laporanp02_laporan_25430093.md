# Laporan Praktikum Basis Data - Pertemuan 02

* **Nama Mahasiswa:** Alwan Zaki Faros  
* **NPM:** 25430093  
* **Kelas:** S1 Ilmu Komputer  
* **Tanggal Pelaksanaan:** 13 Oktober 2026  
* **Dosen Pengampu:** Dedi Irawan, S.Kom., M.Kom.  

---

## 1. Tujuan Praktikum
Praktikum Pertemuan 2 bertujuan untuk:
1. Melakukan analisis kebutuhan data (*Data Requirement Analysis*) berdasarkan proses bisnis organisasi.
2. Mengidentifikasi proses bisnis, dokumen sumber, entitas, aturan bisnis, kebutuhan informasi, matriks CRUD, dan kamus data.
3. Memahami penanganan masalah kualitas data serta kebutuhan non-fungsional sistem.
4. Menerapkan hasil analisis ke dalam proyek basis data pribadi (*milestone*) sebagai landasan perancangan sistem tahap berikutnya.

---

## 2. Ringkasan Dasar Teori
* **Analisis Kebutuhan Data:** Tahap fundamental untuk menentukan elemen data apa saja yang wajib dikelola oleh suatu sistem berdasarkan alur operasional organisasi.
* **Matriks CRUD (*Create, Read, Update, Delete*):** Alat validasi silang untuk memastikan setiap entitas memiliki siklus pengelolaan data yang jelas tanpa adanya entitas yatim (*orphan entities*).
* **Kamus Data:** Dokumentasi terstruktur yang mendefinisikan arti, tipe data, panjang karakter, aturan, serta penanggung jawab dari setiap elemen data.

---

## 3. Hasil Langkah Percobaan (Studi Kasus Kopma)

### 3.1 Identifikasi Proses Bisnis
Proses bisnis yang diidentifikasi meliputi pendaftaran anggota, pencatatan penjualan ritel, pemesanan barang kepada pemasok, penerimaan barang gudang, dan penyusunan laporan keuangan.
> ![TABEL PB](img/tabelPB_25430093.png)

### 3.2 Identifikasi Aturan Bisnis
Aturan bisnis mendefinisikan batasan integritas data, seperti nomor nota yang harus unik, status stok yang tidak boleh bernilai negatif, dan penyimpanan harga historis pada transaksi.
> ![TABEL AB](img/tabelAB_25430093.png)

### 3.3 Identifikasi Kebutuhan Informasi
Kebutuhan informasi diturunkan dari kebutuhan manajerial, seperti laporan omzet bulanan, identifikasi barang terlaris, pengawasan stok minimum, dan rekapitulasi belanja anggota.
> ![TABEL KI](img/KI_25430093.png)

### 3.4 Matriks CRUD
Memetakan hubungan antara proses bisnis dengan entitas data secara menyeluruh untuk memastikan validitas operasi penyimpanan dan manipulasi data.
> ![Matriks CRUD Kopma](img/matriks_25430093.svg)

### 3.5 Kamus Data
Menyajikan spesifikasi detail setiap atribut data mulai dari nama elemen, tipe data, hingga aturan validasinya.
> ![Kamus data Kopma](img/kamusdata_25430093.svg)

---

## 4. Jawaban Titik Analisis

### 4.1 Titik Analisis 1 — Harga Historis
* **Analisis:** Harga barang di pasar dapat berubah sewaktu-waktu. Jika transaksi penjualan hanya mereferensikan harga terbaru dari tabel master barang, maka laporan keuangan historis di masa lalu akan menjadi tidak valid.
* **Solusi:** Atribut harga saat transaksi wajib disimpan secara independen pada tabel detail transaksi untuk menjaga keakuratan data historis.

### 4.2 Titik Analisis 2 — Nilai Turunan (*Derived Attributes*)
* **Analisis:** Nilai seperti subtotal atau total harga dapat dihitung secara matematis dari perkalian kuantitas dan harga satuan. 
* **Pertimbangan:** Penyimpanan atribut turunan perlu dievaluasi untuk menghindari risiko inkonsistensi data apabila data dasarnya mengalami perubahan, kecuali jika dibutuhkan untuk optimalisasi performa kueri.

### 4.3 Titik Analisis 3 — Entitas Tanpa Operasi Create
* **Analisis:** Ditemukannya entitas dalam matriks CRUD yang tidak memiliki proses *Create* menunjukkan adanya tahapan proses bisnis pada dokumen sumber yang terlewat (misalnya pengelolaan data pemasok/supplier awal).

---

## 5. Hasil Latihan dan Modifikasi

### 5.1 Penambahan Sistem Garansi Produk
Kopma dimodifikasi dengan penambahan fitur manajemen garansi:
1. Setiap barang elektronik memiliki masa garansi terhitung sejak tanggal nota transaksi diterbitkan.
2. Klaim garansi dapat diajukan maksimal 1 kali dalam masa berlaku garansi.
* **Implementasi:** Penambahan atribut `masa_garansi` pada tabel barang, pembuatan tabel relasi `klaim_garansi`, serta pembaruan matriks CRUD.
> ![Modifikasi garansi produk](img/modifgaransi_25430093.svg)

### 5.2 Perbaikan Kebutuhan Kabur (*Vague Requirements*)
Tiga kebutuhan sistem yang awalnya bersifat subjektif telah diperjelas menjadi spesifik dan terukur:

| No. | Pernyataan Asal (Kabur) | Analisis Masalah | Perbaikan Kebutuhan (Spesifik & Terukur) |
| :--: | :-- | :-- | :-- |
| **1** | "Data anggota harus aman." | Kata "aman" terlalu umum dan belum mengatur mekanisme hak akses teknis. | "Nomor telepon dan alamat anggota hanya dapat dilihat oleh ketua koperasi dan petugas yang memiliki hak akses pengelolaan anggota." |
| **2** | "Sistem harus cepat mencari barang." | Kata "cepat" bersifat subjektif tanpa batasan parameter waktu yang jelas. | "Sistem harus dapat menampilkan data barang berdasarkan kode atau nama barang dalam waktu maksimal **1,5 detik** untuk data hingga 5.000 item." |
| **3** | "Laporan stok harus akurat." | Belum menjelaskan kepastian mekanisme perhitungan mutasi data stok. | "Nilai stok pada laporan harus sama dengan jumlah stok pada data barang setelah seluruh transaksi penerimaan dan penjualan berhasil diproses." |

> ![Perbaikan kebutuhan kabur](img/perbaikankebutuhan_25430093.svg)

---

## 6. Tugas Mandiri — Milestone Proyek 2

### 6.1 Identitas Proyek
* **Tema Proyek:** Sistem Manajemen Toko Komputer & Layanan Rakit PC
* **Nama Organisasi:** Apex Tech
* **Lingkup Layanan:** Menyediakan penjualan perangkat keras komputer (*hardware*), laptop, aksesoris gaming, serta layanan jasa perakitan PC kustom bagi pelanggan dan anggota terdaftar.

### 6.2 Proses Bisnis Proyek
Meliputi pendaftaran anggota, pengelolaan kategori dan komponen barang, transaksi penjualan ritel, layanan rakit PC kustom, manajemen stok dari supplier, hingga pembuatan laporan operasional.
> ![Proses bisnis proyek Apex Tech](img/tabelPB_apex_25430093.svg)

### 6.3 Entitas Kandidat
Terdiri atas `Anggota`, `Kategori_Barang`, `Barang`, `Supplier`, `Transaksi_Penjualan`, `Detail_Penjualan`, `Layanan_Rakit_PC`, dan `Klaim_Garansi`. Data produk master dipisahkan dari detail transaksi untuk menjaga integritas historis harga.
> ![Entitas kandidat proyek Apex Tech](img/kandidat_apex_25430093.svg)

### 6.4 Aturan Bisnis Proyek
1. Setiap komponen barang wajib memiliki kategori dan harga jual valid di atas nol.
2. Transaksi penjualan wajib mencatat ID anggota dan ID kasir yang bertugas.
3. Stok komponen akan otomatis terpotong saat transaksi penjualan berhasil divalidasi.
> ![Aturan bisnis proyek Apex Tech](img/aturan_apex_25430093.svg)

### 6.5 Kebutuhan Informasi
1. Laporan ketersediaan stok komponen komputer secara *real-time*.
2. Riwayat pembelian dan rekapitulasi poin loyalitas pelanggan.
3. Laporan komponen terlaris bulanan.
4. Laporan status pengerjaan jasa perakit PC kustom.

### 6.6 Matriks CRUD Proyek
> ![Rancangan matriks CRUD proyek Apex Tech](img/matriks_apex_25430093.svg)

### 6.7 Kamus Data Proyek
> ![Kamus data proyek Apex Tech](img/ERD%20Sistem%20Informasi%20Toko%20Modern.png)

### 6.8 Perhitungan Parameter Personal ($P$)
* **Dua digit terakhir NIM:** `93`
* **Rumus Perhitungan:** 
  $$P = (93 \bmod 10) + 5 = 3 + 5 = 8$$
* **Implementasi Nilai $P$ pada Sistem:**
  * Batas maksimal diskon khusus member berdasarkan level: **8%**;
  * Batas minimum stok peringatan dini (*Low Stock Warning Threshold*): **8 unit**;
  * Maksimum jenis komponen berbeda dalam satu nota transaksi kustom: **8 jenis item**.

### 6.9 Kebutuhan Non-Fungsional
* **Keamanan:** Pembatasan hak akses berbasis peran (*Role-Based Access Control*) untuk data akun dan transaksi sensitif.
* **Kinerja:** Waktu respon pencarian katalog produk hingga 10.000 data maksimal 2 detik.
* **Keandalan:** Menjaga konsistensi data stok dan transaksi secara bersamaan (*concurrency control*).

### 6.10 Isu Kualitas Data
* Mencegah duplikasi kode komponen barang melalui pembatasan *Primary Key*.
* Memastikan kesesuaian antara stok fisik gudang dengan data di basis data.
* Menjaga integritas referensial relasi tabel menggunakan *Foreign Key*.

---

## 7. Pembahasan dan Kendala
Analisis kebutuhan data sangat membantu dalam menentukan struktur informasi yang presisi sebelum melangkah ke tahap perancangan fisik basis data. Pada proyek Apex Tech, pemisahan antara data master komponen dan tabel transaksi terbukti krusial untuk mencegah inkonsistensi historis harga. Kendala utama dalam penyusunan adalah menentukan atribut turunan serta memetakan keterkaitan proses bisnis secara utuh ke dalam matriks CRUD, yang berhasil diselesaikan melalui peninjauan ulang aturan bisnis.

---

## 8. Kesimpulan
1. Praktikum Pertemuan 2 berhasil diselesaikan dengan menyusun dokumen analisis kebutuhan data yang komprehensif untuk studi kasus Kopma maupun proyek mandiri **Apex Tech**.
2. Berdasarkan NIM 25430093, diperoleh parameter personal $P = 8$ yang diterapkan secara konsisten pada batasan diskon, ambang batas stok minimum, dan kuota item transaksi kustom.
3. Seluruh komponen perancangan mulai dari proses bisnis, aturan bisnis, matriks CRUD, kamus data, hingga perbaikan kebutuhan kabur telah terpenuhi sesuai standar operasional praktikum.

---

## 9. Pernyataan Penggunaan AI
Dalam pengerjaan laporan praktikum ini, asisten AI digunakan sebagai alat bantu pendukung (*tools*) untuk membantu merumuskan kalimat perbaikan kebutuhan kabur, menyusun format tabel Markdown, serta memvalidasi struktur dokumen agar tertata rapi. Seluruh konsep studi kasus, perhitungan parameter, dan penyesuaian materi dikerjakan secara mandiri.

---

## 10. Bukti Git
* **Repository GitHub:** `https://github.com/alwanzakifaros/basisdata-25430093`
* **Kode Commit (Hash):**
  * `7f2a1b4` p02: penambahan analisis kebutuhan data dan kamus proyek
  * `3c9e8d1` p02: finalisasi laporan praktikum pertemuan 2

---

## Lembar Checklist Penilaian

### Checklist Khusus Laporan Pertemuan 2
| Jenis | Yang harus ada | Status |
| :--- | :--- | :---: |
| **Berkas Wajib** | `p02_kebutuhan_data_kopma_25430093.md` dan `p02_kebutuhan_data_25430093.md` (proyek) | ✅ Selesai |
| **Bukti Tangkapan Layar** | Tabel PB, AB, KI, matriks CRUD, dan kamus data di berkas proyek (tampilan GitHub) | ✅ Selesai |
| **Analisis Wajib** | Titik Analisis 1–3; perhitungan parameter $P$; perbaikan tiga pernyataan kebutuhan kabur | ✅ Selesai |

### Checklist Umum Praktikum
| Butir Penilaian | Keterangan Dokumen | Status |
| :--- | :--- | :---: |
| **Identitas** | Nama, NIM, kelas, pertemuan, tanggal, dan dosen pengampu lengkap | ✅ Selesai |
| **Tujuan** | Tujuan praktikum disesuaikan dengan bahasa sendiri | ✅ Selesai |
| **Ringkasan Teori** | Pemahaman mandiri terkait Dasar Teori | ✅ Selesai |
| **Langkah Percobaan** | Tangkapan layar langkah kunci beserta keterangan singkat | ✅ Selesai |
| **Titik Analisis** | Jawaban lengkap beserta argumen logis | ✅ Selesai |
| **Latihan & Modifikasi** | Dokumentasi modifikasi sistem dan fitur tambahan | ✅ Selesai |
| **Tugas Mandiri (Milestone)** | Berkas proyek, penjelasan desain, dan parameter personal | ✅ Selesai |
| **Pembahasan & Kendala** | Analisis galat dan solusi penyelesaian | ✅ Selesai |
| **Kesimpulan** | Rangkuman padat dan jelas | ✅ Selesai |
| **Pernyataan AI** | Transparansi penggunaan alat bantu AI | ✅ Selesai |
| **Bukti Git** | Tautan repositori dan hash commit dengan format standar | ✅ Selesai |
| **Keaslian Data** | Identitas dan objek laporan tervalidasi atas NIM bersangkutan | ✅ Selesai |