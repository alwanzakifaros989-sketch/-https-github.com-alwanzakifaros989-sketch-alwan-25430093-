-- ============================================================
-- p06_data_kopma_25430093.sql
-- Nama : Alwan Zaki Faros
-- NPM  : 25430093
-- Kelas: Ilmu Komputer D
-- Modul 6: Mengisi, Mengubah, dan Menguji Data dengan DML
-- ============================================================

USE kopma_093;

-- Mengosongkan data lama dari anak ke induk agar tidak melanggar FK
DELETE FROM detail_penjualan;
DELETE FROM penjualan;
DELETE FROM anggota_arsip;
DELETE FROM anggota;
DELETE FROM barang;
DELETE FROM petugas;
DELETE FROM pemasok;

-- 1. Mengisi Data Induk Petugas
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
  ('K01', 'Dimas', 'kasir'),
  ('K02', 'Sari', 'kasir'), 
  ('K03', 'Rina', 'kasir'),
  ('G01', 'Joko', 'gudang'),
  ('P01', 'Ketua Kopma', 'ketua');

-- 2. Mengisi Data Induk Barang
INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang) VALUES
  ('ATK-001', 'Pulpen Gel 0.5', 'ATK', 4000, 120, 20),
  ('ATK-002', 'Buku Tulis 58', 'ATK', 6500, 80, 20),
  ('MNM-001', 'Air Mineral 600', 'minuman', 4000, 48, 24),
  ('MKN-001', 'Roti Cokelat', 'makanan', 5000, 6, 10);

-- 3. Mengisi Data Induk Anggota (Data Utama Menggunakan NIM 25430093)
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota) VALUES
  ('A01', '25430093', 'Alwan Zaki Faros', 'Ilmu Komputer', '081234567890', 'aktif', '2026-01-01'),
  ('A02', '25430094', 'Aldo', 'Ilmu Komputer', '081234567891', 'aktif', '2026-01-02'),
  ('A03', '25430095', 'Budi S', 'Sistem Informasi', '081234567892', 'nonaktif', '2024-05-20'),
  ('A04', '25430096', 'Citra', 'Pendidikan Matematika', '081234567893', 'aktif', '2026-01-04');

-- 4. Mengisi Data Induk Pemasok
INSERT INTO pemasok (nama_pemasok, telepon_pemasok, alamat_pemasok) VALUES
  ('PT. Jaya Abadi', '081011111111', 'Jl. AH Nasution, Metro'),
  ('CV. Makmur Sejahtera', '081022222222', 'Jl. Pekalongan');

-- 5. Mencatat Transaksi Penjualan Pertama (Nota PJ-2609-0142)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES 
  ('PJ-2609-0142', '2026-09-24 10:15:00', 3, 1, 30000);

-- Mengisi Detail Penjualan Secara Dinamis Menggunakan Subquery
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 
    (SELECT id_penjualan FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0142'), 
    id_barang, 3, harga_jual_barang
FROM barang WHERE kode_barang = 'ATK-001';

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 
    (SELECT id_penjualan FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0142'), 
    id_barang, 1, harga_jual_barang
FROM barang WHERE kode_barang = 'ATK-002';

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 
    (SELECT id_penjualan FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0142'), 
    id_barang, 2, harga_jual_barang
FROM barang WHERE kode_barang = 'MNM-001';

-- Mengurangi Stok Barang Setelah Penjualan
UPDATE barang SET stok_barang = stok_barang - 3 WHERE kode_barang = 'ATK-001';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'ATK-002';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'MNM-001';

-- 6. Percobaan Update Mode Aman
SET SESSION sql_safe_updates = 1;

-- Update Menaikkan Harga ATK sebesar 10% (Diterima karena menggunakan WHERE berbasis Primary Key)
UPDATE barang 
SET harga_jual_barang = harga_jual_barang * 1.1
WHERE kategori_barang = 'ATK' AND id_barang > 0;

-- 7. Percobaan Hapus Permanen / ON DELETE CASCADE
-- Memasukkan Nota Penjualan Kedua
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
  ('PJ-2609-0143', '2026-09-24 11:00:00', 3, 1, 10000);

-- Memasukkan Barang ke Nota Kedua
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT
    (SELECT id_penjualan FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0143'),
    id_barang, 1, harga_jual_barang
FROM barang WHERE kode_barang = 'ATK-001';

-- Menghapus Nota Kedua (Membuktikan Detail Penjualan Otomatis Terhapus via CASCADE)
DELETE FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0143';

-- Memeriksa Apakah Detail Penjualan Nota Kedua Ikut Terhapus
SELECT * FROM detail_penjualan
WHERE id_penjualan NOT IN (SELECT id_penjualan FROM penjualan);

-- 8. Latihan Modifikasi: Pengarsipan Data Anggota Nonaktif
CREATE TABLE IF NOT EXISTS anggota_arsip LIKE anggota;

-- Menyalin Data Anggota Nonaktif yang Mendaftar Sebelum 2025
INSERT INTO anggota_arsip
SELECT a.*
FROM anggota AS a
WHERE a.status_anggota = 'nonaktif'
  AND a.tgl_daftar_anggota < '2025-01-01'
  AND NOT EXISTS (
      SELECT 1 FROM anggota_arsip AS ar WHERE ar.id_anggota = a.id_anggota
  );

-- Menghapus Data Anggota Nonaktif dari Tabel Utama
DELETE FROM anggota
WHERE status_anggota = 'nonaktif'
  AND tgl_daftar_anggota < '2025-01-01'
  AND NOT EXISTS (
      SELECT 1 FROM penjualan WHERE penjualan.id_anggota = anggota.id_anggota
  );

-- Verifikasi Hasil Pengarsipan
SELECT * FROM anggota_arsip;
SELECT * FROM anggota WHERE status_anggota = 'nonaktif' AND tgl_daftar_anggota < '2025-01-01';

-- Menaikkan Harga Barang Kategori Makanan Sebesar 5% (Pembulatan)
UPDATE barang
SET harga_jual_barang = ROUND(harga_jual_barang * 1.05, -2)
WHERE kategori_barang = 'makanan' AND id_barang > 0;