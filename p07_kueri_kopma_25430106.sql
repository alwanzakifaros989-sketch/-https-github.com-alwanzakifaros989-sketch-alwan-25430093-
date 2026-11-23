-- ============================================================================
-- PRAKTIKUM BASIS DATA - MODUL 7 (SELECT DAN FUNGSI SKALAR)
-- Kasus  : Koperasi Mahasiswa Sejahtera (Kopma)
-- NIM    : 25430093
-- Berkas : p07_kueri_kopma_25430093.sql
-- ============================================================================

USE kopma_093;

-- ----------------------------------------------------------------------------
-- D.1 Proyeksi dan Penyaringan
-- ----------------------------------------------------------------------------

-- KI-03: Identifikasi barang yang stoknya berada di bawah batas minimum
-- Harapan: Memunculkan daftar barang beserta selisih unit yang perlu dipesan ulang
SELECT kode_barang,
       nama_barang,
       stok_barang,
       stok_min_barang,
       (stok_min_barang - stok_barang) AS defisit_stok
FROM barang
WHERE stok_barang < stok_min_barang
ORDER BY defisit_stok DESC;

-- Penyaringan IN: Menampilkan barang dalam kategori ATK atau minuman
-- Harapan: Memunculkan barang yang tergolong ATK maupun minuman
SELECT kode_barang,
       nama_barang,
       kategori_barang,
       harga_jual_barang
FROM barang
WHERE kategori_barang IN ('ATK', 'minuman')
ORDER BY kategori_barang ASC, harga_jual_barang ASC;

-- Penyaringan BETWEEN: Menampilkan transaksi penjualan sepanjang September 2026
-- Harapan: Memunculkan nota penjualan dengan tanggal-jam antara 1 s.d. 30 September 2026
SELECT no_nota_penjualan,
       tgl_penjualan,
       id_petugas,
       id_anggota,
       bayar_penjualan
FROM penjualan
WHERE tgl_penjualan BETWEEN '2026-09-01 00:00:00' AND '2026-09-30 23:59:59'
ORDER BY tgl_penjualan ASC;

-- Penyaringan IS NULL: Menampilkan anggota yang belum memiliki data nomor HP
-- Harapan: Memunculkan baris anggota dengan no_hp_anggota kosong (NULL)
SELECT no_anggota,
       nim_anggota,
       nama_anggota,
       prodi_anggota,
       status_anggota
FROM anggota
WHERE no_hp_anggota IS NULL
ORDER BY no_anggota ASC;

-- ----------------------------------------------------------------------------
-- D.2 Pola Teks dan Nilai Kosong
-- ----------------------------------------------------------------------------

-- Pencarian LIKE + fungsi skalar string, tanggal, IFNULL, dan CASE
-- Harapan: Menampilkan hingga 5 anggota terbaru yang namanya memuat huruf 'a'
--          dengan label gabungan, tanggal format DD-MM-YYYY, pengganti '-', dan status diskon
SELECT CONCAT(nama_anggota, ' (', no_anggota, ')') AS profil_anggota,
       DATE_FORMAT(tgl_daftar_anggota, '%d-%m-%Y') AS tgl_registrasi,
       IFNULL(no_hp_anggota, '-') AS nomor_kontak,
       CASE status_anggota
           WHEN 'aktif' THEN 'Diskon 5%'
           ELSE 'Tanpa diskon'
       END AS hak_diskon
FROM anggota
WHERE nama_anggota LIKE '%a%'
ORDER BY tgl_daftar_anggota DESC
LIMIT 5;

-- ----------------------------------------------------------------------------
-- D.3 Tanggal dan Perhitungan per Baris
-- ----------------------------------------------------------------------------

-- Durasi keanggotaan dalam hari dan klasifikasi keanggotaan ('baru' < 180 hari)
-- Harapan: Menampilkan lama hari sejak tanggal daftar hingga CURDATE() serta kategorinya
SELECT no_anggota,
       nama_anggota,
       tgl_daftar_anggota,
       DATEDIFF(CURDATE(), tgl_daftar_anggota) AS umur_hari,
       IF(DATEDIFF(CURDATE(), tgl_daftar_anggota) < 180, 'baru', 'lama') AS kelompok_anggota
FROM anggota
ORDER BY umur_hari ASC;

-- Rincian item dan subtotal per baris pada nota pertama (id_penjualan = 1)
-- Harapan: Menampilkan setiap item pada nota id_penjualan = 1 beserta hasil kali qty * harga
SELECT id_penjualan,
       id_barang,
       qty_detail_penjualan,
       harga_satuan_detail_penjualan,
       (qty_detail_penjualan * harga_satuan_detail_penjualan) AS subtotal_baris
FROM detail_penjualan
WHERE id_penjualan = 1;

-- ----------------------------------------------------------------------------
-- E. Latihan dan Modifikasi
-- ----------------------------------------------------------------------------

-- E.1 Nama barang kapital dan format Rupiah
SELECT kode_barang,
       UPPER(nama_barang) AS nama_kapital,
       CONCAT('Rp', FORMAT(harga_jual_barang, 0, 'id_ID')) AS harga_rupiah
FROM barang
ORDER BY kode_barang ASC;

-- E.2 Perbaikan logika OR dengan tanda kurung pada penyaringan kategori dan harga
SELECT kode_barang,
       nama_barang,
       kategori_barang,
       harga_jual_barang
FROM barang
WHERE (kategori_barang = 'ATK' OR kategori_barang = 'minuman')
  AND harga_jual_barang > 4000;