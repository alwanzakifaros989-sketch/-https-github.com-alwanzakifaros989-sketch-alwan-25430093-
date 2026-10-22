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
6. Menjelaskan alasan pemisahan data judul buku, eksemplar, transaksi peminjaman, dan rincian transaksi.
7. Menurunkan rancangan ERD menjadi kebutuhan validasi data dan skenario uji yang dapat dipakai pada tahap implementasi.
8. Mengidentifikasi keputusan desain yang belum dapat ditetapkan hanya dari diagram dan perlu dikonfirmasi sebelum penyusunan DDL.

---

## 2. Ringkasan Dasar Teori

Entity Relationship Diagram (ERD) adalah model konseptual yang memetakan struktur data dan hubungan antarobjek di dalam sebuah sistem basis data. Komponen utamanya terdiri atas **Entitas** (tabel/objek nyata), **Atribut** (karakteristik data), dan **Relasi** (hubungan antarentitas). 

Kardinalitas relasi menggambarkan batasan jumlah keterhubungan, seperti *One-to-One* (1:1), *One-to-Many* (1:N), hingga *Many-to-Many* (M:N). Relasi banyak-ke-banyak wajib diurai menggunakan entitas asosiatif (tabel perantara) agar integritas data transaksi tetap terjaga. Setiap garis relasi harus didefinisikan dengan kata kerja yang jelas agar mencerminkan proses bisnis yang otentik.

### 2.1 Kunci dan Integritas Relasional
**Primary Key (PK)** mengidentifikasi setiap baris secara unik, sedangkan **Foreign Key (FK)** menghubungkan baris pada tabel anak dengan baris yang valid pada tabel induk. Atribut `UNIQUE` mencegah nilai tertentu tercatat lebih dari satu kali, misalnya kode buku atau nomor anggota. Kombinasi kunci juga dapat digunakan pada tabel asosiatif apabila satu baris mewakili hubungan antara dua objek.

Kardinalitas harus dibaca bersama aturan minimum dan maksimum. Hubungan `1 : 0..N`, misalnya, berarti setiap transaksi pada sisi anak memiliki satu induk, sementara satu induk boleh belum memiliki atau dapat memiliki banyak transaksi anak. Diagram membantu menemukan struktur hubungan, tetapi aturan operasional seperti larangan meminjam satu eksemplar yang masih dipinjam tetap memerlukan validasi tambahan.

### 2.2 Tahapan Pemodelan
Pemodelan dimulai dengan mengidentifikasi objek dan proses bisnis, kemudian merumuskan entitas serta hubungan antardata. Setelah itu, atribut kunci, kardinalitas, dan batasan bisnis ditentukan. Model konseptual menjelaskan kebutuhan tanpa bergantung pada produk basis data; model logis menerjemahkannya menjadi tabel dan kunci; sedangkan model fisik menetapkan tipe data, indeks, dan detail implementasi. Pemisahan tahapan ini mengurangi risiko merancang tabel terlalu dini sebelum kebutuhan sistem dipahami.

### 2.3 Entitas, Atribut, dan Aturan Bisnis
Entitas mewakili objek yang informasinya perlu disimpan secara berulang dan dikelola sepanjang waktu, bukan sekadar kata benda yang muncul dalam deskripsi sistem. Sebuah objek layak dipertimbangkan sebagai entitas ketika memiliki identitas, atribut yang perlu dipelihara, atau hubungan yang perlu ditelusuri. Atribut menjelaskan karakteristik entitas, sedangkan aturan bisnis menjelaskan batasan tentang nilai atau hubungan yang diperbolehkan.

Contohnya, “buku tersedia” bukan hanya atribut judul, sebab satu judul dapat memiliki beberapa salinan dengan kondisi berbeda. Ketersediaan lebih tepat dinilai pada tingkat eksemplar. Sebaliknya, judul dan penerbit merupakan informasi bibliografis yang umumnya sama bagi seluruh eksemplar dari judul yang sama. Pembedaan tingkat informasi tersebut membantu menghindari pengulangan dan perubahan data yang tidak konsisten.

Aturan bisnis harus dapat diterjemahkan menjadi mekanisme yang dapat diperiksa. Keunikan kode dapat dibantu oleh batasan `UNIQUE`, keharusan nilai dengan `NOT NULL`, dan hubungan antarentitas dengan FK. Aturan yang bergantung pada status beberapa baris atau urutan transaksi mungkin memerlukan validasi aplikasi dan transaksi basis data, bukan hanya satu batasan kolom.

### 2.4 Normalisasi dan Reduksi Anomali
Normalisasi adalah proses menata atribut ke dalam relasi yang sesuai agar data tidak tersimpan berulang tanpa alasan. Dalam konteks perpustakaan, jika nama anggota disalin ke setiap baris detail peminjaman, perubahan nama harus diperbarui di banyak tempat. Jika satu baris terlewat, laporan dapat menampilkan identitas yang berbeda untuk anggota yang sama. Dengan menyimpan identitas anggota pada tabel `anggota` dan menghubungkan peminjaman melalui FK, perubahan dapat dikelola pada satu sumber.

Pemisahan data juga mencegah anomali penyisipan, perubahan, dan penghapusan. Informasi judul buku tetap dapat dicatat meskipun belum ada eksemplar yang siap dipinjam; satu eksemplar dapat diperbarui statusnya tanpa mengubah judul; dan penonaktifan satu salinan tidak harus menghapus seluruh data bibliografis. Normalisasi bukan tujuan untuk memecah tabel sebanyak mungkin, melainkan cara menjaga makna serta konsistensi data.

### 2.5 Konsistensi Transaksi dan Konkurensi
Operasi peminjaman terdiri atas beberapa perubahan yang perlu diperlakukan sebagai satu kesatuan: membuat transaksi, memasukkan rincian eksemplar, dan mengubah status salinan. Jika hanya sebagian langkah berhasil, sistem dapat menampilkan riwayat peminjaman yang tidak sesuai dengan ketersediaan koleksi. Transaksi basis data menyediakan prinsip *atomicity*: seluruh perubahan berhasil sebagai satu kelompok atau dibatalkan seluruhnya.

Konkurensi terjadi saat beberapa pengguna melakukan operasi bersamaan. Dua petugas dapat memilih eksemplar yang sama sebelum salah satu transaksi tersimpan. Karena itu, pemeriksaan status perlu disertai strategi penguncian atau pembaruan bersyarat ketika transaksi diproses. Pemeriksaan pada halaman antarmuka saja tidak cukup untuk menjamin bahwa eksemplar belum dipinjam oleh pengguna lain.

### 2.6 Kualitas Data dan Siklus Hidup Informasi
Kualitas data mencakup ketepatan, kelengkapan, konsistensi, keunikan, dan kemutakhiran. Kode eksemplar yang duplikat mengganggu identifikasi fisik; nomor anggota yang kosong menyulitkan verifikasi; status yang ditulis dengan banyak variasi menyulitkan perhitungan koleksi. Pengendalian dapat dilakukan melalui format baku, daftar nilai yang diperbolehkan, pemeriksaan FK, dan prosedur koreksi yang tercatat.

Data transaksi juga mempunyai siklus hidup yang berbeda dari data master. Data buku atau anggota dapat menjadi tidak aktif, tetapi riwayat pinjam perlu dipertahankan untuk kebutuhan audit dan layanan. Maka, rancangan sebaiknya mempertimbangkan status aktif atau tanggal nonaktif alih-alih menghapus objek induk yang masih dirujuk transaksi. Kebijakan retensi, perlindungan data pribadi, pencadangan, dan pemulihan merupakan bagian dari tata kelola yang perlu didefinisikan sebelum sistem digunakan secara nyata.

---

## 3. Hasil Langkah Percobaan

### 3.1 Perancangan ERD Koperasi Mahasiswa (Kopma)
Latihan awal dilakukan dengan merancang basis data Koperasi Mahasiswa untuk memahami hubungan data anggota, petugas, pemasok, penjualan, dan pembelian. Modifikasi berupa entitas `riwayat_poin` juga ditampilkan untuk menunjukkan bahwa perubahan saldo dapat disimpan sebagai peristiwa historis, bukan hanya sebagai angka total pada data anggota.

![Gambar 3.1: ERD Kopma dengan penambahan entitas riwayat poin](img/Diagram%20ERD%20Riwayat%20Poin%20Dark%20Mode.png)

### 3.2 Peralihan dari ERD Latihan ke Proyek Mandiri
Diagram latihan Kopma dan diagram proyek perpustakaan menggambarkan konteks bisnis yang berbeda. Pada proyek mandiri, objek transaksi penjualan digantikan oleh sirkulasi peminjaman, sedangkan barang dagangan dipisahkan menjadi judul buku (`buku`) dan salinan yang benar-benar dapat dipinjam (`eksemplar`). Pembedaan ini penting karena satu judul dapat memiliki banyak salinan dan setiap salinan dapat mempunyai status sirkulasi yang berbeda.

### 3.3 Cara Membaca ERD Proyek
ERD proyek dibaca dengan terlebih dahulu mengenali kotak sebagai entitas dan baris di dalamnya sebagai atribut. Penanda PK menunjukkan atribut pengenal, sedangkan FK menunjukkan atribut yang merujuk entitas lain. Garis relasi menggambarkan keterhubungan; angka `1` dan `N` menunjukkan batas jumlah pasangan, sementara `0..1` menyatakan relasi opsional dengan maksimum satu pasangan.

Langkah membaca tersebut membantu membedakan identitas transaksi dari rincian transaksi. Satu `peminjaman` menyimpan informasi umum seperti anggota, petugas, tanggal pinjam, dan batas pengembalian. Sementara itu, `detail_peminjaman` menyatakan eksemplar mana saja yang menjadi bagian dari transaksi. Jika suatu peminjaman berisi beberapa salinan, informasi anggota tidak perlu diulang pada setiap rincian karena dapat diperoleh melalui relasi menuju tabel induk.

### 3.4 Batas Bukti Percobaan dan Analisis
Bagian percobaan ini mendokumentasikan pemahaman terhadap diagram latihan dan rancangan proyek. Uraian alur, aturan validasi, serta kasus batas pada bagian selanjutnya adalah analisis desain yang diturunkan dari ERD. Hal tersebut tidak menyatakan bahwa semua aturan telah diwujudkan pada aplikasi atau telah diuji menggunakan server basis data. Pembedaan antara bukti visual, keputusan desain, dan rekomendasi implementasi penting agar laporan tidak mengklaim hasil yang belum dikerjakan.

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

### 5.5 Perbandingan Pola Data pada Diagram Latihan
Diagram Kopma menunjukkan beberapa pola umum basis data operasional. Entitas `anggota`, `petugas`, dan `pemasok` menyimpan data master; `penjualan` serta `pembelian` menyimpan kejadian transaksi; sedangkan entitas detail menghubungkan transaksi dengan barang atau itemnya. Pola tersebut dapat dipakai ulang sebagai cara berpikir, tetapi nama entitas dan aturan tiap relasi tetap harus menyesuaikan proses bisnis perpustakaan.

| Pola pada diagram Kopma | Peran dalam proses Kopma | Padanan konsep pada proyek perpustakaan |
| :--- | :--- | :--- |
| `anggota` | Identitas pelanggan atau anggota koperasi | `anggota` sebagai peminjam buku |
| `petugas` | Petugas yang melayani transaksi | `petugas` yang mencatat peminjaman |
| `penjualan` | Transaksi penjualan pada waktu tertentu | `peminjaman` sebagai transaksi sirkulasi |
| `detail_penjualan` | Barang dan jumlah yang dijual dalam nota | `detail_peminjaman` yang mencatat eksemplar per transaksi |
| `barang` | Data produk yang diperdagangkan | `buku` dan `eksemplar` untuk judul serta salinannya |
| `riwayat_poin` | Catatan perubahan poin anggota | Catatan `pengembalian` dan `denda` untuk peristiwa sirkulasi |

Padanan pada tabel di atas bersifat analogi untuk menjelaskan pola, bukan hubungan satu-banding-satu dari sisi definisi atau atribut. Sebagai contoh, poin loyalitas dan denda mempunyai tujuan bisnis berbeda walaupun sama-sama dapat dicatat sebagai kejadian yang berkaitan dengan transaksi. Memindahkan struktur tanpa mengevaluasi aturan bisnis dapat menghasilkan model yang tampak familiar tetapi tidak tepat.

### 5.6 Manfaat Pemisahan Master dan Transaksi
Data master cenderung dipakai oleh banyak transaksi, sedangkan data transaksi merekam kejadian pada waktu tertentu. Kode anggota dipakai pada banyak peminjaman; kode judul buku dapat memiliki banyak eksemplar; dan satu petugas dapat melayani banyak transaksi. Jika semua informasi master disimpan ulang pada setiap transaksi, ukuran data membesar dan ketidaksamaan nilai akan lebih mudah terjadi.

Namun, ada informasi transaksi yang memang perlu menyimpan kondisi pada saat kejadian. Pada sistem penjualan, harga historis perlu dicatat di detail agar perubahan harga produk tidak mengubah nilai nota lama. Pada sistem perpustakaan, atribut yang perlu disimpan sebagai rekam historis harus dipilih berdasarkan kebutuhan: misalnya, apabila aturan durasi pinjam dapat berubah, sistem dapat memerlukan pencatatan tanggal jatuh tempo pada transaksi, bukan menghitung ulang seluruh transaksi lama menggunakan kebijakan terbaru. Diagram yang tersedia telah menampilkan `batas_pengembalian` pada `peminjaman`, sehingga tanggal batas tersebut dapat dilacak per transaksi.

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

Pembacaan kardinalitas juga perlu memperhatikan sisi mana yang diwajibkan. Satu baris peminjaman merujuk kepada tepat satu anggota dan satu petugas karena kedua FK berada di tabel `peminjaman`. Sebaliknya, anggota yang baru mendaftar belum tentu pernah meminjam, dan petugas baru belum tentu telah melayani transaksi. Dengan demikian, hubungan dari entitas induk ke transaksi dapat dimulai dari nol.

Pada relasi judul buku dengan eksemplar, satu eksemplar mengacu kepada satu judul, sedangkan satu judul dapat memiliki banyak eksemplar. Jika koleksi sedang dalam tahap katalogisasi, sistem mungkin juga memiliki judul tanpa salinan yang siap dipinjam. Keadaan tersebut perlu diterjemahkan dengan benar ke kardinalitas minimum dan aturan status, bukan ditafsirkan hanya dari gambar garis.

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

### 6.4.1 Kamus Data Ringkas Proyek

Tabel berikut merangkum elemen yang terlihat pada diagram serta fungsi logisnya. Panjang kolom dan tipe fisik belum ditetapkan karena diagram konseptual/logis yang tersedia tidak memuat spesifikasi tipe data lengkap.

| Entitas | Elemen data | Keterangan dan aturan awal |
| :--- | :--- | :--- |
| `anggota` | `id_anggota` | Identitas internal anggota; PK dan tidak boleh duplikat. |
| `anggota` | `no_anggota` | Nomor kartu/keanggotaan; unik menurut diagram. |
| `anggota` | `nim_anggota` | Nomor induk anggota mahasiswa; unik sesuai diagram dan kebutuhan organisasi. |
| `anggota` | `nama_anggota` | Nama anggota; wajib untuk kebutuhan layanan, batas panjang perlu ditetapkan. |
| `anggota` | `alamat_anggota` | Alamat anggota; akses dan masa penyimpanan perlu mengikuti kebijakan privasi. |
| `anggota` | `no_hp_anggota` | Nomor kontak; format perlu dibakukan dan akses dibatasi sesuai peran. |
| `anggota` | `email_anggota` | Alamat surel; validasi format dan keunikan perlu diputuskan. |
| `anggota` | `tanggal_daftar` | Tanggal keanggotaan mulai tercatat. |
| `anggota` | `status_anggota` | Status keanggotaan dari daftar nilai yang ditentukan organisasi. |
| `petugas` | `id_petugas` | Identitas internal petugas; PK. |
| `petugas` | `kode_petugas` | Kode petugas; unik untuk pencarian dan identifikasi operasional. |
| `petugas` | `nama_petugas` | Nama petugas yang dapat ditampilkan pada layanan dan laporan. |
| `petugas` | `peran_petugas` | Peran kerja; daftar nilai perlu diselaraskan dengan otorisasi aplikasi. |
| `buku` | `id_buku` | Identitas internal judul buku; PK. |
| `buku` | `kode_buku` | Kode katalog; unik menurut diagram. |
| `buku` | `isbn_buku` | Nomor ISBN apabila tersedia; format dan keunikan perlu memperhatikan edisi. |
| `buku` | `judul_buku` | Judul bibliografis yang dipakai untuk katalog dan pencarian. |
| `buku` | `penulis_buku` | Informasi penulis; pemisahan menjadi entitas penulis dapat dipertimbangkan bila banyak penulis perlu dikelola terstruktur. |
| `buku` | `penerbit_buku` | Informasi penerbit yang terkait dengan edisi katalog. |
| `buku` | `tahun_terbit` | Tahun terbit; rentang nilai sah perlu ditentukan. |
| `buku` | `kategori_buku` | Klasifikasi buku; nilai sebaiknya konsisten atau dinormalisasi bila perlu. |
| `eksemplar` | `kode_eksemplar` | Identitas unik satu salinan fisik; PK dan label inventaris. |
| `eksemplar` | `id_buku` | FK yang menunjukkan judul induk eksemplar. |
| `eksemplar` | `status_eksemplar` | Status salinan, misalnya tersedia, dipinjam, rusak, atau hilang setelah daftar nilai disepakati. |
| `peminjaman` | `no_peminjaman` | Nomor transaksi; PK dan referensi transaksi layanan. |
| `peminjaman` | `id_petugas` | FK kepada petugas yang mencatat transaksi. |
| `peminjaman` | `id_anggota` | FK kepada anggota yang meminjam. |
| `peminjaman` | `tanggal_peminjaman` | Tanggal/waktu saat transaksi dicatat. |
| `peminjaman` | `batas_pengembalian` | Batas waktu yang berlaku untuk transaksi tersebut. |
| `detail_peminjaman` | `kode_eksemplar` | FK kepada salinan fisik yang termasuk dalam transaksi. |
| `detail_peminjaman` | `no_peminjaman` | FK kepada transaksi induk; bersama `kode_eksemplar` membentuk PK gabungan. |
| `pengembalian` | `no_pengembalian` | Identitas catatan penyelesaian pengembalian; PK. |
| `pengembalian` | `no_peminjaman` | FK unik menuju transaksi yang diselesaikan. |
| `pengembalian` | `tanggal_pengembalian` | Tanggal/waktu penyelesaian; harus berada pada atau setelah tanggal peminjaman. |
| `denda` | `no_denda` | Identitas catatan denda; PK. |
| `denda` | `no_peminjaman` | FK ke transaksi yang menjadi dasar denda. |
| `denda` | `hari_terlambat` | Jumlah hari keterlambatan yang dihitung menurut kebijakan. |
| `denda` | `jumlah_denda` | Nominal denda; aturan tarif, pembulatan, dan pembayaran belum ditentukan pada diagram. |

Kamus ringkas ini membedakan fakta yang tampak pada diagram dari aturan yang masih berupa usulan. Misalnya, atribut `status_eksemplar` tersedia pada diagram, tetapi daftar nilai dan prosedur perubahannya perlu disepakati. Demikian juga, adanya atribut nominal denda belum menjelaskan tarif per hari, batas maksimum, penghapusan denda, atau status pembayaran.

### 6.5 Siklus Data Peminjaman

1. Petugas memastikan anggota terdaftar dan status keanggotaannya memenuhi syarat peminjaman.
2. Petugas memilih satu atau beberapa eksemplar berstatus tersedia. Aplikasi perlu memeriksa status pada saat transaksi diproses, bukan hanya saat halaman pertama kali dibuka.
3. Sistem membuat satu baris `peminjaman` yang menghubungkan anggota dan petugas, lalu membuat satu atau lebih baris `detail_peminjaman` untuk eksemplar yang dipilih.
4. Status eksemplar diperbarui menjadi tidak tersedia selama masa peminjaman. Pembaruan ini harus berhasil bersama pencatatan transaksi agar tidak terjadi ketidaksesuaian antara riwayat pinjam dan ketersediaan koleksi.
5. Ketika buku dikembalikan, sistem mencatat `pengembalian`, memeriksa keterlambatan terhadap `batas_pengembalian`, dan membuat catatan `denda` bila aturan yang berlaku menyatakan denda harus dikenakan.
6. Setelah penyelesaian transaksi, eksemplar dapat ditandai tersedia kembali apabila tidak sedang dalam kondisi lain, misalnya rusak atau dalam perbaikan.

Urutan ini merupakan penjabaran rancangan proses dari relasi pada ERD, bukan klaim bahwa aplikasi atau transaksi basis data telah diimplementasikan dan diuji.

### 6.5.1 Tahapan dan Hasil Proses Bisnis

| Kode | Proses | Data yang dibaca | Data yang dibuat/diubah | Hasil yang diharapkan |
| :--- | :--- | :--- | :--- | :--- |
| PB-01 | Mendaftarkan anggota | Data identitas yang diserahkan dan aturan keanggotaan | Baris baru pada `anggota` | Anggota memiliki identitas unik dan status awal yang sah. |
| PB-02 | Mengelola katalog judul | Data bibliografis dan katalog yang sudah ada | Baris pada `buku` atau pembaruan atribut katalog | Judul dapat ditemukan tanpa menduplikasi kode katalog. |
| PB-03 | Mencatat eksemplar | Judul induk dan nomor inventaris salinan | Baris pada `eksemplar` | Setiap salinan memiliki kode unik dan status awal. |
| PB-04 | Mencatat peminjaman | Status anggota, status eksemplar, dan aturan pinjam | Baris `peminjaman`, detail terkait, dan perubahan status | Transaksi dan salinan yang dipinjam saling konsisten. |
| PB-05 | Mencatat pengembalian | Transaksi aktif, tanggal pinjam, dan batas pengembalian | Baris `pengembalian`, perubahan status eksemplar, dan bila perlu `denda` | Pengembalian tercatat paling banyak sekali dan status salinan diperbarui. |
| PB-06 | Meninjau laporan sirkulasi | Data anggota, judul, eksemplar, transaksi, dan denda | Tidak ada perubahan data operasional | Petugas dapat meninjau koleksi, aktivitas, dan keterlambatan. |

Pemetaan ini menguraikan aktor dan data yang terlibat sebagai bahan perancangan lanjutan. Rincian hak akses, formulir, waktu layanan, dan otorisasi final tetap perlu disepakati dengan pengelola perpustakaan.

### 6.6 Penelusuran Kebutuhan Informasi ke Jalur ERD

| Kebutuhan Informasi (KI) | Jalur Relasi di ERD | Keterangan |
| :--- | :--- | :--- |
| Daftar anggota aktif | `anggota` | Memfilter data anggota berdasarkan status keaktifan. |
| Katalog koleksi buku | `buku` $\rightarrow$ `eksemplar` | Menampilkan judul buku dan ketersediaan fisik eksemplarnya. |
| Riwayat peminjaman anggota | `anggota` $\rightarrow$ `peminjaman` $\rightarrow$ `detail_peminjaman` $\rightarrow$ `eksemplar` $\rightarrow$ `buku` | Menelusuri buku apa saja yang pernah dipinjam oleh seorang anggota. |
| Rekapitulasi denda keterlambatan | `peminjaman` $\rightarrow$ `denda` | Menghitung akumulasi denda berdasarkan durasi keterlambatan pengembalian. |

Kebutuhan informasi di atas tidak langsung menetapkan rancangan tampilan. Sebelum laporan dipakai, pihak perpustakaan perlu menentukan periodenya, urutan penyajian, aturan penyertaan anggota nonaktif, dan apakah data pribadi boleh ditampilkan. Misalnya, laporan aktivitas sirkulasi harian berbeda dari daftar seluruh riwayat yang tidak dibatasi waktu.

### 6.6.1 Penelusuran Kebutuhan Fungsional

| Kebutuhan | Entitas utama | Pemeriksaan desain |
| :--- | :--- | :--- |
| Mencari judul berdasarkan kode atau nama | `buku` | Kode katalog unik; strategi pencarian nama perlu mempertimbangkan variasi ejaan. |
| Melihat jumlah salinan yang dapat dipinjam | `buku`, `eksemplar` | Hitung hanya salinan dengan status tersedia dan jangan menghitung judul sebagai salinan. |
| Menampilkan transaksi anggota | `anggota`, `peminjaman` | Gunakan identitas internal anggota dan sediakan batas periode bila data sangat banyak. |
| Menampilkan judul pada tiap transaksi | `detail_peminjaman`, `eksemplar`, `buku` | Telusuri hubungan detail sampai ke judul induk. |
| Mencatat pengembalian | `pengembalian`, `peminjaman`, `detail_peminjaman`, `eksemplar` | Pastikan transaksi belum diselesaikan dan status semua eksemplar diperbarui secara konsisten. |
| Merekap nominal denda | `denda`, `peminjaman` | Definisikan periode, pembatalan, pembayaran, dan perlakuan transaksi tanpa denda. |

Tabel tersebut membantu memeriksa bahwa setiap kebutuhan mempunyai jalur data dan aturan validasi yang dapat dibahas. Apabila hasil yang dibutuhkan tidak dapat ditelusuri melalui entitas dan relasi, model perlu diperiksa kembali sebelum dibuat menjadi tabel fisik.

### 6.6.2 Kebutuhan Nonfungsional yang Perlu Ditetapkan

Kebutuhan nonfungsional merupakan karakteristik mutu sistem, bukan fungsi bisnis tunggal. Untuk proyek perpustakaan, sasaran berikut dapat dibahas pada tahap berikutnya:

1. **Keamanan dan privasi:** Batasi akses ke alamat, nomor telepon, dan informasi transaksi berdasarkan kebutuhan peran. Tindakan administratif penting sebaiknya dapat ditelusuri.
2. **Konsistensi:** Pencatatan peminjaman dan perubahan status salinan harus selaras meskipun terjadi kegagalan proses.
3. **Ketersediaan:** Tentukan jadwal layanan, jangka waktu pemulihan setelah gangguan, dan prosedur pencatatan sementara bila sistem tidak dapat digunakan.
4. **Kinerja:** Tetapkan target waktu respons pencarian katalog dan laporan berdasarkan volume koleksi serta jumlah pengguna yang diharapkan; nilai target belum ditentukan pada rancangan ini.
5. **Pemulihan:** Tentukan frekuensi pencadangan, tempat penyimpanan cadangan, masa retensi, dan jadwal uji pemulihan.
6. **Kemudahan penggunaan:** Formulir harus memberi pesan validasi yang jelas dan membedakan penolakan aturan bisnis dari gangguan teknis.
7. **Audit:** Perlu diputuskan jenis perubahan yang perlu mencatat siapa melakukan perubahan dan kapan perubahan terjadi.

Daftar ini adalah pokok kebutuhan untuk dikonfirmasi, bukan pernyataan bahwa target kinerja, prosedur keamanan, atau pencadangan telah diuji.

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

### 6.11 Matriks CRUD Proyek Perpustakaan

Matriks CRUD berikut meninjau keterlibatan proses utama pada entitas. `C` berarti membuat data, `R` membaca, `U` memperbarui, dan `D` menghapus atau menonaktifkan sesuai kebijakan. Tanda `—` berarti bukan operasi utama proses tersebut. Matriks ini merupakan analisis rancangan dan masih perlu dikonfirmasi dengan alur kerja pengelola.

| Proses | Anggota | Petugas | Buku | Eksemplar | Peminjaman | Detail pinjam | Pengembalian | Denda |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| Pendaftaran anggota | C | R | — | — | — | — | — | — |
| Pengelolaan katalog | — | R | C, R, U | C, R, U | — | — | — | — |
| Pencatatan peminjaman | R | R | R | R, U | C | C | — | — |
| Pencatatan pengembalian | R | R | R | R, U | R | R | C | C (jika terlambat) |
| Peninjauan laporan | R | R | R | R | R | R | R | R |
| Pengarsipan data master | U | U | U | U | — | — | — | — |

Kolom penghapusan tidak dicantumkan sebagai operasi rutin karena data transaksi merupakan riwayat. Jika terjadi kesalahan input, koreksi sebaiknya mengikuti prosedur yang tercatat dan tidak menghilangkan jejak kejadian yang telah berlangsung. Kebutuhan pembatalan transaksi juga belum dimodelkan secara eksplisit; perpustakaan perlu menentukan apakah pembatalan direpresentasikan dengan status dan alasan atau mekanisme lain.

Matriks CRUD dapat dipakai untuk menemukan celah. Entitas yang hanya dibaca tetapi tidak memiliki proses pembuatan mungkin berasal dari data awal yang dimuat melalui migrasi atau dari proses bisnis yang belum dipetakan. Operasi pembaruan status eksemplar juga harus dikaitkan dengan peminjaman, pengembalian, atau pengelolaan kondisi fisik agar perubahan tidak dilakukan tanpa alasan.

### 6.12 Kebijakan dan Contoh Aturan Operasional

Aturan berikut menunjukkan bagaimana kebutuhan dapat ditulis lebih konkret. Nilai parameter belum diberikan oleh modul atau diagram, sehingga batas jumlah pinjaman dan tarif denda tidak ditetapkan secara fiktif.

| Kode | Aturan yang disarankan untuk dikonfirmasi | Pertanyaan keputusan |
| :--- | :--- | :--- |
| AB-01 | Nomor anggota dan kode katalog tidak boleh dipakai oleh dua entitas aktif yang berbeda. | Apakah kode lama dapat digunakan kembali setelah anggota nonaktif? |
| AB-02 | Anggota hanya dapat meminjam jika status keanggotaannya memenuhi syarat yang ditetapkan. | Status apa yang berhak meminjam dan siapa yang dapat mengubahnya? |
| AB-03 | Eksemplar harus tersedia ketika transaksi peminjaman berhasil disimpan. | Apakah salinan dengan kondisi tertentu boleh dipinjam dengan catatan khusus? |
| AB-04 | Satu eksemplar tidak boleh mempunyai lebih dari satu peminjaman aktif. | Bagaimana konflik transaksi bersamaan ditangani? |
| AB-05 | Batas pengembalian dihitung berdasarkan kebijakan yang berlaku pada waktu pinjam. | Apakah akhir pekan atau hari libur mengubah batas waktu? |
| AB-06 | Pengembalian tidak boleh tercatat lebih awal daripada peminjaman. | Apakah tanggal dicatat sampai satuan hari atau sampai jam? |
| AB-07 | Keterlambatan dihitung menggunakan aturan hari yang disepakati dan tidak menghasilkan nilai negatif. | Apakah satu hari berarti 24 jam atau pergantian tanggal kalender? |
| AB-08 | Denda dihitung dengan tarif dan pembulatan yang transparan. | Apakah nominal denda dapat dikurangi, dibatalkan, atau dibayar sebagian? |
| AB-09 | Data transaksi yang sudah selesai tidak dihapus melalui operasi normal. | Siapa yang boleh mengoreksi kesalahan dan bagaimana jejak audit disimpan? |

Dokumentasi yang menjawab pertanyaan tersebut akan memperjelas rancangan fisik. Jika kebijakan berubah dari waktu ke waktu, sistem perlu menentukan apakah menyimpan versi tarif atau nominal denda yang telah ditetapkan saat transaksi agar nilai historis tidak berubah.

### 6.13 Keamanan, Privasi, dan Tata Kelola Data

Data anggota mencakup nama, alamat, nomor telepon, surel, dan riwayat peminjaman. Tidak setiap petugas memerlukan akses ke semua data tersebut. Rancangan peran sebaiknya mengikuti prinsip hak akses minimum: petugas sirkulasi hanya melihat informasi yang diperlukan untuk memproses pinjam-kembali, sedangkan perubahan data master atau pengelolaan akun dibatasi kepada peran yang berwenang.

Pengamanan tidak cukup dilakukan dengan menyembunyikan kolom di antarmuka. Akses perlu dijaga pada lapisan aplikasi dan basis data, komunikasi menggunakan koneksi terlindungi, serta kredensial dikelola dengan aman. Bila sistem mencatat audit, catatan tersebut dapat berisi identitas pelaku, waktu, jenis tindakan, dan objek terkait tanpa menyalin data pribadi secara berlebihan.

Kebijakan retensi juga perlu ditetapkan. Riwayat pinjam mungkin diperlukan untuk audit atau pelayanan, tetapi menyimpan informasi kontak tanpa batas waktu dapat menambah risiko privasi. Pengelola perlu menentukan tujuan pengumpulan, masa simpan, proses koreksi, dan prosedur untuk permintaan penghapusan sesuai kebijakan organisasi serta ketentuan yang berlaku. Laporan ini mengidentifikasi kebutuhan tersebut, bukan menggantikan kajian kepatuhan formal.

### 6.14 Risiko Desain dan Mitigasi Awal

| Risiko | Penyebab yang mungkin | Mitigasi pada tahap desain |
| :--- | :--- | :--- |
| Satu salinan dipinjam lebih dari sekali | Pemeriksaan hanya dilakukan pada antarmuka atau transaksi bersamaan tidak ditangani | Validasi status di dalam transaksi dan uji skenario konkurensi. |
| Riwayat kehilangan hubungan | Data induk dihapus tanpa mempertimbangkan transaksi | Gunakan penonaktifan atau arsip serta tentukan aturan referensial. |
| Denda berbeda untuk kasus serupa | Rumus, awal hitung, dan pembulatan tidak didefinisikan | Dokumentasikan tarif, aturan tanggal, pembatalan, dan dasar hitung. |
| Pengembalian parsial tidak tercatat | Entitas pengembalian hanya menunjuk ke transaksi induk | Konfirmasi kebutuhan dan tautkan status pengembalian ke detail bila diperlukan. |
| Ketersediaan tidak sesuai riwayat | Status salinan tidak diperbarui bersama transaksi | Gunakan operasi atomik dan lakukan rekonsiliasi terhadap transaksi aktif. |
| Pencarian katalog lambat | Volume dan pola kueri tidak diukur | Uji kueri dengan data representatif sebelum memilih indeks atau optimasi. |
| Data pribadi dibuka tanpa kebutuhan | Peran terlalu luas dan akses tidak ditinjau | Terapkan hak minimum dan audit akses sesuai kebijakan. |

Mitigasi tersebut merupakan arah rancangan awal. Pilihan teknis final perlu mempertimbangkan DBMS, volume data, arsitektur aplikasi, kemampuan operasional, serta standar organisasi.

### 6.15 Rencana Pekerjaan Lanjutan

1. Mengonfirmasi proses aktual kepada pengelola, terutama batas jumlah pinjaman, perpanjangan, pengembalian sebagian, tarif denda, dan penanganan buku hilang.
2. Memperbarui aturan bisnis dan daftar kebutuhan informasi berdasarkan jawaban pemangku kepentingan.
3. Memfinalkan kamus data yang memuat tipe data, ukuran, nilai default, kewajiban isi, dan validasi setiap atribut.
4. Menurunkan ERD menjadi skema tabel dan memeriksa kembali PK, FK, keunikan, nullability, serta tindakan referensial.
5. Menyusun DDL dan menguji constraint menggunakan data uji normal dan kasus batas.
6. Membuat kueri katalog, anggota aktif, riwayat pinjam, ketersediaan salinan, dan rekapitulasi denda.
7. Menguji peminjaman dan pengembalian dalam transaksi, termasuk simulasi akses bersamaan.
8. Meninjau perlindungan data, pencadangan, pemulihan, dan audit sebelum sistem digunakan.
9. Mencatat keputusan serta perubahan desain ke kendali versi agar evolusi model dapat ditelusuri.

Urutan ini merupakan rekomendasi pekerjaan lanjutan dan bukan klaim bahwa DDL atau sistem aplikasi sudah dibuat.

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

#### Rincian Kasus Uji

| ID uji | Kondisi awal | Tindakan | Hasil yang diharapkan |
| :--- | :--- | :--- | :--- |
| U-01 | Kode anggota belum digunakan | Menambahkan anggota dengan kode tersebut | Data berhasil ditambahkan dan memiliki `id_anggota`. |
| U-02 | Kode anggota sudah terdaftar | Menambahkan anggota lain dengan kode sama | Penyimpanan ditolak oleh aturan unik; data pertama tidak berubah. |
| U-03 | Buku dan eksemplar tersedia | Membuat peminjaman dengan referensi valid | Peminjaman dan detail tersimpan, status salinan berubah sesuai aturan. |
| U-04 | `id_anggota` tidak ada | Menambahkan peminjaman dengan FK tersebut | Penyimpanan ditolak; tidak ada transaksi yatim. |
| U-05 | Eksemplar sudah dipinjam aktif | Membuat peminjaman kedua untuk eksemplar itu | Operasi kedua ditolak tanpa membuat detail parsial. |
| U-06 | Peminjaman belum memiliki pengembalian | Mencatat pengembalian pada tanggal valid | Satu pengembalian tersimpan dan status salinan diperbarui. |
| U-07 | Peminjaman sudah dikembalikan | Mengirim permintaan pengembalian ulang | Permintaan ditolak dan pengembalian pertama tetap tercatat. |
| U-08 | Tanggal pengembalian sebelum tanggal pinjam | Menyimpan tanggal tidak valid | Validasi menolak tanggal dan data sebelumnya tetap utuh. |
| U-09 | Transaksi selesai tepat pada batas waktu | Menghitung hari keterlambatan | Hasil nol sesuai definisi hari yang telah disepakati. |
| U-10 | Transaksi terlambat dan tarif telah ditetapkan | Memproses pengembalian | Denda tercatat sesuai kebijakan dengan dasar hitung yang dapat ditelusuri. |
| U-11 | Transaksi memiliki beberapa eksemplar | Mengembalikan hanya sebagian salinan | Perilaku sesuai keputusan desain; jika didukung, setiap detail menunjukkan status pengembaliannya. |
| U-12 | Pencatatan detail gagal di tengah transaksi | Memicu kegagalan saat penyimpanan | Perubahan dibatalkan atau dipulihkan sehingga data dan status tetap konsisten. |

Data pada tabel tersebut adalah rancangan kasus uji, bukan hasil pengujian aktual. Kasus U-11 menyoroti keputusan yang belum dijelaskan diagram: entitas `pengembalian` mengacu pada satu transaksi, bukan langsung pada setiap detailnya. Jika pengembalian sebagian diperbolehkan, rancangan perlu menyimpan eksemplar mana yang telah kembali dan waktunya—misalnya dengan atribut pengembalian pada detail atau entitas pengembalian yang berhubungan dengan detail. Pilihan tersebut perlu divalidasi dengan proses layanan sebelum perubahan ERD dibuat.

---

## 8. Kesimpulan

Praktikum Pertemuan 3 berhasil membuktikan bahwa pemodelan ERD yang matang adalah fondasi utama dalam membangun sistem basis data yang andal. Melalui studi kasus Perpustakaan M MEDIA, seluruh proses bisnis—mulai dari manajemen anggota, pengelolaan eksemplar buku, transaksi peminjaman, hingga pencatatan denda—telah terakomodasi secara optimal ke dalam struktur relasional yang terstandarisasi.

Hasil analisis juga menunjukkan pentingnya memisahkan data judul buku dari salinan fisiknya, menggunakan tabel detail untuk menguraikan transaksi, serta menjaga referensi melalui PK dan FK. Penelusuran kebutuhan informasi dapat dilakukan melalui rangkaian relasi yang jelas sehingga katalog, riwayat peminjaman, dan rekapitulasi denda mempunyai dasar data yang dapat dijelaskan.

Beberapa aturan, terutama pencegahan peminjaman ganda pada waktu bersamaan, memerlukan validasi transaksi pada tahap implementasi dan tidak selesai hanya dengan menggambar relasi. Penentuan tipe data, indeks, kebijakan pengarsipan, dan rincian perhitungan denda juga menjadi pekerjaan lanjutan sebelum model fisik diterapkan.

Dengan demikian, keluaran utama praktikum ini adalah pemahaman struktur dan keterlacakan kebutuhan, bukan klaim bahwa aplikasi perpustakaan telah berjalan. Kamus data, matriks CRUD, skenario kasus uji, serta daftar keputusan terbuka memberikan landasan untuk pekerjaan berikutnya, yaitu validasi rancangan bersama pengguna dan penerjemahan ERD ke skema relasional.

---

## 9. Pernyataan Penggunaan AI

Dalam penyusunan laporan ini, bantuan kecerdasan buatan digunakan sebagai pendukung penataan struktur kalimat, perapian format tabel, serta penguatan pemahaman konsep basis data. Seluruh hasil diagram, analisis kardinalitas, dan verifikasi akhir dikerjakan secara mandiri sesuai dengan ketentuan praktikum.

---

## 10. Bukti Git Commit
- `fdce673` — commit: p03: erd proyek perpustakaan
- `a9a6b25` — commit: p03: erd kopma