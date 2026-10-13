# Dokumen Kebutuhan Data - Koperasi Mahasiswa (Kopma)

## 1. Latar belakang dan aktivitas organisasi
Koperasi Mahasiswa (Kopma) merupakan unit kegiatan mahasiswa yang bergerak di bidang usaha ritel dan jasa untuk memenuhi kebutuhan sivitas akademika. Aktivitas utama organisasi mencakup pengadaan barang, penjualan harian di toko/minimarket Kopma, pengelolaan keanggotaan mahasiswa, pencatatan simpanan (pokok, wajib, sukarela), serta penyusunan laporan keuangan dan pembagian Sisa Hasil Usaha (SHU) tahunan.

## 2. Aktor dan proses bisnis (tabel PB-xx)

| Kode PB | Nama Proses Bisnis | Aktor Terlibat | Deskripsi Singkat |
|---|---|---|---|
| PB-01 | Pendaftaran & Pengelolaan Anggota | Mahasiswa, Pengurus Kopma | Proses penerimaan anggota baru, pencatatan biodata, serta pembayaran simpanan pokok dan wajib. |
| PB-02 | Pengadaan Barang Dagangan | Bagian Gudang, Supplier, Bendahara | Proses pemesanan barang ke supplier, penerimaan barang, hingga verifikasi faktur pembelian. |
| PB-03 | Penjualan Ritel & Kasir | Kasir, Pembeli (Anggota/Non-Anggota) | Transaksi penjualan harian barang toko, pencetakan struk, dan penerimaan pembayaran. |
| PB-04 | Pengelolaan Simpanan Anggota | Bendahara, Anggota | Pencatatan transaksi simpanan sukarela, penarikan simpanan, dan rekapitulasi saldo anggota. |
| PB-05 | Perhitungan & Pembagian SHU | Pengurus, Anggota | Perhitungan kontribusi transaksi anggota selama satu periode untuk pembagian SHU. |

## 3. Dokumen sumber yang dianalisis
* **Formulir Pendaftaran Anggota:** Mengandung data pribadi mahasiswa, program studi, dan status keanggotaan.
* **Nota / Struk Penjualan:** Mengandung detail item yang dibeli, harga, jumlah, diskon anggota, dan total bayar.
* **Faktur Pembelian & Surat Jalan:** Mengandung detail barang masuk dari supplier, harga beli, dan tanggal jatuh tempo.
* **Buku Tabungan / Kartu Simpanan Anggota:** Catatan historis setoran dan penarikan simpanan.
* **Laporan Rekapitulasi Penjualan Harian:** Catatan total omset dan metode pembayaran per shift kasir.

## 4. Entitas kandidat dan elemen data
* **Anggota:** `id_anggota`, `npm`, `nama_lengkap`, `prodi`, `no_hp`, `email`, `tanggal_bergabung`, `status_aktif`
* **Barang:** `kode_barang`, `nama_barang`, `kategori`, `satuan`, `harga_beli`, `harga_jual`, `stok`
* **Supplier:** `id_supplier`, `nama_supplier`, `alamat`, `no_telepon`, `email`
* **Transaksi_Penjualan:** `no_faktur_jual`, `tanggal_transaksi`, `id_anggota`, `id_kasir`, `total_bayar`, `metode_bayar`
* **Detail_Penjualan:** `no_faktur_jual`, `kode_barang`, `jumlah`, `harga_satuan`, `subtotal`
* **Transaksi_Simpanan:** `id_simpanan`, `id_anggota`, `jenis_simpanan`, `tanggal`, `jumlah`, `jenis_transaksi`

## 5. Aturan bisnis (tabel AB-xx)

| Kode AB | Nama Aturan Bisnis | Deskripsi Aturan |
|---|---|---|
| AB-01 | Keanggotaan Unik | Setiap anggota wajib memiliki NPM yang terverifikasi dan hanya terdaftar satu kali. |
| AB-02 | Potongan Harga Anggota | Anggota aktif berhak mendapatkan poin/diskon khusus saat belanja dengan menunjukkan kartu anggota. |
| AB-03 | Validasi Stok Barang | Transaksi penjualan tidak dapat diproses jika jumlah barang melebihi stok yang tersedia. |
| AB-04 | Penarikan Simpanan | Simpanan pokok dan wajib tidak dapat ditarik selama masih menjadi anggota aktif Kopma. |
| AB-05 | Syarat Hak SHU | Anggota yang berhak menerima SHU adalah anggota yang statusnya aktif pada periode berjalan. |

## 6. Kebutuhan informasi (tabel KI-xx)

| Kode KI | Kebutuhan Informasi | Pemangku Kepentingan | Frekuensi Akses |
|---|---|---|---|
| KI-01 | Laporan Penjualan Harian dan Bulanan | Manajer Toko, Bendahara | Harian / Bulanan |
| KI-02 | Laporan Stok Barang dan Peringatan Min. Stok | Petugas Gudang | Real-time / Harian |
| KI-03 | Rekapitulasi Simpanan per Anggota | Bendahara, Anggota | Bulanan / Insidental |
| KI-04 | Laporan Perhitungan SHU Anggota | Pengurus, Anggota (RAT) | Tahunan |
| KI-05 | Laporan Kinerja Supplier & Pembelian | Bagian Pengadaan | Bulanan |

## 7. Matriks CRUD

| Entitas / Proses Bisnis | PB-01 (Anggota) | PB-02 (Pengadaan) | PB-03 (Penjualan) | PB-04 (Simpanan) | PB-05 (SHU) |
|---|:---:|:---:|:---:|:---:|:---:|
| **Anggota** | **C, R, U** | R | R | R | R |
| **Barang** | - | **C, R, U** | **R, U** | - | - |
| **Supplier** | - | **C, R, U, D** | R | - | - |
| **Transaksi_Penjualan** | - | - | **C, R** | - | R |
| **Transaksi_Simpanan** | - | - | - | **C, R, U** | R |

*(Keterangan: C = Create, R = Read, U = Update, D = Delete)*

## 8. Kamus data awal (dengan penanggung jawab)

| Nama Elemen Data | Tipe Data | Panjang | Keterangan / Batasan | Penanggung Jawab |
|---|---|---|---|---|
| `id_anggota` | Varchar | 10 | Primary Key, Format: KOPMA-XXXX | Divisi HRD / Keanggotaan |
| `npm` | Varchar | 12 | Unique, Nomor Pokok Mahasiswa | Divisi HRD / Keanggotaan |
| `nama_lengkap` | Varchar | 100 | Nama sesuai KMS/KTM | Divisi HRD / Keanggotaan |
| `kode_barang` | Varchar | 13 | Primary Key / Barcode standard | Divisi Usaha & Ritel |
| `harga_jual` | Decimal | 12,2 | Min: 0 | Divisi Usaha & Ritel |
| `stok` | Integer | 6 | Min: 0 | Divisi Gudang |
| `no_faktur_jual` | Varchar | 20 | Primary Key, Format: TRX-YYYYMMDD-XXX | Divisi Usaha & Ritel |
| `jumlah_simpanan` | Decimal | 12,2 | Nilai transaksi simpanan | Bendahara |

## 9. Kebutuhan non-fungsional data (volume, retensi, privasi)
* **Volume Data:** Diperkirakan menampung data hingga 2.000 anggota aktif, 1.500 SKU barang, serta rata-rata 150–300 transaksi penjualan per hari.
* **Retensi Data:** Data transaksi penjualan dan simpanan disimpan minimal selama 5 tahun untuk kepentingan audit keuangan organisasi dan RAT (Rapat Anggota Tahunan).
* **Privasi Data:** Data pribadi anggota (Nomor HP, Email) bersifat rahasia dan hanya dapat diakses oleh Pengurus Keanggotaan dan Bendahara.
* **Ketersediaan & Kinerja:** Sistem pencatatan kasir harus memiliki waktu respon query transaksi kurang dari 2 detik.

## 10. Isu kualitas data yang diantisipasi
* **Duplikasi Data Anggota:** Risiko pendaftaran ganda oleh mahasiswa yang sama menggunakan penulisan NPM yang berbeda format.
* **Inkonsistensi Stok:** Perbedaan antara stok fisik di toko/gudang dengan stok yang tercatat pada sistem akibat barang rusak, hilang, atau lupa diinput.
* **Format Data Tidak Standar:** Variasi pengisian nama supplier dan alamat anggota yang tidak terstruktur.
* **Keterlambatan Input Transaksi:** Risiko penundaan pencatatan simpanan manual yang menyebabkan data saldo anggota tidak *real-time*.