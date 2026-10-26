# Dokumen Normalisasi dan Skema Relasional Proyek

---

## 1. Bentuk Tidak Normal (Unnormalized Form - UNF)

Bentuk mentah dokumen rekam medis atau kuitansi kunjungan pasien masih memiliki kelompok atribut berulang untuk resep obat.

```text
DOKUMEN_KLINIK_UNF (
    no_kunjungan, tgl_kunjungan, no_rekam_medis, nama_pasien, tgl_lahir_pasien,
    alamat_pasien, no_hp_pasien, kode_dokter, nama_dokter, spesialisasi_dokter,
    keluhan_utama,
    { kode_obat, nama_obat, qty_resep, aturan_pakai, harga_satuan_obat },
    total_biaya_kunjungan
)
```

---

## 2. Aturan Dependensi Fungsional (Functional Dependency - FD)

Dependensi fungsional berikut diturunkan dari aturan bisnis layanan klinik.

| ID | Penentu (determinant) | Atribut yang ditentukan | Keterangan |
| --- | --- | --- | --- |
| FD1 | `no_kunjungan` | `tgl_kunjungan`, `no_rekam_medis`, `kode_dokter`, `keluhan_utama` | Data utama kunjungan |
| FD2 | `no_rekam_medis` | `nama_pasien`, `tgl_lahir_pasien`, `alamat_pasien`, `no_hp_pasien` | Data pasien |
| FD3 | `kode_dokter` | `nama_dokter`, `spesialisasi_dokter` | Data dokter |
| FD4 | `kode_obat` | `nama_obat`, `harga_satuan_obat` | Data master obat |
| FD5 | (`no_kunjungan`, `kode_obat`) | `qty_resep`, `aturan_pakai`, `harga_satuan_resep` | Data item resep; harga disimpan sebagai harga historis |
| FD6 | (`qty_resep`, `harga_satuan_resep`) | `subtotal_resep` | Nilai turunan, dihitung dari jumlah dikali harga satuan |

---

## 3. Tahapan Normalisasi (UNF hingga 3NF)

### UNF

| Relasi | Struktur dan kondisi |
| --- | --- |
| `DOKUMEN_KLINIK_UNF` | Memuat data kunjungan, pasien, dokter, resep, dan total biaya dalam satu dokumen. Atribut resep obat masih berupa grup berulang. |

### 1NF

| Relasi | Kunci utama | Atribut lainnya | Keterangan |
| --- | --- | --- | --- |
| `KUNJUNGAN_1NF` | (`no_kunjungan`, `kode_obat`) | `tgl_kunjungan`, `no_rekam_medis`, `nama_pasien`, `tgl_lahir_pasien`, `alamat_pasien`, `no_hp_pasien`, `kode_dokter`, `nama_dokter`, `spesialisasi_dokter`, `keluhan_utama`, `qty_resep`, `aturan_pakai`, `harga_satuan_resep`, `total_biaya_kunjungan` | Grup berulang diuraikan menjadi baris; setiap baris mewakili satu obat pada kunjungan. |

### 2NF

| Relasi | Kunci utama | Atribut lainnya | Keterangan |
| --- | --- | --- | --- |
| `KUNJUNGAN_HEADER` | `no_kunjungan` | `tgl_kunjungan`, `no_rekam_medis`, `nama_pasien`, `tgl_lahir_pasien`, `alamat_pasien`, `no_hp_pasien`, `kode_dokter`, `nama_dokter`, `spesialisasi_dokter`, `keluhan_utama` | Memisahkan atribut yang bergantung hanya pada `no_kunjungan`. |
| `RESEP_DETAIL` | (`no_kunjungan`, `kode_obat`) | `qty_resep`, `aturan_pakai`, `harga_satuan_resep` | Atribut resep bergantung pada seluruh kunci komposit. |
| `OBAT_MASTER` | `kode_obat` | `nama_obat`, `harga_satuan_obat` | Memisahkan atribut yang bergantung pada kode obat. |

### 3NF

| Relasi | Kunci utama | Kunci asing | Atribut lainnya | Keterangan |
| --- | --- | --- | --- | --- |
| `pasien` | `id_pasien` | - | `no_rekam_medis` (unik), `nama_pasien`, `tgl_lahir_pasien`, `alamat_pasien`, `no_hp_pasien` | Data pasien dipisahkan dari data kunjungan. |
| `dokter` | `id_dokter` | - | `kode_dokter` (unik), `nama_dokter`, `spesialisasi_dokter` | Data dokter dipisahkan dari data kunjungan. |
| `obat` | `id_obat` | - | `kode_obat` (unik), `nama_obat`, `harga_jual_obat`, `stok_obat` | Katalog obat menggunakan surrogate key. |
| `kunjungan` | `id_kunjungan` | `id_pasien`, `id_dokter` | `no_kunjungan` (unik), `tgl_kunjungan`, `keluhan_utama` | Header transaksi; total biaya tidak disimpan karena merupakan nilai turunan. |
| `detail_resep` | (`id_kunjungan`, `id_obat`) | `id_kunjungan`, `id_obat` | `qty_resep`, `aturan_pakai`, `harga_satuan_resep` | Tabel asosiatif resep yang menyimpan harga historis. |

---

## 4. Evaluasi BCNF (Boyce-Codd Normal Form)

Setiap entitas hasil normalisasi 3NF di atas dinyatakan memenuhi BCNF karena setiap penentu pada dependensi fungsional nontrivial di dalam entitas merupakan kunci kandidat.

---

## 5. Pengelolaan Nilai Turunan

| Nilai | Disimpan? | Cara memperoleh |
| --- | --- | --- |
| `subtotal_resep` | Tidak | Dihitung dari `qty_resep * harga_satuan_resep`. |
| `total_biaya_kunjungan` | Tidak | Dihitung dengan agregasi `SUM(qty_resep * harga_satuan_resep)` dari `detail_resep` untuk menghindari anomali pembaruan pada OLTP. |

---

## 6. Data Historis dan Aturan Parameter P

| Aspek | Aturan |
| --- | --- |
| Harga historis | `harga_satuan_resep` disimpan di `detail_resep` agar perubahan harga master obat tidak mengubah rekam medis sebelumnya. |
| Batas item resep | Dengan `P = 4`, batas maksimum item resep obat per kunjungan adalah `P + 2 = 6` item. |
