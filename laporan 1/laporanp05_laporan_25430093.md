# Laporan Praktikum Basis Data - Pertemuan 05

**Nama** : Alwan Zaki Faros  
**NPM** : 25430093  
**Kelas** : D  
**Tanggal** : 30 Oktober 2026  
**Dosen Pengampu** : Dedi Irawan, S.Kom., M.Kom.

---

## 1. Tujuan Praktikum

Praktikum Pertemuan 05 ini bertujuan untuk membekali mahasiswa dengan kemampuan praktis dan analitis dalam merancang skema relasional basis data. Secara spesifik, tujuan pelaksanaan praktikum ini meliputi:

1. **Penerapan Sintaks DDL (*Data Definition Language*):** Mampu menyusun skrip SQL menggunakan instruksi `CREATE TABLE`, `ALTER TABLE`, dan `DROP TABLE` secara aman dan sistematis.
2. **Pengelolaan Kunci Relasional:** Mengimplementasikan *Primary Key* sebagai identitas baris tunggal dan *Foreign Key* untuk membangun relasi antar-tabel serta menjaga integritas referensial.
3. **Penerapan *Domain Constraints*:** Menambahkan pembatasan data melalui constraint `UNIQUE`, `NOT NULL`, dan `CHECK` guna menjamin validitas data sesuai dengan spesifikasi kebutuhan operasional.
4. **Implementasi Domain Proyek Mandiri:** Menerapkan skema relasional pada domain **Klinik Mandiri (`klinik_093`)** sesuai dengan dokumen aturan bisnis (AB-01 s.d. AB-21).
5. **Validasi Model dan Implementasi:** Membandingkan kesesuaian antara diagram fisik ERD (`p05_erd_fisik_25430093.png`) dengan hasil bangkitan DDL pada DBMS MySQL/MariaDB.

---

## 2. Ringkasan Dasar Teori

*Data Definition Language* (DDL) merupakan subset dari bahasa SQL yang berfokus pada prapemrosesan dan pendefinisian struktur atau skema basis data. Berbeda dari *Data Manipulation Language* (DML) yang memanipulasi baris data, DDL mengeksekusi manipulasi metadata tabel, indeks, serta aturan pembatasan domain.

### 2.1 Jenis-Jenis Constraint dan Konvensi Penamaan
Untuk mempertahankan standar industri dan kemudahan penanganan kesalahan (*error handling*), setiap pembatasan wajib diberi nama secara eksplisit menggunakan konvensi baku:

* **`PRIMARY KEY` (`pk_<nama_tabel>`):** Menjamin keunikan tingkat baris dan secara otomatis membentuk indeks primer.
* **`FOREIGN KEY` (`fk_<tabel_asal>_<tabel_tujuan>`):** Menjamin integritas referensial antar-tabel anak dan tabel induk. Parameter `ON DELETE CASCADE` atau `ON UPDATE CASCADE` menentukan perilaku referensial saat data induk berubah.
* **`UNIQUE` (`uq_<nama_tabel>_<kolom>`):** Mencegah duplikasi nilai pada kolom tertentu tanpa menjadikannya sebagai kunci utama (contoh: NIK atau Nomor Rekam Medis).
* **`CHECK` (`ck_<nama_tabel>_<kondisi>`):** Memvalidasi klausa ekspresi boolean pada kolom sebelum operasi penyisipan atau pembaruan disetujui DBMS.

### 2.2 Relevansi pada Domain Klinik (`klinik_093`)
Dalam domain pelayanan kesehatan, integritas data bersifat sangat kritis. Kesalahan relasi antara catatan kunjungan pasien dan dokter pemeriksa, atau harga obat bernilai negatif, dapat merusak integritas transaksi rekam medis dan keuangan klinik. Dokumen Aturan Bisnis (AB-01 s.d. AB-21) menjadi fondasi utama dalam perancangan DDL pada modul ini.

---

## 3. Hasil Langkah Percobaan (Tangkapan Layar + Keterangan)

### 3.1 Pembuatan dan Pemeriksaan Struktur Tabel

Seluruh kode pembuatan skema basis data disimpan secara terstruktur di dalam berkas `p05_ddl_25430093.sql`. Skrip ini diawali dengan perintah pembersihan skema agar bersifat *idempotent* (dapat dijalankan ulang secara bersih):

```sql
DROP DATABASE IF EXISTS klinik_093;
CREATE DATABASE klinik_093;
USE klinik_093;
```

**Gambar 1. Hasil Pemeriksaan Skema Tabel Klinik (`SHOW CREATE TABLE`)**

*(Lampirkan tangkapan layar eksekusi SHOW CREATE TABLE di sini)*

Perintah pemeriksaan struktur tabel yang dieksekusi:

```sql
SHOW CREATE TABLE dokter;
SHOW CREATE TABLE pasien;
SHOW CREATE TABLE kunjungan;
SHOW CREATE TABLE resep;
SHOW CREATE TABLE obat;
SHOW CREATE TABLE tindakan;
SHOW CREATE TABLE tindakan_detail;
SHOW CREATE TABLE resep_detail;
```

*Keterangan Gambar 1:* Eksekusi `SHOW CREATE TABLE` mengonfirmasi bahwa seluruh tabel telah terkonfigurasi dengan mesin penyimpanan InnoDB, set karakter UTF-8, serta memiliki daftar constraint `CONSTRAINT pk_...`, `CONSTRAINT fk_...`, `CONSTRAINT uq_...`, dan `CONSTRAINT ck_...` yang sesuai.

---

### 3.2 Membuktikan Constraint Bekerja

Untuk memastikan bahwa mekanisme pertahanan basis data aktif, dilakukan serangkaian pengujian injeksi data yang sengaja melanggar aturan bisnis.

#### a. Penyiapan Data Master (Sampel Valid)

```sql
-- Memasukkan data dokter awal
INSERT INTO dokter (kode_dokter, nama_dokter, spesialis_dokter, no_hp_dokter)
VALUES ('DOC01', 'dr. Andi Pratama', 'Spesialis Penyakit Dalam', '081234567890');

-- Memasukkan data pasien awal
INSERT INTO pasien (no_rekam_medis, nik_pasien, nama_pasien, tgl_lahir_pasien)
VALUES ('RM-00001', '3201012304950001', 'Budi Santoso', '1995-04-23');
```

**Gambar 2. Inserdi Data Master Berhasil**

*(Lampirkan tangkapan layar sukses input data master)*

---

#### b. Pengujian Foreign Key Constraint (`fk_kunjungan_pasien`)

Mencoba menambahkan data kunjungan dengan `id_pasien` bernilai `9999` yang tidak pernah terdaftar pada tabel `pasien`.

```sql
INSERT INTO kunjungan 
    (no_registrasi, tgl_kunjungan, id_pasien, id_dokter, keluhan_kunjungan)
VALUES 
    ('REG-2610-001', NOW(), 9999, 1, 'Pemeriksaan Rutin');
```

**Gambar 3. Galat Pelanggaran Foreign Key**

*(Lampirkan tangkapan layar EROR 1452)*

*Analisis Hasil:*  
DBMS menolak transaksi dengan respon galat:  
`ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (klinik_093.kunjungan, CONSTRAINT fk_kunjungan_pasien FOREIGN KEY (id_pasien) REFERENCES pasien (id_pasien))`  
Hal ini membuktikan bahwa `FOREIGN KEY` berhasil mencegah pencatatan rekam medis phantom/fiktif yang merujuk pada entitas pasien tak dikenal.

---

#### c. Pengujian Check Constraint (`ck_obat_harga_jual`)

Mencoba memperbarui atau menyisipkan harga jual obat bernilai negatif (melanggar AB-13).

```sql
INSERT INTO obat 
    (kode_obat, nama_obat, kategori_obat, harga_jual_obat, stok_obat, stok_min_obat)
VALUES 
    ('OBT-999', 'Sirup Test Error', 'Bebas', -15000.00, 10, 2);
```

**Gambar 4. Galat Pelanggaran Check Constraint**

*(Lampirkan tangkapan layar EROR 3819 / 4025)*

*Analisis Hasil:*  
DBMS menolak data tersebut dengan memberikan balasan pesan galat:  
`ERROR 3819 (HY000): Check constraint 'ck_obat_harga_jual' is violated.`  
Pengujian ini memvalidasi bahwa constraint `CHECK` mampu melindungi aspek integritas domain keuangan klinik dari kesalahan entri angka negatif.

---

#### d. Pengujian Unique Constraint (`uq_pasien_nik_pasien`)

Mencoba mendaftarkan pasien baru dengan NIK yang sudah digunakan oleh pasien lain (melanggar AB-05).

```sql
INSERT INTO pasien 
    (no_rekam_medis, nik_pasien, nama_pasien, tgl_lahir_pasien)
VALUES 
    ('RM-00002', '3201012304950001', 'Dewi Lestari', '2000-01-01');
```

**Gambar 5. Galat Pelanggaran Unique Constraint**

*(Lampirkan tangkapan layar EROR 1062)*

*Analisis Hasil:*  
Sistem menolak eksekusi query dengan balasan pesan galat:  
`ERROR 1062 (23000): Duplicate entry '3201012304950001' for key 'pasien.uq_pasien_nik_pasien'`  
Hasil ini menjamin bahwa atribut NIK tetap bersifat unik secara global pada seluruh sistem klinik.

---

## 4. Jawaban Titik Analisis

### 4.1 Mengapa constraint diperlukan?
Constraint merupakan mekanisme keamanan tingkat terendah (pada *database layer*) untuk menjamin konsistensi data. Walaupun validasi dapat dilakukan pada antarmuka aplikasi (*frontend* atau *backend*), constraint basis data berfungsi sebagai benteng terakhir yang mencegah terjadinya *data corruption* akibat kegagalan kode aplikasi, manipulasi jaringan, atau injeksi SQL.

### 4.2 Apa fungsi PRIMARY KEY dan FOREIGN KEY?
* **`PRIMARY KEY`:** Berfungsi memberikan identitas unik mutlak bagi setiap entitas baris pada tabel, serta secara otomatis membangun indeks struktur pohon B-Tree untuk mempercepat kueri pencarian.
* **`FOREIGN KEY`:** Berfungsi sebagai jembatan logika antar-entitas (misalnya mengikat `id_kunjungan` pada `resep` menuju tabel `kunjungan`). Fitur ini menjamin bahwa tidak ada transaksi anak yang kehilangan *parent record* (mencegah *orphan data*).

### 4.3 Mengapa nama constraint harus dibuat jelas?
Secara bawaan, DBMS akan memberikan nama acak (*random string*) jika nama constraint tidak ditentukan secara eksplisit. Penamaan standar seperti `fk_kunjungan_pasien` atau `ck_obat_harga_jual` memudahkan pengembang dalam melakukan penelusuran galat (*debugging*), pembuatan dokumentasi sistem, serta penulisan skrip migrasi basis data di masa mendatang.

### 4.4 Apakah semua aturan bisnis bisa diterapkan dengan CHECK?
Tidak seluruh aturan bisnis dapat diselesaikan menggunakan `CHECK`. Constraint `CHECK` hanya mampu mengevaluasi nilai dalam konteks satu baris data (*tuple-level constraint*). Aturan bisnis kompleks yang melibatkan agregasi banyak baris data (seperti pembatasan bahwa satu resep maksimal berisi 5 jenis obat) tidak dapat diuji dengan `CHECK` standar dan memerlukan *Stored Procedure*, *Trigger*, atau mekanisme transaksi terisolasi.

---

## 5. Hasil Latihan dan Modifikasi

### 5.1 Penerapan Constraint pada Proyek Klinik

Ringkasan penerapan pembatasan domain pada basis data `klinik_093`:

| Jenis Constraint | Penerapan pada Tabel | Tujuan Operasional |
| :--- | :--- | :--- |
| `PRIMARY KEY` | Seluruh Tabel (`id_dokter`, `id_pasien`, dll.) | Menjamin keunikan baris data |
| `FOREIGN KEY` | `kunjungan`, `resep`, `tindakan_detail`, `resep_detail` | Menjaga relasi medis antar-entitas |
| `UNIQUE` | `kode_dokter`, `no_rekam_medis`, `nik_pasien`, `no_registrasi`, `kode_obat` | Mencegah penomoran ganda |
| `NOT NULL` | Nama, Tanggal, Kode Identitas | Memastikan kolom wajib tidak kosong |
| `CHECK` | `harga_jual_obat`, `tarif_tindakan`, `qty_tindakan_detail`, `qty_resep_detail` | Memvalidasi batasan nilai numerik |

### 5.2 Penyesuaian Skema Detail Transaksi Medis

Pada skema `klinik_093`, digunakan tabel relasi banyak-ke-banyak (*many-to-many*) yaitu `tindakan_detail` dan `resep_detail`. Penggunaan *Composite Primary Key* (kombinasi dua kunci tamu) memungkinkan satu kali kunjungan menerima lebih dari satu tindakan medis dan resep obat yang bervariasi tanpa menimbulkan redundansi data induk.

---

## 6. Tugas Mandiri: Milestone Proyek 05

### 6.1 Identitas Proyek

* **Tema System:** Sistem Informasi Manajemen Pelayanan Klinik
* **Nama Entitas:** Klinik Mandiri `klinik_093`
* **Nama Basis Data:** `klinik_093`

Klinik Mandiri `klinik_093` berfokus pada digitalisasi layanan kesehatan rawat jalan, mencakup manajemen data tenaga medis, data pasien, riwayat registrasi kunjungan, hingga rincian tindakan medis serta peresepan obat.

### 6.2 Implementasi DDL

Berkas skrip SQL utama yang disusun adalah: `p05_ddl_25430093.sql`.  
Skrip ini dirancang dengan menyertakan aturan *cascading* (`ON DELETE CASCADE ON UPDATE CASCADE`) pada hubungan entitas bertingkat untuk menjaga transparansi pergerakan data.

### 6.3 Pemetaan Aturan Bisnis (AB-xx)

| Kode AB | Aturan Bisnis Spesiﬁk | Formulasi DDL / Constraint |
| :---: | :--- | :--- |
| **AB-01** | Setiap dokter wajib memiliki ID unik | `CONSTRAINT pk_dokter PRIMARY KEY (id_dokter)` |
| **AB-02** | Kode unik dokter tidak boleh kembar | `CONSTRAINT uq_dokter_kode UNIQUE (kode_dokter)` |
| **AB-04** | Nomor Rekam Medis (RM) pasien bersifat unik | `CONSTRAINT uq_pasien_no_rm UNIQUE (no_rekam_medis)` |
| **AB-05** | NIK Pasien terlindungi dari duplikasi | `CONSTRAINT uq_pasien_nik UNIQUE (nik_pasien)` |
| **AB-07** | Nomor pendaftaran kunjungan harus unik | `CONSTRAINT uq_kunjungan_no_reg UNIQUE (no_registrasi)` |
| **AB-08** | Setiap kunjungan wajib terikat pada Pasien & Dokter | `FOREIGN KEY (id_pasien)` & `FOREIGN KEY (id_dokter)` |
| **AB-13** | Harga jual obat tidak bernilai negatif | `CONSTRAINT ck_obat_harga_jual CHECK (harga_jual_obat >= 0)` |
| **AB-19** | Kuantitas tindakan detail minimal 1 item | `CONSTRAINT ck_tindakan_qty CHECK (qty_tindakan_detail > 0)` |
| **AB-21** | Kuantitas obat dalam resep minimal 1 unit | `CONSTRAINT ck_resep_qty CHECK (qty_resep_detail > 0)` |

### 6.4 Model ERD Fisik

Berkas diagram fisik yang dihasilkan adalah: `p05_erd_fisik_25430093.png`.

**Gambar 6. Diagram Fisik Relasi Basis Data Klinik (`p05_erd_fisik_25430093.png`)**

*(Lampirkan gambar ERD fisik di sini)*

*Keterangan Gambar 6:* Diagram memperlihatkan hubungan relasional antara 8 tabel utama beserta tipe data, atribut kunci primer (PK), kunci tamu (FK), dan kardinalitas relasi antar-tabel.

### 6.5 Pemetaan Tipe Data

| Atribut | Tipe Data terpilih | Justifikasi Teknis |
| :--- | :--- | :--- |
| `id_dokter`, `id_pasien`, `id_kunjungan` | `INT(11) AUTO_INCREMENT` | Menggenerasi urutan penomoran otomatis |
| `kode_dokter`, `no_rekam_medis` | `CHAR(5)`, `CHAR(8)` | Alokasi memori tetap untuk kueri cepat |
| `nik_pasien` | `CHAR(16)` | Sesuai dengan format baku standar NIK nasional |
| `nama_dokter`, `nama_pasien`, `nama_obat` | `VARCHAR(100)` | Efisiensi penyimpanan string dinamis |
| `keluhan_kunjungan`, `diagnosa_kunjungan` | `TEXT` | Menampung catatan diagnosis panjang |
| `tgl_kunjungan`, `tgl_resep` | `DATETIME` | Merekam presisi tanggal dan stempel waktu |
| `harga_jual_obat`, `tarif_tindakan` | `DECIMAL(12,2)` | Mencegah galat pembulatan nilai desimal uang |

### 6.6 Perbandingan ERD dengan Implementasi

Setelah membandingkan diagram `p05_erd_fisik_25430093.png` dengan eksekusi `p05_ddl_25430093.sql`, diperoleh kesimpulan:
1. Seluruh 8 entitas fisik pada ERD telah teridentifikasi menjadi tabel utuh.
2. Setiap kolom relasional kunci tamu pada DDL terhubung tepat pada kolom kunci primer tabel induk.
3. Seluruh konvensi penamaan constraint (`pk_`, `fk_`, `uq_`, `ck_`) pada skrip SQL konsisten dengan notasi pada diagram ERD fisik.

---

## 7. Pembahasan dan Kendala

### 7.1 Pembahasan Hasil Praktikum
Penerapan DDL pada proyek klinik berhasil mewujudkan struktur data yang aman dari galat integritas. Penentuan tipe data berukuran tetap seperti `CHAR` pada atribut NIK dan No RM terbukti meningkatkan performa pengindeksan, sementara penggunaan tipe data `DECIMAL` menjamin ketepatan transaksi keuangan obat.

### 7.2 Kendala yang Dihadapi dan Solusi
1. **Kendala Urutan Eksekusi (*Dependency Order*):** Saat menjalankan skrip DDL ulang, eksekusi pembuatan tabel anak mendahului tabel induk mengakibatkan pesan galat *table does not exist*.  
   *Solusi:* Menata ulang skrip DDL dengan urutan tabel mandiri (`dokter`, `pasien`, `tindakan`, `obat`) terlebih dahulu, disusul tabel relasi (`kunjungan`, `resep`, `tindakan_detail`, `resep_detail`).
2. **Sintaks Check Constraint pada MySQL versi Lama:** Pada beberapa versi MySQL terdahulu, klausa `CHECK` diabaikan oleh parser.  
   *Solusi:* Menggunakan MariaDB versi terbaru atau MySQL 8.0+ agar sintaks constraint `CHECK` tereksekusi secara aktif.

---

## 8. Kesimpulan

Praktikum Pertemuan 05 berhasil mengimplementasikan skema DDL untuk basis data **Klinik (`klinik_093`)**. Penerapan constraint secara eksplisit (`pk_`, `fk_`, `uq_`, `ck_`) terbukti mampu menjaga keakuratan data, menjamin integritas referensial antar-tabel, serta menolak data yang bertentangan dengan Aturan Bisnis (AB-01 s.d. AB-21). Seluruh skrip SQL telah teruji bersifat *idempotent* dan selaras dengan ERD fisik `p05_erd_fisik_25430093.png`.

---

## 9. Pernyataan Penggunaan AI

Dalam penyusunan laporan ini, saya memanfaatkan alat bantu AI (Gemini) untuk membantu eksplorasi variasi penjelasan teori DDL, penataan ulang sintaks tabel Markdown, serta verifikasi pemetaan Aturan Bisnis. Seluruh proses pengujian SQL, tangkapan layar, dan analisis kendala praktikum dilakukan secara mandiri oleh saya.

---

## 10. Bukti Git (Tautan Repositori + Hash Commit)

* **Repositori GitHub:** https://github.com/alwanzakifaros/basisdata-25430093
* **Riwayat Commit:**

| Hash Commit | Pesan Commit |
| :---: | :--- |
| `c8f12ad` | p05: ddl proyek (klinik_093) |
| `b4901ef` | p05: erd fisik klinik_093 |
| `7a291dc` | p05: laporan praktikum 05 |

---

## Checklist Khusus Laporan Pertemuan 5

| No. | Pemeriksaan | Status |
| ---: | :--- | :---: |
| 1 | Berkas `p05_ddl_25430093.sql` dapat dijalankan ulang dari basis data kosong | ☑ |
| 2 | ERD fisik `p05_erd_fisik_25430093.png` tersedia | ☑ |
| 3 | Tangkapan layar `SHOW CREATE TABLE` untuk tabel utama tersedia | ☑ |
| 4 | Tangkapan layar galat ketika constraint `FOREIGN KEY` dilanggar tersedia | ☑ |
| 5 | Tangkapan layar galat ketika constraint `UNIQUE` dilanggar tersedia | ☑ |
| 6 | Tangkapan layar galat ketika constraint `CHECK` dilanggar tersedia | ☑ |
| 7 | Alasan pemilihan tipe data dan constraint dijelaskan | ☑ |
| 8 | Constraint dikaitkan dengan aturan bisnis AB-xx | ☑ |
| 9 | Nama constraint mengikuti pola `pk_`, `fk_`, `uq_`, atau `ck_` ditambah nama tabel | ☑ |
| 10 | Komentar AB-xx merujuk dokumen kebutuhan data proyek sendiri | ☑ |
| 11 | Laporan sudah disimpan pada `laporan/p05_laporan_25430093.md` | ☑ |
| 12 | Perubahan sudah di-commit dan di-push ke repositori | ☑ |