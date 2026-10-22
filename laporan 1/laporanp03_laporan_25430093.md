# Laporan Praktikum Basis Data - Pertemuan 03

**Nama:** Alwan Zaki Faros  
**NIM:** 25430093  
**Kelas:** S1 Ilmu Komputer  
**Tanggal:** 13 Oktober 2026  
**Dosen:** Dedi Irawan, S.Kom., M.Kom.

---

## 1. Tujuan Praktikum

1. Memahami konsep dasar pemodelan data konseptual dan fisik menggunakan Entity Relationship Diagram (ERD).
2. Mengidentifikasi entitas, atribut kunci (Primary Key/Foreign Key), relasi, serta tingkat kardinalitas yang akurat.
3. Melakukan penelusuran balik (*traceability*) antara kebutuhan informasi sistem dengan jalur relasi pada ERD.
4. Mengevaluasi dan memodifikasi rancangan ERD berdasarkan aturan bisnis serta ulasan sejawat (*peer review*).
5. Menerapkan pemodelan ERD pada proyek mandiri Sistem Perpustakaan Modern serta mendokumentasikannya menggunakan Git.

---

## 2. Ringkasan Dasar Teori

Entity Relationship Diagram (ERD) adalah model konseptual yang memetakan struktur data dan hubungan antarobjek di dalam sebuah sistem basis data. Komponen utamanya terdiri atas **Entitas** (tabel/objek nyata), **Atribut** (karakteristik data), dan **Relasi** (hubungan antarentitas). 

Kardinalitas relasi menggambarkan batasan jumlah keterhubungan, seperti *One-to-One* (1:1), *One-to-Many* (1:N), hingga *Many-to-Many* (M:N). Relasi banyak-ke-banyak wajib diurai menggunakan entitas asosiatif (tabel perantara) agar integritas data transaksi tetap terjaga. Setiap garis relasi harus didefinisikan dengan kata kerja yang jelas agar mencerminkan proses bisnis yang otentik.

---

## 3. Hasil Langkah Percobaan

### 3.1 Perancangan ERD Koperasi Mahasiswa (Kopma)
Latihan awal dilakukan dengan merancang basis data Koperasi Mahasiswa untuk memahami interaksi antar entitas operasional seperti petugas, anggota, barang, penjualan, dan pembelian.

![Gambar 3.1: Skema ERD Koperasi Mahasiswa (Kopma) sebagai latihan awal praktikum](img/ERD%20Sistem%20Perpustakaan%20Modern.png)

---

## 4. Jawaban Titik Analisis

### Titik Analisis 1 — Makna Relasi dan Pelabelan
Garis relasi tanpa label akan menyulitkan pembaca dalam menginterpretasikan alur kerja sistem. Setiap relasi harus merepresentasikan aksi nyata (kata kerja) yang merujuk pada aturan bisnis yang berlaku.

### Titik Analisis 2 — Penentuan Kardinalitas Berdasarkan Aturan Bisnis
Kardinalitas ditentukan melalui analisis logika operasional, bukan sekadar estetika diagram. Sebagai contoh, satu anggota dapat melakukan banyak transaksi peminjaman ($1:N$), namun satu transaksi peminjaman hanya dimiliki oleh satu anggota spesifik.

### Titik Analisis 3 — Validasi Jalur Kebutuhan Informasi
ERD yang baik harus mampu mengakomodasi seluruh daftar Kebutuhan Informasi (KI). Jika suatu informasi gagal ditelusuri melalui jalur relasi yang ada, maka rancangan entitas wajib ditinjau ulang dan diperbaiki.

---

## 5. Hasil Latihan dan Modifikasi

### 5.1 Penambahan Fitur Poin Loyalitas pada Kopma
Untuk mengakomodasi sistem reward, penambahan saldo poin tidak cukup hanya diletakkan sebagai atribut biasa pada tabel `anggota` karena akan menghilangkan jejak historis transaksi. Oleh karena itu, dibuat entitas khusus `riwayat_poin` yang terhubung secara relasional ke tabel `anggota` dan `penjualan`.

### 5.2 Analisis Relasi Penjualan–Barang Tanpa Entitas Asosiatif
Jika relasi penjualan dan barang dihubungkan secara *Many-to-Many* langsung tanpa tabel perantara (`detail_penjualan`), sistem akan kehilangan kemampuan merekam kuantitas (*qty*) per item serta harga historis saat transaksi terjadi.

---

## 6. Tugas Mandiri: Milestone Proyek 3

### 6.1 Identitas Proyek
- **Tema:** Perpustakaan Digital & Fisik  
- **Nama Organisasi:** Perpustakaan M MEDIA  
- **Deskripsi Layanan:** Mengelola manajemen koleksi buku, data keanggotaan, sirkulasi peminjaman, pengembalian eksemplar, pencatatan denda, serta rekapitulasi petugas secara terstruktur.

### 6.2 Entitas pada ERD Perpustakaan M MEDIA
1. `anggota`
2. `buku` (Master judul buku)
3. `eksemplar` (Salinan fisik buku)
4. `petugas`
5. `peminjaman`
6. `detail_peminjaman` (Entitas asosiatif)
7. `pengembalian`
8. `denda`

### 6.3 Tabel Relasi dan Kardinalitas

| No. | Entitas A — Entitas B | Kardinalitas | Aturan Bisnis / Dasar Pemodelan |
| :---: | :--- | :---: | :--- |
| 1 | `anggota` — `peminjaman` | $1 : N$ | Satu anggota dapat melakukan beberapa kali transaksi peminjaman. |
| 2 | `petugas` — `peminjaman` | $1 : N$ | Satu petugas dapat melayani banyak transaksi peminjaman buku. |
| 3 | `buku` — `eksemplar` | $1 : N$ | Satu judul buku memiliki beberapa eksemplar fisik di perpustakaan. |
| 4 | `peminjaman` — `detail_peminjaman` | $1 : N$ | Satu nota peminjaman mencakup beberapa rincian eksemplar buku. |
| 5 | `eksemplar` — `detail_peminjaman` | $1 : N$ | Satu eksemplar buku dapat dipinjam berkali-kali dari waktu ke waktu. |
| 6 | `peminjaman` — `pengembalian` | $1 : 0..1$ | Satu transaksi peminjaman menghasilkan satu catatan pengembalian ketika selesai. |
| 7 | `peminjaman` — `denda` | $1 : N$ | Satu transaksi peminjaman dapat memuat catatan denda jika terjadi keterlambatan. |

### 6.4 Penelusuran Kebutuhan Informasi ke Jalur ERD

| Kebutuhan Informasi (KI) | Jalur Relasi di ERD | Keterangan |
| :--- | :--- | :--- |
| Daftar anggota aktif | `anggota` | Memfilter data anggota berdasarkan status keaktifan. |
| Katalog koleksi buku | `buku` $\rightarrow$ `eksemplar` | Menampilkan judul buku dan ketersediaan fisik eksemplarnya. |
| Riwayat peminjaman anggota | `anggota` $\rightarrow$ `peminjaman` $\rightarrow$ `detail_peminjaman` $\rightarrow$ `eksemplar` $\rightarrow$ `buku` | Menelusuri buku apa saja yang pernah dipinjam oleh seorang anggota. |
| Rekapitulasi denda keterlambatan | `peminjaman` $\rightarrow$ `denda` | Menghitung akumulasi denda berdasarkan durasi keterlambatan pengembalian. |

### 6.5 Catatan Tinjauan Klien (Peer Review)

| No. | Umpan Balik Rekan / Klien | Keputusan | Alasan Tindak Lanjut |
| :---: | :--- | :---: | :--- |
| 1 | "Perlu dipisahkan antara tabel buku induk dengan eksemplar fisik agar status ketersediaan salinan terpantau akurat." | **Diterima** | Memisahkan entitas `buku` dan `eksemplar` untuk pengelolaan stok fisik yang lebih fleksibel. |
| 2 | "Tambahkan entitas denda yang terhubung langsung dengan peminjaman untuk mencatat sanksi keterlambatan secara transparan." | **Diterima** | Membuat entitas `denda` agar pencatatan keuangan denda perpustakaan terstruktur dengan baik. |

---

## 7. Pembahasan dan Kendala

Perancangan ERD memberikan kerangka kerja yang jelas sebelum implementasi basis data relasional. Pemisahan entitas majemuk dan penggunaan tabel asosiatif terbukti efektif menjaga konsistensi data transaksi.

- **Kendala:** Menentukan tingkat kardinalitas yang tepat pada relasi kompleks seperti sirkulasi peminjaman dan denda agar tidak terjadi anomali data.
- **Solusi:** Melakukan diskusi kelompok, meninjau kembali modul praktikum, serta memvalidasi aturan bisnis secara mendetail.

---

## 8. Kesimpulan

Praktikum Pertemuan 3 berhasil membuktikan bahwa pemodelan ERD yang matang adalah fondasi utama dalam membangun sistem basis data yang andal. Melalui studi kasus Perpustakaan M MEDIA, seluruh proses bisnis—mulai dari manajemen anggota, pengelolaan eksemplar buku, transaksi peminjaman, hingga pencatatan denda—telah terakomodasi secara optimal ke dalam struktur relasional yang terstandarisasi.

---

## 9. Pernyataan Penggunaan AI

Dalam penyusunan laporan ini, bantuan kecerdasan buatan digunakan sebagai pendukung penataan struktur kalimat, perapian format tabel, serta penguatan pemahaman konsep basis data. Seluruh hasil diagram, analisis kardinalitas, dan verifikasi akhir dikerjakan secara mandiri sesuai dengan ketentuan praktikum.

---

## 10. Bukti Git Commit
- `fdce673` — commit: p03: erd proyek perpustakaan
- `a9a6b25` — commit: p03: erd kopma