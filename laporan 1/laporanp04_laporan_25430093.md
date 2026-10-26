# Laporan Praktikum Basis Data - Pertemuan 04

**Nama:** Alwan Zaki Faros  
**NPM:** 25430093  
**Kelas:** D  
**Tanggal:** 26 Oktober 2026  
**Dosen:** Dedi Irawan, S.Kom., M.Kom.  
**Domain Proyek Mandiri:** Klinik (`klinik_093`)  
**Parameter P:** 4 ($P = (93 \bmod 9) + 1 = 3 + 1 = 4$)  

---

## 1. Tujuan Praktikum

Tujuan pelaksanaan praktikum pada Pertemuan 4 ini meliputi:

1. Mengidentifikasi dan menganalisis potensi anomali data (penyisipan, pengubahan, penghapusan) pada struktur relasi yang belum ternormalisasi (UNF).
2. Merumuskan aturan Dependensi Fungsional (*Functional Dependency* - FD) secara mandiri berdasarkan Aturan Bisnis (AB) operasional Klinik.
3. Melakukan tahapan perancangan skema terstruktur melalui tahapan normalisasi UNF, 1NF, 2NF, hingga 3NF.
4. Mengevaluasi hasil perancangan skema relasional terhadap kriteria *Boyce-Codd Normal Form* (BCNF).
5. Menganalisis serta mengambil keputusan teknis terkait penanganan nilai turunan (*derived attributes*) dan data historis transaksi medis.
6. Mengimplementasikan hasil analisis normalisasi secara mandiri pada domain proyek **Klinik (`klinik_093`)** dan menyusun berkas milestone `p04_normalisasi_25430093.md`.

---

## 2. Ringkasan Dasar Teori

Normalisasi basis data merupakan metodologi analitis untuk mengorganisasi atribut-atribut dalam tabel relasional guna meminimalkan redundansi data dan mencegah timbulnya anomali transaksi saat manipulasi data (*Online Transaction Processing* - OLTP).

### 2.1 Anomali pada Skema Unnormalized Form (UNF)

| Jenis Anomali | Dampak Struktural pada Proyek Klinik |
|---|---|
| **Anomali Penyisipan (*Insertion Anomaly*)** | Data obat baru atau data dokter baru tidak dapat dimasukkan ke dalam basis data sebelum ada transaksi kunjungan berobat dari pasien. |
| **Anomali Perubahan (*Update Anomaly*)** | Perubahan spesialisasi dokter atau tarif obat memicu pembaruan berulang (*redundant updates*) pada banyak baris rekam medis kunjungan. |
| **Anomali Penghapusan (*Deletion Anomaly*)** | Penghapusan satu-satunya rekam medis kunjungan pasien berakibat terhapusnya data master obat atau data master dokter secara permanen dari sistem. |

### 2.2 Hirarki Tahapan Normalisasi

- **UNF (*Unnormalized Form*):** Data mentah rekam medis/kuitansi klinik yang mengandung kelompok berulang (*repeating groups*) pada daftar obat resep.
- **1NF (*First Normal Form*):** Menghilangkan *repeating groups*, memastikan seluruh atribut bersifat atomik, serta menetapkan kunci komposit (`no_kunjungan`, `kode_obat`).
- **2NF (*Second Normal Form*):** Memenuhi 1NF dan mengeliminasi Ketergantungan Parsial (*Partial Dependency*), di mana atribut non-kunci harus bergantung sepenuhnya (*full functional dependency*) pada seluruh kunci komposit.
- **3NF (*Third Normal Form*):** Memenuhi 2NF dan mengeliminasi Ketergantungan Transitif (*Transitive Dependency*), di mana atribut non-kunci tidak boleh bergantung pada atribut non-kunci lainnya.
- **BCNF (*Boyce-Codd Normal Form*):** Memenuhi 3NF dengan syarat tambahan bahwa seluruh penentu (*determinant*) dari dependensi fungsional nontrivial harus berupa *superkey* / kunci kandidat.

---

## 3. Hasil Langkah Percobaan (Kasus Demo Kopma)

Pada bagian percobaan modul, dilakukan analisis perancangan normalisasi pada domain transaksi Koperasi Mahasiswa (Kopma) untuk memahami tahapan transformasi dari bentuk tidak terstruktur hingga skema kanonik.

### 3.1 Identifikasi UNF dan Transformasi 1NF
Data mentah nota transaksi Kopma dikelompokkan ke dalam bentuk tunggal (1NF) dengan menghilangkan grup atribut berulang pada detail barang yang dibeli, serta membentuk *composite primary key*.

![UNF ke 1NF Kopma](img/Mengubah%20UNF%20menjadi%201NF.png)

### 3.2 Menentukan Dependensi Fungsional

Ketergantungan fungsional ditentukan berdasarkan aturan bisnis, bukan hanya dari kebetulan nilai yang terlihat pada data. Penentuan ini membantu mengetahui atribut yang bergantung pada suatu kunci.

| Contoh Penentu | Atribut yang Ditentukan | Makna |
|---|---|---|
| `kode_barang` | Atribut barang yang ditentukan oleh kode tersebut | Satu kode barang mengidentifikasi data barang yang sesuai. |
| `kode_petugas` | Atribut petugas yang ditentukan oleh kode tersebut | Data petugas dapat dikelola melalui kode petugas. |
| `no_nota_penjualan` | Informasi transaksi penjualan | Nomor nota mengidentifikasi transaksi penjualan. |

![Menentukan Dependensi Fungsional](img/Menentukan%20Dependensi%20Fungsional.png)

### 3.3 Mengubah 1NF menjadi 2NF

Bentuk 2NF mensyaratkan relasi sudah memenuhi 1NF dan tidak memiliki ketergantungan parsial (partial dependency), yaitu atribut non-kunci yang hanya bergantung pada sebagian dari kunci komposit. Atribut yang hanya bergantung pada `no_nota_penjualan` dipisahkan ke tabel `PENJUALAN`, sedangkan atribut yang hanya bergantung pada `kode_barang` dipisahkan ke tabel `BARANG`.

![2NF Kopma](../img/p04_2NF.png)

### 3.4 Mengubah 2NF menjadi 3NF

Bentuk 3NF mengeliminasi ketergantungan transitif (transitive dependency), yaitu ketergantungan atribut non-kunci pada atribut non-kunci lainnya. Pada tabel `PENJUALAN`, atribut `nama_petugas` bergantung pada `kode_petugas`, dan `nama_anggota` bergantung pada `no_anggota`. Oleh karena itu, data petugas dan anggota dipisahkan ke dalam entitas tersendiri (`PETUGAS` dan `ANGGOTA`).

![Mengubah 2NF menjadi 3NF](img/Mengubah%202NF%20menjadi%203NF.png)

### 3.5 Mencocokkan dengan Skema Kanonik dan Pemeriksaan BCNF

Relasi hasil 3NF kemudian dicocokkan dengan skema kanonik Kopma yang menerapkan *surrogate key* (`id_*`) sebagai kunci primer internal. Setiap penentu (*determinant*) pada dependensi fungsional nontrivial diperiksa untuk memastikan bahwa seluruh penentu merupakan kandidat kunci guna memenuhi kriteria Boyce-Codd Normal Form (BCNF).

![Perbandingan Hasil 3NF dengan Skema Kanonik](img/Perbandingan%20Hasil%203NF%20dengan%20Skema%20Kanonik.png)
![Pemeriksaan BCNF](img/Pemeriksaan%20BCNF.png)

### 3.6 Menentukan Nilai Turunan

Nilai turunan seperti `subtotal_detail_penjualan`, `jumlah_penjualan`, dan `total_penjualan` dievaluasi apakah perlu disimpan atau tidak di basis data OLTP. Berdasarkan prinsip normalisasi, nilai turunan ini tidak disimpan secara fisik di tabel operasional untuk mencegah anomali pembaruan dan menghemat memori, melainkan dihitung secara dinamis melalui kueri.

![Menentukan Nilai Turunan](img/Menentukan%20Nilai%20Turunan.png)

---

## 4. Jawaban Titik Analisis

### 4.1 Mengapa Dependensi Fungsional Harus Didasarkan Aturan Bisnis?
Dependensi Fungsional (FD) tidak boleh ditarik sekadar dari observasi sampel data sementara yang tertera pada tabel, melainkan harus merefleksikan Aturan Bisnis (AB) domain secara nyata. Sampel data bersifat temporer dan dapat secara kebetulan terlihat unik atau dependen, sedangkan aturan bisnis menjamin integritas data dalam jangka panjang untuk seluruh kasus operasional klinik.

### 4.2 Strategi Penanganan Nilai Turunan vs Data Historis Transaksi
- **Nilai Turunan (*Subtotal Resep / Total Biaya Kunjungan*):** **TIDAK DISIMPAN** secara fisik di tabel operasional basis data OLTP. Nilai ini direkonstruksi secara dinamis menggunakan ekspresi matematika `qty_resep * harga_satuan_resep` atau agregasi `SUM()` pada kueri SELECT. Strategi ini mencegah timbulnya anomali ketidaksinkronan data (*data inconsistency*).
- **Data Historis (*Harga Satuan Resep Obat*):** **WAJIB DISIMPAN** secara fisik pada tabel detail transaksi (`detail_resep`). Langkah ini bertindak sebagai *snapshot* harga pada saat transaksi pemeriksaan dilakukan, sehingga penyesuaian harga obat pada katalog master di masa depan tidak merusak histori keuangan rekam medis pasien di masa lalu.

### 4.3 Analisis Atribut Pemasok pada Katalog Barang
Atribut `pemasok_brg` tidak boleh dicatat langsung pada entitas `barang` karena satu barang bisa disuplai oleh berbagai pemasok atau terjadi perubahan pemasok secara berkala. Hubungan entitas pemasok dikelola secara terpisah melalui tabel transaksi pembelian (`pembelian` dan `detail_pembelian`) dengan mengacu pada `id_pemasok`.

---

## 5. Hasil Latihan dan Modifikasi (Modul)

### 5.1 Penanganan Multi-Nomor Telepon Pemasok
Apabila entitas `pemasok` memiliki lebih dari satu nomor kontak, penerapan bentuk 1NF mewajibkan pemisahan atribut tersebut ke tabel relasional tersendiri:

```text
pemasok ( id_pemasok [PK], nama_pemasok, alamat )
telepon_pemasok ( id_pemasok [PK, FK], no_telepon [PK] )
```

### 5.2 Dampak Redundansi Identitas Anggota pada Transaksi
Penyimpanan langsung atribut `nama_anggota` pada tabel `penjualan` memicu anomali perubahan. Apabila nama anggota diperbarui, seluruh riwayat transaksi penjualan milik anggota tersebut harus di-update satu per satu. Solusi yang tepat adalah menyimpan `id_anggota` sebagai *Foreign Key* pada tabel `penjualan`.

---

## 6. Tugas Mandiri: Milestone Proyek 4 (Sistem Klinik `klinik_093`)

### 6.1 Deskripsi Aturan Bisnis & Formulasi UNF
Proyek dikembangkan untuk domain **Klinik (`klinik_093`)** oleh **Alwan Zaki Faros (NPM: 25430093)**. Dengan parameter $P = 4$, ditentukan konstrain bahwa maksimal item resep obat dalam satu transaksi kunjungan adalah $P + 2 = 6$ item obat.

Dokumen sumber mentah (UNF) rekam medis kunjungan berobat:
```text
DOKUMEN_KLINIK_UNF (
    no_kunjungan, tgl_kunjungan, no_rekam_medis, nama_pasien, tgl_lahir_pasien, 
    alamat_pasien, no_hp_pasien, kode_dokter, nama_dokter, spesialisasi_dokter, 
    keluhan_utama, 
    { kode_obat, nama_obat, qty_resep, aturan_pakai, harga_satuan_obat }, 
    total_biaya_kunjungan
)
```

### 6.2 Deklarasi Dependensi Fungsional (FD) Mandiri
1. **FD1 (Entitas Pasien):** `no_rekam_medis` $\rightarrow$ `nama_pasien`, `tgl_lahir_pasien`, `alamat_pasien`, `no_hp_pasien`
2. **FD2 (Entitas Dokter):** `kode_dokter` $\rightarrow$ `nama_dokter`, `spesialisasi_dokter`
3. **FD3 (Entitas Obat):** `kode_obat` $\rightarrow$ `nama_obat`, `harga_satuan_obat`
4. **FD4 (Header Kunjungan):** `no_kunjungan` $\rightarrow$ `tgl_kunjungan`, `no_rekam_medis`, `kode_dokter`, `keluhan_utama`
5. **FD5 (Detail Resep Transaksi):** (`no_kunjungan`, `kode_obat`) $\rightarrow$ `qty_resep`, `aturan_pakai`, `harga_satuan_resep`
6. **FD6 (Nilai Turunan - Calculated):** (`qty_resep`, `harga_satuan_resep`) $\rightarrow$ `subtotal_resep` *(Dihitung via Query)*

### 6.3 Tabel Tahapan Normalisasi Mandiri (UNF $\rightarrow$ 1NF $\rightarrow$ 2NF $\rightarrow$ 3NF)

| Tahapan Normalisasi | Entitas / Tabel | Atribut Utama & Relasi | Keputusan Perancangan & Solusi Anomali |
|---|---|---|---|
| **UNF** | `DOKUMEN_KLINIK_UNF` | `no_kunjungan`, `tgl_kunjungan`, `no_rekam_medis`, `nama_pasien`, `tgl_lahir_pasien`, `alamat_pasien`, `no_hp_pasien`, `kode_dokter`, `nama_dokter`, `spesialisasi_dokter`, `keluhan_utama`, { `kode_obat`, `nama_obat`, `qty_resep`, `aturan_pakai`, `harga_satuan_obat` }, `total_biaya_kunjungan` | Mengandung kelompok berulang (*repeating groups*) resep obat. Berpotensi tinggi memicu anomali transaksi. |
| **1NF** | `KUNJUNGAN_1NF` | **`no_kunjungan`**, **`kode_obat`**, `tgl_kunjungan`, `no_rekam_medis`, `nama_pasien`, `tgl_lahir_pasien`, `alamat_pasien`, `no_hp_pasien`, `kode_dokter`, `nama_dokter`, `spesialisasi_dokter`, `keluhan_utama`, `qty_resep`, `aturan_pakai`, `harga_satuan_resep`, `total_biaya_kunjungan` | Menghilangkan grup berulang sehingga setiap sel bersifat atomik. Kunci primer komposit ditentukan pada (`no_kunjungan`, `kode_obat`). |
| **2NF** | `KUNJUNGAN_HEADER` | **`no_kunjungan`**, `tgl_kunjungan`, `no_rekam_medis`, `nama_pasien`, `tgl_lahir_pasien`, `alamat_pasien`, `no_hp_pasien`, `kode_dokter`, `nama_dokter`, `spesialisasi_dokter`, `keluhan_utama` | Mengeliminasi Ketergantungan Parsial pada atribut header kunjungan. |
| **2NF** | `RESEP_DETAIL` | **`no_kunjungan`***, **`kode_obat`***, `qty_resep`, `aturan_pakai`, `harga_satuan_resep` | Memisahkan atribut yang bergantung penuh pada kunci komposit. Menyimpan harga historis resep. |
| **2NF** | `OBAT_MASTER` | **`kode_obat`**, `nama_obat`, `harga_satuan_obat` | Memisahkan katalog obat dari transaksi kunjungan. |
| **3NF / BCNF** | `pasien` | **`id_pasien`** (PK), `no_rekam_medis` (UQ), `nama_pasien`, `tgl_lahir_pasien`, `alamat_pasien`, `no_hp_pasien` | Mengeliminasi ketergantungan transitif. Menerapkan *Surrogate Key* integer. |
| **3NF / BCNF** | `dokter` | **`id_dokter`** (PK), `kode_dokter` (UQ), `nama_dokter`, `spesialisasi_dokter` | Memisahkan master dokter dengan *Surrogate Key*. |
| **3NF / BCNF** | `obat` | **`id_obat`** (PK), `kode_obat` (UQ), `nama_obat`, `harga_jual_obat`, `stok_obat` | Master obat terpisah penuh dengan *Surrogate Key*. |
| **3NF / BCNF** | `kunjungan` | **`id_kunjungan`** (PK), `no_kunjungan` (UQ), `tgl_kunjungan`, `id_pasien`* (FK), `id_dokter`* (FK), `keluhan_utama` | Header rekam medis transaksi. Atribut turunan `total_biaya_kunjungan` dihapus. |
| **3NF / BCNF** | `detail_resep` | **`id_kunjungan`*** (PK, FK), **`id_obat`*** (PK, FK), `qty_resep`, `aturan_pakai`, `harga_satuan_resep` | Tabel penghubung (*junction table*) resep obat. Menyimpan harga historis obat saat transaksi. |

### 6.4 Nilai Turunan dan Catatan Normalisasi

1. **Penanganan Nilai Turunan (*Calculated Values*):**
   - Atribut `subtotal_resep` dan `total_biaya_kunjungan` dihapus secara eksplisit dari tabel fisik operasional basis data OLTP Klinik.
   - Nilai subtotal diperoleh dinamis saat kueri dijalankan melalui ekspresi: `qty_resep * harga_satuan_resep`.
   - Total biaya kunjungan dihitung dinamis menggunakan fungsi agregasi `SUM()` pada tabel `detail_resep`.

2. **Penyimpanan Harga Historis (*Historical Price*):**
   - `harga_satuan_resep` **tetap disimpan** di dalam tabel `detail_resep` sebagai nilai historis transaksi untuk menjamin rekam medis tidak berubah apabila harga obat pada tabel `obat` mengalami penyesuaian di masa depan.

3. **Restriksi Parameter P ($P = 4$):**
   - Transaksi kunjungan dibatasi secara eksplisit maksimal menampung $P + 2 = 6$ item obat dalam satu kuitansi/resep untuk menjaga performa kueri dan konsistensi input data.

---

## 7. Pembahasan dan Kendala

### 7.1 Pembahasan
Proses normalisasi pada proyek Klinik (`klinik_093`) membuktikan bahwa transformasi skema dari UNF menuju 3NF/BCNF berhasil memecah struktur data kompleks menjadi 5 entitas relasional yang independen. Penggunaan *Surrogate Key* (`id_*`) mempermudah pengelolaan relasi *Foreign Key* antar tabel, sementara penggunaan *Natural Key* (`no_kunjungan`, `no_rekam_medis`) dipertahankan sebagai *Unique Key* untuk kebutuhan integritas data bisnis.

### 7.2 Kendala yang Dihadapi & Solusi
- **Kendala:** Membedakan antara atribut yang harus disimpan secara historis dengan atribut turunan yang harus dihitung ulang.
- **Solusi:** Kolom `harga_satuan_resep` ditetapkan untuk tetap disimpan pada tabel transaksi `detail_resep` sebagai nilai historis, sedangkan `subtotal_resep` dan `total_biaya_kunjungan` dihapus dari tabel operasional karena bersifat terhitung dinamis.

---

## 8. Kesimpulan

1. Normalisasi terbukti efektif dalam mengeliminasi anomali penyisipan, perubahan, dan penghapusan data pada sistem basis data OLTP Klinik.
2. Skema terdekomposisi hingga tahap 3NF/BCNF menghasilkan 5 entitas utama (`pasien`, `dokter`, `obat`, `kunjungan`, `detail_resep`) yang bebas dari ketergantungan parsial maupun transitif.
3. Penerapan parameter $P = 4$ memberikan konstrain eksplisit yaitu maksimal 6 item resep obat per transaksi kunjungan pasien.
4. Berkas wajib milestone `p04_normalisasi_25430093.md` telah diselesaikan secara independen dan terintegrasi penuh.

---

## 9. Pernyataan Penggunaan AI

Dalam penyusunan laporan dan analisis dokumen normalisasi ini, saya menggunakan alat bantu AI (Gemini / ChatGPT) untuk merapikan sintaks Markdown, menyelaraskan format tabel, serta memverifikasi kaidah dependensi fungsional. Seluruh keputusan desain skema, perhitungan parameter $P = 4$, serta penyesuaian Aturan Bisnis Klinik diperiksa dan dikerjakan secara mandiri.

---

## 10. Bukti Git

| Atribut Bukti | Detail Eksekusi |
|---|---|
| **Nama Repositori** | `basisdata-25430093` |
| **Berkas Wajib Milestone Proyek** | `p04_normalisasi_25430093.md` |
| **Berkas Laporan Praktikum** | `laporan/p04_laporan_25430093.md` |
| **Pesan Commit** | `p04: laporan praktikum normalisasi proyek klinik 25430093` |
| **Tautan Repositori GitHub** | `https://github.com/alwan25430093/basisdata-25430093` |

---

## Checklist Pemenuhan Laporan Pertemuan 4

| Cek | Unsur Evaluasi | Status Keterisian |
|---|---|---|
| ☑ | **Berkas Wajib:** `p04_normalisasi_25430093.md` (proyek) | TERSEDIA & DISUSUN |
| ☑ | **Analisis Wajib:** Daftar Dependensi Fungsional (FD) Mandiri | LENGKAP (FD1 - FD6) |
| ☑ | **Analisis Wajib:** Keputusan Menyimpan/Menghitung Nilai Turunan | LENGKAP & DETAIL |
| ☑ | **Tabel Normalisasi:** UNF $\rightarrow$ 1NF $\rightarrow$ 2NF $\rightarrow$ 3NF | LENGKAP BERSTRUKTUR |
| ☑ | Identitas & Parameter P Mandiri ($P = 4$, NPM 25430093, Klinik) | VALID & TEPAT |
| ☑ | Bukti Git & Pernyataan Keaslian AI | TERISI DENGAN COMMIT |