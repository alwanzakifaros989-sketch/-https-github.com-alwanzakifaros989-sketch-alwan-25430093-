# Laporan Praktikum Basis Data - Pertemuan 2

* **Nama:** Alwan Zaki Faros
* **NIM:** 25430093
* **Kelas:** S1 Ilmu Komputer
* **Tema Proyek:** Akademik (akad_093)

---

## 1. Berkas Wajib Pertemuan 2
Beberapa file pendukung untuk tugas pertemuan 2 yang sudah diselesaikan dan di-push ke GitHub meliputi:
1. `p02_kebutuhan_data_kopma_25430093.md` (Hasil analisis studi kasus Kopma)
2. `p02_kebutuhan_data_25430093.md` (Dokumen kebutuhan data untuk proyek individu sistem akademik)

---

## 2. Analisis Wajib

### A. Titik Analisis 1–3
1. **Titik Analisis 1 (Penyimpanan Harga pada Nota Penjualan):**
   Harga jual barang pada baris nota tetap harus disimpan langsung di tabel detail transaksi dan tidak boleh hanya mengandalkan relasi ke tabel barang. Hal ini karena harga barang di toko bersifat dinamis (bisa naik atau turun kapan saja). Jika nota tidak menyimpan harga pada saat transaksi berlangsung, maka perubahan harga barang di masa depan bakal merubah seluruh riwayat omzet dan laporan penjualan lama.

2. **Titik Analisis 2 (Pemisahan Nilai Turunan/Kalkulasi):**
   Atribut yang nilainya berupa hasil perhitungan (seperti subtotal, total bayar, atau IPK mahasiswa) tidak perlu disimpan permanen dalam tabel database operasional. Tujuannya untuk mencegah masalah redundansi dan ketidaksinkronan data (anomali) jika ada perubahan nilai dasar. Nilai-nilai turunan ini cukup dihitung secara langsung saat query dijalankan menggunakan fungsi agregat SQL seperti `SUM()` atau `AVG()`.

3. **Titik Analisis 3 (Perlindungan Data Pribadi):**
   Data yang bersifat sensitif seperti nomor telepon atau alamat rumah harus dikategorikan sebagai data terbatas. Pembatasan hak akses ini penting untuk menjaga kerahasiaan identitas pengguna serta memastikan sistem memenuhi kaidah keamanan data.

---

### B. Perhitungan Parameter P
Perhitungan parameter personal menyesuaikan dengan 2 digit terakhir NIM saya, yaitu **93**:
* **Rumus P:**  
  $$P = (93 \pmod 9) + 1 = 3 + 1 = 4$$
* **Batas maksimal item per transaksi ($P + 2$):** $4 + 2 =$ **6 item**
* **Nilai denda harian / persentase diskon ($P$):** **Rp4.000** / **4%**
* **Estimasi volume transaksi harian ($40 + 5 \times P$):** $40 + 5(4) =$ **60 transaksi/hari**

---

### C. Revisi Pernyataan Kebutuhan yang Masih Kabur
1. **Kalimat awal (Kabur):** "Data anggota harus aman"  
   * **Revisi (Spesifik & Terukur):** "Data nomor HP milik anggota disimpan menggunakan enkripsi database dan cuma bisa diakses oleh role Ketua Koperasi. Pihak kasir tidak diizinkan melihat data nomor HP pada tampilan antarmuka aplikasi."
2. **Kalimat awal (Kabur):** "Sistem harus cepat mencari barang"  
   * **Revisi (Spesifik & Terukur):** "Fitur pencarian data barang berdasarkan kode atau nama barang wajib menampilkan hasil di layar dalam durasi maksimal 2 detik untuk kapasitas hingga 10.000 record data."
3. **Kalimat awal (Kabur):** "Laporan stok harus akurat"  
   * **Revisi (Spesifik & Terukur):** "Nilai stok barang di basis data tidak boleh bernilai negatif ($\ge 0$) dan akan langsung berkurang secara otomatis sesuai jumlah barang yang dibeli saat transaksi berhasil disimpan."

---

## 3. Bukti Tangkapan Layar (Tampilan GitHub)

### A. Tampilan Tabel PB, AB, dan KI pada GitHub
![Tabel PB, AB, dan KI](p02_tabel_pb_ab_ki.png)

### B. Tampilan Matriks CRUD dan Kamus Data pada GitHub
![Matriks CRUD dan Kamus Data](p02_crud_kamus_data.png)