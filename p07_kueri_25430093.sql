-- ============================================================================
-- PROYEK BASIS DATA: SISTEM INFORMASI TOKO BANGUNAN
-- NIM   : 25430093
-- File  : p07_kueri_25430093.sql
-- Modul : Pertemuan 7 - SELECT dan Fungsi Skalar
-- ============================================================================

USE toko_bangunan_093;

-- 1. KI-01: Daftar material bangunan yang stoknya menipis dan perlu segera dipesan ulang
-- Pertanyaan: Barang material apa saja yang stok saat ini berada di bawah batas stok minimum?
-- Hasil yang diharapkan: Menampilkan kode, nama barang, sisa stok, batas minimum, dan selisih kekurangannya.
SELECT kode_barang,
       nama_barang,
       stok_barang,
       stok_min_barang,
       (stok_min_barang - stok_barang) AS selisih_kurang
FROM barang
WHERE stok_barang < stok_min_barang
ORDER BY selisih_kurang DESC;

-- 2. KI-01: Pencarian katalog material berdasarkan kata kunci nama barang (LIKE)
-- Pertanyaan: Material bangunan apa saja yang namanya mengandung kata 'semen' atau 'cat'?
-- Hasil yang diharapkan: Menampilkan daftar barang yang sesuai kata kunci dengan nama huruf kapital.
SELECT kode_barang,
       UPPER(nama_barang) AS nama_material,
       kategori_barang,
       harga_jual_barang
FROM barang
WHERE nama_barang LIKE '%semen%'
   OR nama_barang LIKE '%cat%'
ORDER BY nama_barang ASC;

-- 3. KI-01: Klasifikasi ketersediaan stok barang (CASE)
-- Pertanyaan: Bagaimana status ketersediaan setiap material di gudang saat ini?
-- Hasil yang diharapkan: Menampilkan label 'Stok Habis', 'Perlu Restock', atau 'Stok Aman' berdasarkan jumlah stok.
SELECT kode_barang,
       nama_barang,
       stok_barang,
       CASE
           WHEN stok_barang = 0 THEN 'Stok Habis'
           WHEN stok_barang < stok_min_barang THEN 'Perlu Restock'
           ELSE 'Stok Aman'
       END AS status_ketersediaan
FROM barang
ORDER BY stok_barang ASC;

-- 4. KI-02: Penyaringan barang berdasarkan kelompok kategori tertentu (IN)
-- Pertanyaan: Material apa saja yang termasuk dalam kategori utama bahan konstruksi (misal: 'semen', 'besi', 'cat')?
-- Hasil yang diharapkan: Menampilkan daftar barang dari kategori yang dipilih beserta harga format Rupiah.
SELECT kode_barang,
       nama_barang,
       kategori_barang,
       CONCAT('Rp ', FORMAT(harga_jual_barang, 0, 'id_ID')) AS harga_satuan
FROM barang
WHERE kategori_barang IN ('semen', 'besi', 'cat')
ORDER BY kategori_barang ASC, harga_jual_barang DESC;

-- 5. KI-03: Identifikasi pelanggan yang belum melengkapi nomor telepon (IS NULL)
-- Pertanyaan: Siapa saja pelanggan terdaftar yang belum mencantumkan nomor HP/telepon?
-- Hasil yang diharapkan: Menampilkan kode dan nama pelanggan dengan keterangan '-' pada nomor kontak yang kosong.
SELECT kode_pelanggan,
       nama_pelanggan,
       IFNULL(no_hp_pelanggan, '-') AS kontak_hp,
       alamat_pelanggan
FROM pelanggan
WHERE no_hp_pelanggan IS NULL
ORDER BY nama_pelanggan ASC;

-- 6. KI-03: Format label identitas pelanggan dan masa keanggotaan (Fungsi String & Tanggal)
-- Pertanyaan: Berapa lama masing-masing pelanggan sudah terdaftar hingga hari ini?
-- Hasil yang diharapkan: Menampilkan gabungan "Nama [Kode]", tanggal daftar format Indonesia, dan lama hari terdaftar.
SELECT CONCAT(nama_pelanggan, ' [', kode_pelanggan, ']') AS identitas_pelanggan,
       DATE_FORMAT(tgl_daftar_pelanggan, '%d-%m-%Y') AS tanggal_registrasi,
       DATEDIFF(CURDATE(), tgl_daftar_pelanggan) AS lama_terdaftar_hari
FROM pelanggan
ORDER BY lama_terdaftar_hari DESC;

-- 7. KI-04: Daftar transaksi penjualan pada rentang periode tertentu (BETWEEN)
-- Pertanyaan: Nota penjualan apa saja yang terjadi selama bulan Oktober 2026?
-- Hasil yang diharapkan: Menampilkan nomor nota, waktu transaksi, dan nominal pembayaran dalam rentang tanggal tersebut.
SELECT no_nota_penjualan,
       tgl_penjualan,
       id_petugas,
       id_pelanggan,
       bayar_penjualan
FROM penjualan
WHERE tgl_penjualan BETWEEN '2026-10-01 00:00:00' AND '2026-10-31 23:59:59'
ORDER BY tgl_penjualan ASC;

-- 8. KI-04: Transaksi penjualan tunai non-pelanggan/pembeli umum (IS NULL)
-- Pertanyaan: Transaksi penjualan mana saja yang dilakukan oleh pembeli umum (tanpa ID pelanggan)?
-- Hasil yang diharapkan: Menampilkan nomor nota dan waktu transaksi yang kolom id_pelanggan-nya bernilai NULL.
SELECT no_nota_penjualan,
       DATE_FORMAT(tgl_penjualan, '%d/%m/%Y %H:%i') AS waktu_transaksi,
       bayar_penjualan
FROM penjualan
WHERE id_pelanggan IS NULL
ORDER BY tgl_penjualan DESC
LIMIT 10;

-- 9. KI-05: Rincian item penjualan dengan perhitungan subtotal per baris (Operasi Aritmetika)
-- Pertanyaan: Berapa subtotal harga per baris barang untuk transaksi penjualan pertama (id_penjualan = 1)?
-- Hasil yang diharapkan: Menampilkan ID barang, jumlah beli, harga satuan saat transaksi, dan hasil perkalian subtotal.
SELECT id_penjualan,
       id_barang,
       qty_detail_penjualan,
       harga_satuan_detail_penjualan,
       (qty_detail_penjualan * harga_satuan_detail_penjualan) AS subtotal_item
FROM detail_penjualan
WHERE id_penjualan = 1;

-- 10. KI-05: Daftar pemasok material aktif berdasarkan wilayah alamat (LIKE & Fungsi String)
-- Pertanyaan: Pemasok mana saja yang berlokasi di wilayah Metro atau Lampung?
-- Hasil yang diharapkan: Menampilkan nama pemasok dalam huruf kapital beserta nomor telepon dan alamat lengkapnya.
SELECT UPPER(nama_pemasok) AS nama_distributor,
       IFNULL(telepon_pemasok, 'Tidak ada nomor') AS telepon,
       alamat_pemasok
FROM pemasok
WHERE alamat_pemasok LIKE '%Metro%'
   OR alamat_pemasok LIKE '%Lampung%'
ORDER BY nama_pemasok ASC;

-- ============================================================================
-- CATATAN KETERBATASAN KI (DITUNDA KE PERTEMUAN 9–12)
-- 1. Total omzet harian/bulanan dan akumulasi total belanja per nota membutuhkan
--    fungsi agregat SUM() dan GROUP BY (Pertemuan 9).
-- 2. Laporan daftar material terlaris beserta nama barang dan nama kasir yang
--    melayani membutuhkan penggabungan tabel dengan JOIN (Pertemuan 10).
-- ============================================================================