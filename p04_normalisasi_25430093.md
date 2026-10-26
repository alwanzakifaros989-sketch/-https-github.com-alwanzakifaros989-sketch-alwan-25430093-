# NORMALISASI KOPMA

**Nama:** Alwan Zaki Faros  
**Kelas:** D  
**NPM:** 25430093  

---

## D.1 Mengubah UNF menjadi 1NF

Relasi awal yang belum dinormalisasi adalah:

`NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota, {kode_barang, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan}, jumlah_penjualan, diskon_penjualan, total_penjualan)`

Relasi tersebut masih memiliki kelompok barang berulang dalam satu nota. Satu nota dapat berisi beberapa barang sehingga kelompok barang perlu diuraikan menjadi satu baris untuk setiap barang pada setiap nota.

Setelah diubah menjadi bentuk normal pertama (1NF), relasinya menjadi:

`NOTA_1NF (no_nota_penjualan, kode_barang, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan, total_penjualan)`

**Kunci primer komposit:** `(no_nota_penjualan, kode_barang)`.

**Hasil normalisasi 1NF:**

Setiap atribut menyimpan satu nilai pada setiap baris dan tidak ada lagi kelompok barang berulang. Namun, masih terdapat atribut yang bergantung pada sebagian kunci komposit serta ketergantungan transitif. Oleh karena itu, normalisasi dilanjutkan ke 2NF dan 3NF.

## 3.2 Menentukan Dependensi Fungsional

Ketergantungan fungsional ditentukan berdasarkan aturan bisnis, bukan hanya dari kebetulan nilai yang terlihat pada data. Penentuan ini membantu mengetahui atribut yang bergantung pada suatu kunci.

| Contoh penentu | Atribut yang ditentukan | Makna |
|---|---|---|
| `kode_barang` | Atribut barang yang ditentukan oleh kode tersebut | Satu kode barang mengidentifikasi data barang yang sesuai. |
| `kode_petugas` | Atribut petugas yang ditentukan oleh kode tersebut | Data petugas dapat dikelola melalui kode petugas. |
| `no_nota_penjualan` | Informasi transaksi penjualan | Nomor nota mengidentifikasi transaksi penjualan. |

Contoh tersebut diterapkan secara rinci pada dependensi fungsional berikut:

| Kode | Dependensi fungsional | Keterangan |
|---|---|---|
| FD1 | `no_nota_penjualan → tgl_penjualan, kode_petugas, no_anggota` | Satu nomor nota menentukan tanggal transaksi, petugas, dan anggota. Berdasarkan AB-01. |
| FD2 | `kode_petugas → nama_petugas` | Kode petugas menentukan nama petugas. |
| FD3 | `no_anggota → nama_anggota` | Nomor anggota menentukan nama anggota. Berdasarkan AB-05. |
| FD4 | `kode_barang → nama_barang` | Kode barang menentukan nama barang. |
| FD5 | `(no_nota_penjualan, kode_barang) → qty_detail_penjualan, harga_satuan_detail_penjualan` | Kombinasi nomor nota dan kode barang menentukan kuantitas serta harga satuan pada transaksi. Berdasarkan AB-04. |
| FD6 | `(qty_detail_penjualan, harga_satuan_detail_penjualan) → subtotal_detail_penjualan` | Subtotal merupakan nilai turunan dari kuantitas dikalikan harga satuan. |

## 3.3 Mengubah 1NF menjadi 2NF

### Tahap 2NF

Bentuk normal kedua (2NF) mensyaratkan bahwa relasi sudah memenuhi 1NF dan tidak memiliki atribut bukan kunci yang bergantung hanya pada sebagian kunci komposit.

Pada relasi `NOTA_1NF`, kunci kompositnya adalah `(no_nota_penjualan, kode_barang)`. Namun, tanggal penjualan hanya ditentukan oleh nomor nota, sedangkan nama barang hanya ditentukan oleh kode barang.

Dengan demikian, informasi penjualan dan informasi barang perlu dipisahkan dari detail transaksi.

Relasi hasil pemisahan menuju 2NF adalah:

| Relasi | Informasi yang dikelola |
|---|---|
| `penjualan` | Informasi utama transaksi penjualan. |
| `barang` | Informasi barang. |
| `detail_penjualan` | Detail barang yang terdapat dalam transaksi penjualan. |

Struktur relasi hasil pemisahan:

| Relasi | Atribut | Kunci primer |
|---|---|---|
| `PENJUALAN` | `no_nota_penjualan`, `tgl_penjualan`, `kode_petugas`, `nama_petugas`, `no_anggota`, `nama_anggota`, `jumlah_penjualan`, `diskon_penjualan`, `total_penjualan` | `no_nota_penjualan` |
| `BARANG` | `kode_barang`, `nama_barang` | `kode_barang` |
| `DETAIL_PENJUALAN` | `no_nota_penjualan`, `kode_barang`, `qty_detail_penjualan`, `harga_satuan_detail_penjualan`, `subtotal_detail_penjualan` | (`no_nota_penjualan`, `kode_barang`) |

Pada tahap ini, ketergantungan pada sebagian kunci komposit telah dihilangkan. Akan tetapi, tabel `PENJUALAN` masih memiliki ketergantungan transitif karena `nama_petugas` ditentukan oleh `kode_petugas`, sedangkan `nama_anggota` ditentukan oleh `no_anggota`. Nilai turunan juga masih perlu dievaluasi sebelum menetapkan skema operasional akhir.

## 3.4 Mengubah 2NF menjadi 3NF

### Tahap 3NF

Bentuk normal ketiga (3NF) mensyaratkan bahwa relasi sudah memenuhi 2NF dan tidak memiliki ketergantungan transitif yang tidak diinginkan di antara atribut bukan kunci.

Pada tabel penjualan terdapat rantai dependensi:

`no_nota_penjualan → kode_petugas → nama_petugas`

Selain itu, terdapat rantai:

`no_nota_penjualan → no_anggota → nama_anggota`

Kedua rantai tersebut menunjukkan bahwa nama petugas dan nama anggota tidak perlu disimpan berulang dalam tabel penjualan. Informasi tersebut dipisahkan ke tabel masing-masing.

Relasi hasil normalisasi 3NF sesuai contoh dalam modul adalah:

**1. PENJUALAN**

`PENJUALAN (no_nota_penjualan, tgl_penjualan, kode_petugas*, no_anggota*, bayar_penjualan)`

**2. DETAIL_PENJUALAN**

`DETAIL_PENJUALAN (no_nota_penjualan*, kode_barang*, qty_detail_penjualan, harga_satuan_detail_penjualan)`

**3. BARANG**

`BARANG (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)`

**4. PETUGAS**

`PETUGAS (kode_petugas, nama_petugas, peran_petugas)`

**5. ANGGOTA**

`ANGGOTA (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota)`

Keterangan:

- Atribut yang ditetapkan sebagai kunci primer mengidentifikasi setiap baris dalam relasinya.
- Tanda `*` menunjukkan kunci tamu atau referensi ke relasi lain.
- `no_nota_penjualan` menjadi kunci primer pada bentuk relasi hasil pemisahan awal. Pada skema kanonik bagian 3.5, kunci primer penjualan menggunakan `id_penjualan`, sedangkan nomor nota menjadi kunci unik.

## 3.5 Mencocokkan dengan Skema Kanonik dan Pemeriksaan BCNF

Skema kanonik Kopma menggunakan kunci pengganti (*surrogate key*) berupa atribut `id_*` sebagai kunci primer. Nomor atau kode alami tetap dipertahankan sebagai kunci unik apabila ditentukan dalam skema.

### Perbandingan Hasil 3NF dengan Skema Kanonik

| Relasi hasil 3NF | Kunci pada hasil 3NF | Penyesuaian pada skema kanonik |
|---|---|---|
| `PENJUALAN` | `no_nota_penjualan` (PK); `kode_petugas` dan `no_anggota` sebagai referensi | Menggunakan `id_penjualan` sebagai PK; `no_nota_penjualan` menjadi UQ; referensi menggunakan `id_petugas` dan `id_anggota`. |
| `DETAIL_PENJUALAN` | (`no_nota_penjualan`, `kode_barang`) (PK) | PK/FK menggunakan (`id_penjualan`, `id_barang`). |
| `BARANG` | `kode_barang` (PK) | Menggunakan `id_barang` sebagai PK dan mempertahankan `kode_barang` sebagai UQ. |
| `PETUGAS` | `kode_petugas` (PK) | Menggunakan `id_petugas` sebagai PK dan mempertahankan `kode_petugas` sebagai UQ. |
| `ANGGOTA` | `no_anggota` (PK) | Menggunakan `id_anggota` sebagai PK; `no_anggota` dan `nim_anggota` menjadi UQ. |
| `PEMASOK`, `PEMBELIAN`, `DETAIL_PEMBELIAN` | Tidak dibahas pada relasi hasil 3NF di atas | Merupakan relasi tambahan pada skema kanonik untuk mendukung data pemasok dan transaksi pembelian. |

### Tabel Skema Kanonik Kopma

| Tabel | Kunci primer (PK) | Kunci unik (UQ) | Kunci tamu (FK) |
|---|---|---|---|
| `petugas` | `id_petugas` | `kode_petugas` | — |
| `anggota` | `id_anggota` | `no_anggota`, `nim_anggota` | — |
| `barang` | `id_barang` | `kode_barang` | — |
| `pemasok` | `id_pemasok` | — | — |
| `penjualan` | `id_penjualan` | `no_nota_penjualan` | `id_petugas`, `id_anggota` (boleh NULL) |
| `detail_penjualan` | `(id_penjualan, id_barang)` | — | `id_penjualan`, `id_barang` |
| `pembelian` | `id_pembelian` | — | `id_pemasok` |
| `detail_pembelian` | `(id_pembelian, id_barang)` | — | `id_pembelian`, `id_barang` |

Keterangan:

- **PK (*Primary Key*)** adalah kunci primer untuk mengidentifikasi setiap baris.
- **UQ (*Unique*)** memastikan nilai pada atribut yang ditetapkan unik tidak duplikat.
- **FK (*Foreign Key*)** menghubungkan suatu tabel dengan tabel lain.
- **NULL** menunjukkan bahwa suatu nilai boleh kosong sesuai aturan tabel.

Penggunaan kunci pengganti membuat identitas internal tabel tidak bergantung langsung pada nomor atau kode alami. Kunci unik tetap diperlukan agar nomor nota, kode petugas, kode barang, dan identitas alami lainnya tidak digunakan secara ganda.

### Pemeriksaan BCNF

BCNF (*Boyce–Codd Normal Form*) mensyaratkan bahwa setiap penentu pada dependensi fungsional nontrivial merupakan kunci kandidat. Pemeriksaan berikut didasarkan pada kunci dalam skema kanonik dan dependensi fungsional yang telah diidentifikasi. Kesimpulan akhir tetap perlu disesuaikan jika terdapat aturan bisnis lain yang menghasilkan dependensi tambahan.

| Tabel | Penentu yang diperiksa | Hasil pemeriksaan |
|---|---|---|
| `petugas` | `id_petugas`, `kode_petugas` | Kedua atribut merupakan kunci kandidat berdasarkan skema kanonik. Dependensi `kode_petugas → nama_petugas` tidak melanggar BCNF. |
| `anggota` | `id_anggota`, `no_anggota`, `nim_anggota` | Atribut-atribut tersebut ditetapkan sebagai kunci kandidat berdasarkan skema kanonik. Dependensi yang penentunya merupakan salah satu kunci kandidat tidak melanggar BCNF. |
| `barang` | `id_barang`, `kode_barang` | Kedua atribut merupakan kunci kandidat berdasarkan skema kanonik. Dependensi `kode_barang → nama_barang` tidak melanggar BCNF. |
| `pemasok` | `id_pemasok` | `id_pemasok` merupakan kunci primer. BCNF terpenuhi apabila tidak ada penentu lain yang bukan kunci kandidat. |
| `penjualan` | `id_penjualan`, `no_nota_penjualan` | Kedua atribut merupakan kunci kandidat berdasarkan skema kanonik. Dependensi yang diketahui tidak melanggar BCNF jika penentunya merupakan salah satu kunci kandidat tersebut. |
| `detail_penjualan` | `(id_penjualan, id_barang)` | Gabungan atribut merupakan kunci primer komposit. BCNF terpenuhi jika tidak terdapat penentu lain yang bukan kunci kandidat. |
| `pembelian` | `id_pembelian` | `id_pembelian` merupakan kunci primer. BCNF terpenuhi apabila tidak ada penentu lain yang bukan kunci kandidat. |
| `detail_pembelian` | `(id_pembelian, id_barang)` | Gabungan atribut merupakan kunci primer komposit. BCNF terpenuhi jika tidak terdapat penentu lain yang bukan kunci kandidat. |

Berdasarkan dependensi fungsional yang telah diidentifikasi, penentu yang merupakan kunci kandidat tidak melanggar BCNF. Pemeriksaan tetap harus mempertimbangkan seluruh dependensi yang berlaku pada setiap tabel. Penggunaan kunci pengganti saja tidak otomatis menjamin bahwa suatu relasi memenuhi BCNF.

## 3.6 Menentukan Nilai Turunan

Nilai turunan yang dibahas dalam normalisasi penjualan meliputi:

- `subtotal_detail_penjualan`
- `jumlah_penjualan`
- `diskon_penjualan`
- `total_penjualan`

Subtotal dihitung menggunakan rumus:

`subtotal_detail_penjualan = qty_detail_penjualan × harga_satuan_detail_penjualan`

Jumlah penjualan diperoleh dengan menjumlahkan subtotal seluruh barang dalam satu nota. Diskon ditentukan berdasarkan aturan bisnis yang berlaku, sedangkan total penjualan dihitung berdasarkan jumlah penjualan dan diskon.

Berdasarkan keputusan dalam modul, `subtotal_detail_penjualan`, `jumlah_penjualan`, dan `total_penjualan` tidak disimpan sebagai atribut tersendiri dalam tabel operasional karena nilainya dapat dihitung dari detail transaksi dan aturan yang berlaku. Hal ini mengurangi risiko ketidaksesuaian antara nilai yang disimpan dan hasil perhitungan.

Sementara itu, `bayar_penjualan` tetap dicatat karena merepresentasikan uang yang diterima dari pembeli. Nilai pembayaran aktual berbeda dari total belanja yang dihitung.

## 6.4 Nilai Turunan dan Catatan Normalisasi

| Catatan | Ringkasan |
|---|---|
| Nilai turunan | `subtotal_detail_penjualan` dihitung dari kuantitas dikali harga satuan; jumlah dan total penjualan diperoleh dari agregasi serta aturan diskon. |
| Nilai yang dicatat | `bayar_penjualan` tetap dicatat karena merupakan jumlah pembayaran aktual dari pembeli. |
| Pemisahan relasi | Data transaksi, barang, dan rincian barang dipisahkan agar kelompok berulang dan ketergantungan parsial tidak tersimpan dalam satu relasi. |
| Tahap normalisasi | 1NF menguraikan grup berulang, 2NF menghilangkan ketergantungan parsial, dan 3NF memisahkan ketergantungan transitif. |
| Pemeriksaan BCNF | Setiap penentu perlu diperiksa terhadap kunci kandidat pada relasinya; penggunaan kunci pengganti saja tidak otomatis menjamin BCNF. |

## Kesimpulan

Normalisasi dilakukan untuk mengurangi pengulangan data, mencegah anomali ubah, sisip, dan hapus, serta menjaga konsistensi informasi. Tahap 1NF menghilangkan kelompok berulang, 2NF menghilangkan ketergantungan pada sebagian kunci komposit, dan 3NF menghilangkan ketergantungan transitif yang tidak diinginkan.

Selanjutnya, relasi hasil normalisasi dicocokkan dengan skema kanonik Kopma yang menggunakan kunci pengganti dan kunci unik. Pemeriksaan BCNF dilakukan berdasarkan dependensi fungsional serta kunci kandidat pada setiap tabel. Keputusan untuk menghitung nilai turunan, bukan menyimpannya dalam tabel operasional, juga membantu menjaga konsistensi hasil perhitungan transaksi.

## E. Latihan dan Modifikasi

### 1. Normalisasi Nomor Telepon Pemasok

Kopma membutuhkan penyimpanan beberapa nomor telepon untuk setiap pemasok. Jika beberapa nomor telepon disimpan dalam satu kolom pada tabel `pemasok`, data menjadi tidak atomik dan tidak memenuhi bentuk normal pertama (1NF).

Untuk mengatasinya, data nomor telepon dipisahkan ke dalam relasi baru bernama `telepon_pemasok`.

**Relasi pemasok:**

`PEMASOK (id_pemasok, kode_pemasok, nama_pemasok, alamat_pemasok)`

- PK: `id_pemasok`
- UQ: `kode_pemasok`

**Relasi telepon pemasok:**

`TELEPON_PEMASOK (id_pemasok, no_telepon)`

- PK: `(id_pemasok, no_telepon)`
- FK: `id_pemasok` mengacu pada `PEMASOK(id_pemasok)`

Dengan pemisahan ini, satu pemasok dapat memiliki beberapa nomor telepon. Setiap nomor telepon disimpan sebagai satu nilai dalam satu baris, sedangkan data pemasok tidak perlu diulang untuk setiap nomor telepon.

### 2. Pelanggaran 3NF dan Anomali Ubah

Jika atribut `nama_anggota` disimpan di tabel `penjualan`, maka nama anggota akan berulang pada setiap transaksi yang dilakukan oleh anggota yang sama.

Contoh data:

| no_nota_penjualan | no_anggota | nama_anggota |
|---|---|---|
| N001 | A-0001 | Andi |
| N002 | A-0001 | Andi |

Pada data tersebut, `no_nota_penjualan` menentukan `no_anggota`, sedangkan `no_anggota` menentukan `nama_anggota`. Dengan demikian, terdapat dependensi transitif:

`no_nota_penjualan → no_anggota → nama_anggota`

Hal ini melanggar 3NF karena atribut `nama_anggota` bergantung secara transitif pada kunci primer `no_nota_penjualan`, bukan secara langsung pada kunci primer tersebut.

**Contoh kueri yang menunjukkan anomali ubah:**

```sql
UPDATE penjualan
SET nama_anggota = 'Andi Pratama'
WHERE no_nota_penjualan = 'N001';
