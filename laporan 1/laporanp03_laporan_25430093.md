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

### 2.1 Kunci dan Integritas Relasional
**Primary Key (PK)** mengidentifikasi setiap baris secara unik, sedangkan **Foreign Key (FK)** menghubungkan baris pada tabel anak dengan baris yang valid pada tabel induk. Atribut `UNIQUE` mencegah nilai tertentu tercatat lebih dari satu kali, misalnya kode buku atau nomor anggota. Kombinasi kunci juga dapat digunakan pada tabel asosiatif apabila satu baris mewakili hubungan antara dua objek.

Kardinalitas harus dibaca bersama aturan minimum dan maksimum. Hubungan `1 : 0..N`, misalnya, berarti setiap transaksi pada sisi anak memiliki satu induk, sementara satu induk boleh belum memiliki atau dapat memiliki banyak transaksi anak. Diagram membantu menemukan struktur hubungan, tetapi aturan operasional seperti larangan meminjam satu eksemplar yang masih dipinjam tetap memerlukan validasi tambahan.

### 2.2 Tahapan Pemodelan
Pemodelan dimulai dengan mengidentifikasi objek dan proses bisnis, kemudian merumuskan entitas serta hubungan antardata. Setelah itu, atribut kunci, kardinalitas, dan batasan bisnis ditentukan. Model konseptual menjelaskan kebutuhan tanpa bergantung pada produk basis data; model logis menerjemahkannya menjadi tabel dan kunci; sedangkan model fisik menetapkan tipe data, indeks, dan detail implementasi. Pemisahan tahapan ini mengurangi risiko merancang tabel terlalu dini sebelum kebutuhan sistem dipahami.

---

## 3. Hasil Langkah Percobaan

### 3.1 Perancangan ERD Koperasi Mahasiswa (Kopma)
Latihan awal dilakukan dengan merancang basis data Koperasi Mahasiswa untuk memahami hubungan data anggota, petugas, pemasok, penjualan, dan pembelian. Modifikasi berupa entitas `riwayat_poin` juga ditampilkan untuk menunjukkan bahwa perubahan saldo dapat disimpan sebagai peristiwa historis, bukan hanya sebagai angka total pada data anggota.

![Gambar 3.1: ERD Kopma dengan penambahan entitas riwayat poin](img/Diagram%20ERD%20Riwayat%20Poin%20Dark%20Mode.png)

### 3.2 Peralihan dari ERD Latihan ke Proyek Mandiri
Diagram latihan Kopma dan diagram proyek perpustakaan menggambarkan konteks bisnis yang berbeda. Pada proyek mandiri, objek transaksi penjualan digantikan oleh sirkulasi peminjaman, sedangkan barang dagangan dipisahkan menjadi judul buku (`buku`) dan salinan yang benar-benar dapat dipinjam (`eksemplar`). Pembedaan ini penting karena satu judul dapat memiliki banyak salinan dan setiap salinan dapat mempunyai status sirkulasi yang berbeda.

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

### 5.3 Dampak Perubahan Saldo Poin
Saldo poin merupakan nilai yang dapat berubah karena beberapa transaksi. Menyimpan hanya saldo terakhir pada tabel `anggota` akan menyulitkan penelusuran kapan poin diperoleh atau digunakan. Dengan `riwayat_poin`, setiap perubahan dapat dicatat sebagai baris tersendiri dengan jenis perubahan, jumlah poin, waktu kejadian, dan transaksi yang terkait. Saldo kemudian dapat dihitung dari riwayat tersebut atau disimpan sebagai nilai ringkasan yang diperbarui secara konsisten.

### 5.4 Peran Kunci Gabungan pada Detail Transaksi
Tabel detail berfungsi menguraikan satu transaksi menjadi objek-objek yang terlibat. Pada contoh Kopma, identitas transaksi dan barang menjadi bagian penting dalam membedakan satu baris detail dari baris lainnya. Pada proyek perpustakaan, kombinasi `kode_eksemplar` dan `no_peminjaman` pada `detail_peminjaman` mengidentifikasi eksemplar yang dipinjam pada transaksi tertentu. Keputusan kunci seperti ini perlu disesuaikan jika sistem nantinya mengizinkan satu eksemplar muncul beberapa kali dalam satu transaksi; aturan tersebut harus diperjelas sebelum DDL dibuat.

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

Diagram proyek mandiri di bawah memperlihatkan atribut, penandaan kunci, dan hubungan antardelapan entitas tersebut.

![Gambar 6.1: ERD Sistem Perpustakaan M MEDIA](img/ERD%20Sistem%20Perpustakaan%20Modern.png)

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

Pada relasi `peminjaman`–`pengembalian`, sisi `0..1` menunjukkan bahwa catatan pengembalian belum ada selama buku masih dipinjam, lalu paling banyak satu catatan dibuat setelah transaksi selesai. Penanda `UNIQUE` pada `no_peminjaman` di tabel `pengembalian` mendukung batas maksimum satu pengembalian untuk satu transaksi. Sementara itu, relasi `peminjaman`–`denda` bersifat opsional: transaksi yang tidak terlambat dapat tidak memiliki catatan denda.

### 6.4 Atribut Kunci dan Tanggung Jawab Entitas

| Entitas | Kunci/atribut penting pada diagram | Tanggung jawab data |
| :--- | :--- | :--- |
| `anggota` | PK `id_anggota`; `no_anggota` dan `nim_anggota` unik | Menyimpan identitas, kontak, tanggal daftar, dan status keanggotaan. |
| `petugas` | PK `id_petugas`; `kode_petugas` unik | Menyimpan identitas petugas dan perannya dalam layanan. |
| `buku` | PK `id_buku`; `kode_buku` unik | Menyimpan data bibliografis tingkat judul, seperti ISBN, judul, penulis, penerbit, tahun terbit, dan kategori. |
| `eksemplar` | PK `kode_eksemplar`; FK `id_buku` | Mengidentifikasi setiap salinan fisik dan status ketersediaannya. |
| `peminjaman` | PK `no_peminjaman`; FK `id_anggota` dan `id_petugas` | Mencatat anggota yang meminjam, petugas yang melayani, tanggal transaksi, dan batas pengembalian. |
| `detail_peminjaman` | PK gabungan `kode_eksemplar` dan `no_peminjaman`; keduanya juga FK | Menghubungkan setiap eksemplar dengan transaksi peminjaman. |
| `pengembalian` | PK `no_pengembalian`; FK `no_peminjaman` yang unik | Mencatat penyelesaian transaksi dan waktu pengembalian. |
| `denda` | PK `no_denda`; FK `no_peminjaman` | Mencatat jumlah hari keterlambatan dan nominal denda. |

Pemecahan `buku` dan `eksemplar` mencegah atribut tingkat salinan, seperti status tersedia atau sedang dipinjam, bercampur dengan atribut bibliografis yang sama untuk seluruh salinan. Contohnya, perubahan status satu salinan tidak perlu mengubah data judul buku yang menjadi induknya.

### 6.5 Siklus Data Peminjaman

1. Petugas memastikan anggota terdaftar dan status keanggotaannya memenuhi syarat peminjaman.
2. Petugas memilih satu atau beberapa eksemplar berstatus tersedia. Aplikasi perlu memeriksa status pada saat transaksi diproses, bukan hanya saat halaman pertama kali dibuka.
3. Sistem membuat satu baris `peminjaman` yang menghubungkan anggota dan petugas, lalu membuat satu atau lebih baris `detail_peminjaman` untuk eksemplar yang dipilih.
4. Status eksemplar diperbarui menjadi tidak tersedia selama masa peminjaman. Pembaruan ini harus berhasil bersama pencatatan transaksi agar tidak terjadi ketidaksesuaian antara riwayat pinjam dan ketersediaan koleksi.
5. Ketika buku dikembalikan, sistem mencatat `pengembalian`, memeriksa keterlambatan terhadap `batas_pengembalian`, dan membuat catatan `denda` bila aturan yang berlaku menyatakan denda harus dikenakan.
6. Setelah penyelesaian transaksi, eksemplar dapat ditandai tersedia kembali apabila tidak sedang dalam kondisi lain, misalnya rusak atau dalam perbaikan.

Urutan ini merupakan penjabaran rancangan proses dari relasi pada ERD, bukan klaim bahwa aplikasi atau transaksi basis data telah diimplementasikan dan diuji.

### 6.6 Penelusuran Kebutuhan Informasi ke Jalur ERD

| Kebutuhan Informasi (KI) | Jalur Relasi di ERD | Keterangan |
| :--- | :--- | :--- |
| Daftar anggota aktif | `anggota` | Memfilter data anggota berdasarkan status keaktifan. |
| Katalog koleksi buku | `buku` $\rightarrow$ `eksemplar` | Menampilkan judul buku dan ketersediaan fisik eksemplarnya. |
| Riwayat peminjaman anggota | `anggota` $\rightarrow$ `peminjaman` $\rightarrow$ `detail_peminjaman` $\rightarrow$ `eksemplar` $\rightarrow$ `buku` | Menelusuri buku apa saja yang pernah dipinjam oleh seorang anggota. |
| Rekapitulasi denda keterlambatan | `peminjaman` $\rightarrow$ `denda` | Menghitung akumulasi denda berdasarkan durasi keterlambatan pengembalian. |

### 6.7 Aturan Validasi dan Integritas Data

| Aturan | Pemeriksaan yang diperlukan | Dampak jika tidak diterapkan |
| :--- | :--- | :--- |
| Identitas anggota dan buku bersifat unik | Pastikan `no_anggota`, `nim_anggota`, dan `kode_buku` tidak diduplikasi. | Data anggota atau judul dapat tercatat ganda dan laporan menjadi keliru. |
| Setiap FK harus menunjuk induk yang valid | Validasi anggota, petugas, buku, eksemplar, dan transaksi sebelum menyimpan relasi. | Detail peminjaman atau denda dapat menjadi baris yatim. |
| Eksemplar tidak boleh dipinjam oleh dua transaksi aktif sekaligus | Periksa status salinan dan transaksi yang belum selesai secara atomik. | Satu salinan seolah-olah dipinjam oleh lebih dari satu anggota pada waktu bersamaan. |
| Batas pengembalian tidak lebih awal daripada tanggal peminjaman | Validasi urutan tanggal ketika transaksi dibuat. | Masa pinjam menjadi tidak masuk akal dan perhitungan keterlambatan rusak. |
| Tanggal pengembalian tidak lebih awal daripada tanggal peminjaman | Validasi waktu pada saat pengembalian dicatat. | Riwayat sirkulasi tidak kronologis. |
| Jumlah hari terlambat dan denda tidak negatif | Batasi hasil perhitungan minimal nol; simpan aturan tarif yang menjadi dasar perhitungan. | Denda dapat memiliki nominal negatif atau tidak dapat dijelaskan. |
| Pengembalian hanya dibuat sekali per transaksi | Pertahankan keunikan FK `no_peminjaman` di `pengembalian`. | Transaksi yang sama dapat ditutup berkali-kali. |

Aturan yang bergantung pada keadaan beberapa baris, seperti satu eksemplar tidak boleh memiliki dua peminjaman aktif, tidak cukup dijamin oleh pemeriksaan antarmuka saja. Implementasi perlu menggunakan transaksi basis data dan mekanisme penguncian atau validasi setara agar dua permintaan bersamaan tidak sama-sama melihat salinan sebagai tersedia.

### 6.8 Contoh Penelusuran Informasi

Untuk menyusun riwayat pinjaman seorang anggota, sistem memulai dari `anggota`, mencari transaksi terkait pada `peminjaman`, lalu mengambil rincian `detail_peminjaman`. Relasi dari rincian menuju `eksemplar` dan `buku` memberikan kode salinan dan informasi judul. Jika hasilnya juga menampilkan petugas yang melayani, jalurnya menggunakan FK `id_petugas` dari tabel `peminjaman` ke `petugas`.

Untuk laporan koleksi tersedia, data judul berasal dari `buku` dan jumlah salinan berasal dari `eksemplar`. Sistem perlu menghitung hanya eksemplar yang berstatus tersedia, sehingga laporan dapat membedakan jumlah judul dari jumlah salinan fisik. Untuk laporan denda, `peminjaman` dihubungkan dengan `denda`; apabila laporan dikelompokkan per anggota, jalur tambahan dari peminjaman menuju `anggota` dibutuhkan.

Contoh-contoh tersebut memperlihatkan bahwa kebutuhan laporan dapat ditelusuri melalui relasi, tetapi definisi status, rentang waktu, dan pengelompokan tetap perlu ditentukan supaya hasil yang sama dapat diperoleh secara konsisten.

### 6.9 Catatan Tinjauan Klien (*Peer Review*)

| No. | Umpan Balik Rekan / Klien | Keputusan | Alasan Tindak Lanjut |
| :---: | :--- | :---: | :--- |
| 1 | "Perlu dipisahkan antara tabel buku induk dengan eksemplar fisik agar status ketersediaan salinan terpantau akurat." | **Diterima** | Memisahkan entitas `buku` dan `eksemplar` untuk pengelolaan stok fisik yang lebih fleksibel. |
| 2 | "Tambahkan entitas denda yang terhubung langsung dengan peminjaman untuk mencatat sanksi keterlambatan secara transparan." | **Diterima** | Membuat entitas `denda` agar pencatatan keuangan denda perpustakaan terstruktur dengan baik. |

### 6.10 Evaluasi Normalisasi dan Batasan Rancangan

Pemisahan entitas membantu mengurangi pengulangan informasi. Data bibliografis disimpan satu kali pada `buku`, sedangkan tiap salinan mempunyai satu identitas sendiri pada `eksemplar`. Identitas anggota dan petugas juga dirujuk melalui FK dari transaksi, alih-alih menyalin semua atribut mereka pada setiap baris pinjam. Detail peminjaman menjadi tabel penghubung yang menyimpan keanggotaan eksemplar dalam transaksi.

Meski demikian, diagram saat ini belum menjelaskan beberapa keputusan implementasi. Contohnya adalah tipe dan panjang kolom, apakah satu transaksi wajib memuat minimal satu detail, cara menentukan tarif denda, apakah denda dapat dibayar sebagian, dan cara menandai eksemplar hilang atau rusak. Kebutuhan tersebut perlu dikonfirmasi sebelum membuat DDL, agar aturan yang masih terbuka tidak diasumsikan sepihak.

Relasi `denda` langsung ke `peminjaman` cocok apabila denda direkap per transaksi. Jika perpustakaan perlu mengetahui denda untuk setiap eksemplar yang terlambat, rancangan dapat dikembangkan dengan menghubungkan denda ke detail peminjaman. Perubahan itu harus didasari kebutuhan operasional, karena menambah hubungan tanpa kebutuhan yang jelas dapat membuat model lebih rumit.

## 7. Pembahasan dan Kendala

Perancangan ERD memberikan kerangka kerja yang jelas sebelum implementasi basis data relasional. Pemisahan entitas majemuk dan penggunaan tabel asosiatif terbukti efektif menjaga konsistensi data transaksi.

- **Kendala:** Menentukan tingkat kardinalitas yang tepat pada relasi kompleks seperti sirkulasi peminjaman dan denda agar tidak terjadi anomali data.
- **Solusi:** Melakukan diskusi kelompok, meninjau kembali modul praktikum, serta memvalidasi aturan bisnis secara mendetail.

### 7.1 Pertimbangan Implementasi

Sebelum rancangan dipetakan ke DDL, beberapa keputusan berikut perlu dicatat dalam kamus data atau aturan bisnis:

1. **Strategi identitas:** Tentukan apakah PK menggunakan angka buatan sistem atau kode bisnis. Kode yang dapat berubah, seperti nomor kartu anggota, lebih aman diperlakukan sebagai atribut unik terpisah bila PK internal telah digunakan sebagai penghubung.
2. **Pengelolaan status:** Tetapkan daftar nilai yang sah bagi status anggota dan eksemplar. Penggunaan nilai yang terkendali menghindari variasi ejaan seperti `Tersedia`, `tersedia`, dan `ready`.
3. **Penyimpanan tanggal:** Gunakan tipe tanggal/waktu yang sesuai dan sepakati zona waktu bila pencatatan dilakukan dari beberapa perangkat.
4. **Penghapusan data:** Riwayat transaksi sebaiknya tidak hilang hanya karena data anggota atau buku tidak lagi aktif. Penonaktifan atau arsip biasanya lebih sesuai daripada penghapusan berantai pada data historis.
5. **Indeks:** FK dan kolom pencarian yang sering digunakan dapat dipertimbangkan untuk indeks setelah pola kueri dan volume data diketahui. Indeks perlu dievaluasi karena mempercepat pembacaan tertentu tetapi menambah biaya penyimpanan dan pembaruan.

Poin-poin tersebut merupakan rekomendasi desain lanjutan, bukan bukti bahwa konfigurasi fisik atau pengujian performa sudah dilakukan.

### 7.2 Skenario Kasus Batas

Pengujian rancangan sebaiknya mencakup situasi yang tidak hanya menggambarkan alur normal:

| Skenario | Perilaku yang diharapkan |
| :--- | :--- |
| Anggota belum pernah meminjam buku | Tetap dapat tampil pada laporan anggota aktif; relasi ke peminjaman bersifat opsional dari sisi anggota. |
| Satu judul memiliki beberapa salinan | Katalog menampilkan satu judul, sementara ketersediaan dihitung dari sejumlah eksemplar. |
| Semua eksemplar dari suatu judul sedang dipinjam | Judul tetap ada pada katalog, tetapi jumlah tersedia adalah nol. |
| Transaksi belum dikembalikan | Baris peminjaman dan detail tetap ada, sedangkan catatan pengembalian belum dibuat. |
| Pengembalian tepat pada batas waktu | Sistem menghitung keterlambatan nol hari menurut definisi batas waktu yang disepakati. |
| Dua petugas memproses salinan yang sama hampir bersamaan | Hanya satu transaksi aktif yang boleh berhasil; transaksi lain harus menerima status bahwa salinan sudah tidak tersedia. |
| Anggota atau judul dinonaktifkan setelah memiliki riwayat | Data historis tetap dapat dibaca dan ditelusuri tanpa kehilangan referensi. |

Skenario tersebut dapat dijadikan dasar kasus uji ketika rancangan dilanjutkan ke implementasi basis data dan aplikasi.

---

## 8. Kesimpulan

Praktikum Pertemuan 3 berhasil membuktikan bahwa pemodelan ERD yang matang adalah fondasi utama dalam membangun sistem basis data yang andal. Melalui studi kasus Perpustakaan M MEDIA, seluruh proses bisnis—mulai dari manajemen anggota, pengelolaan eksemplar buku, transaksi peminjaman, hingga pencatatan denda—telah terakomodasi secara optimal ke dalam struktur relasional yang terstandarisasi.

Hasil analisis juga menunjukkan pentingnya memisahkan data judul buku dari salinan fisiknya, menggunakan tabel detail untuk menguraikan transaksi, serta menjaga referensi melalui PK dan FK. Penelusuran kebutuhan informasi dapat dilakukan melalui rangkaian relasi yang jelas sehingga katalog, riwayat peminjaman, dan rekapitulasi denda mempunyai dasar data yang dapat dijelaskan.

Beberapa aturan, terutama pencegahan peminjaman ganda pada waktu bersamaan, memerlukan validasi transaksi pada tahap implementasi dan tidak selesai hanya dengan menggambar relasi. Penentuan tipe data, indeks, kebijakan pengarsipan, dan rincian perhitungan denda juga menjadi pekerjaan lanjutan sebelum model fisik diterapkan.

---

## 9. Pernyataan Penggunaan AI

Dalam penyusunan laporan ini, bantuan kecerdasan buatan digunakan sebagai pendukung penataan struktur kalimat, perapian format tabel, serta penguatan pemahaman konsep basis data. Seluruh hasil diagram, analisis kardinalitas, dan verifikasi akhir dikerjakan secara mandiri sesuai dengan ketentuan praktikum.

---

## 10. Bukti Git Commit
- `fdce673` — commit: p03: erd proyek perpustakaan
- `a9a6b25` — commit: p03: erd kopma