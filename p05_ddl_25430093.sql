-- ============================================================================
-- Berkas: p05_ddl_25430093.sql
-- Penulis: Alwan Zaki Faros (NPM: 25430093)
-- Tema Proyek: Klinik (klinik_093)
-- Modul 5: DDL dan Constraint
-- ============================================================================

CREATE DATABASE IF NOT EXISTS klinik_093
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE klinik_093;

-- ----------------------------------------------------------------------------
-- Hapus tabel dengan urutan terbalik dari anak ke induk (P05 / Titik Analisis 3)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS resep_pembayaran;
DROP TABLE IF EXISTS resep_detail;
DROP TABLE IF EXISTS tindakan_detail;
DROP TABLE IF EXISTS kunjungan;
DROP TABLE IF EXISTS resep;
DROP TABLE IF EXISTS tindakan;
DROP TABLE IF EXISTS obat;
DROP TABLE IF EXISTS pasien;
DROP TABLE IF EXISTS dokter;

-- ----------------------------------------------------------------------------
-- 1. TABEL MASTER: dokter
-- ----------------------------------------------------------------------------
CREATE TABLE dokter (
    id_dokter INT NOT NULL AUTO_INCREMENT,
    kode_dokter CHAR(5) NOT NULL,
    nama_dokter VARCHAR(100) NOT NULL,
    spesialis_dokter VARCHAR(50) NOT NULL,
    no_hp_dokter VARCHAR(15) NULL,
    PRIMARY KEY (id_dokter),
    CONSTRAINT uq_dokter_kode UNIQUE (kode_dokter)
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------
-- 2. TABEL MASTER: pasien
-- ----------------------------------------------------------------------------
CREATE TABLE pasien (
    id_pasien INT NOT NULL AUTO_INCREMENT,
    no_rekam_medis CHAR(8) NOT NULL,
    nik_pasien CHAR(16) NOT NULL,
    nama_pasien VARCHAR(100) NOT NULL,
    tgl_lahir_pasien DATE NOT NULL,
    no_hp_pasien VARCHAR(15) NULL,
    alamat_pasien VARCHAR(200) NULL,
    PRIMARY KEY (id_pasien),
    CONSTRAINT uq_pasien_rm UNIQUE (no_rekam_medis),
    CONSTRAINT uq_pasien_nik UNIQUE (nik_pasien)
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------
-- 3. TABEL MASTER: obat
-- ----------------------------------------------------------------------------
CREATE TABLE obat (
    id_obat INT NOT NULL AUTO_INCREMENT,
    kode_obat VARCHAR(10) NOT NULL,
    nama_obat VARCHAR(100) NOT NULL,
    kategori_obat ENUM('Bebas', 'Bebas Terbatas', 'Keras', 'Obat Luar') NOT NULL,
    harga_jual_obat DECIMAL(12,2) NOT NULL,
    stok_obat INT NOT NULL DEFAULT 0,
    stok_min_obat INT NOT NULL DEFAULT 10,
    PRIMARY KEY (id_obat),
    CONSTRAINT uq_obat_kode UNIQUE (kode_obat),
    CONSTRAINT ck_obat_stok CHECK (stok_obat >= 0),
    CONSTRAINT ck_obat_harga CHECK (harga_jual_obat >= 0)
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------
-- 4. TABEL MASTER: tindakan
-- ----------------------------------------------------------------------------
CREATE TABLE tindakan (
    id_tindakan INT NOT NULL AUTO_INCREMENT,
    kode_tindakan VARCHAR(10) NOT NULL,
    nama_tindakan VARCHAR(100) NOT NULL,
    tarif_tindakan DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id_tindakan),
    CONSTRAINT uq_tindakan_kode UNIQUE (kode_tindakan),
    CONSTRAINT ck_tindakan_tarif CHECK (tarif_tindakan >= 0)
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------
-- 5. TABEL TRANSAKSI KEPALA: kunjungan
-- ----------------------------------------------------------------------------
CREATE TABLE kunjungan (
    id_kunjungan INT NOT NULL AUTO_INCREMENT,
    no_registrasi CHAR(12) NOT NULL,
    tgl_kunjungan DATETIME NOT NULL,
    id_pasien INT NOT NULL,
    id_dokter INT NOT NULL,
    keluhan_kunjungan TEXT NOT NULL,
    diagnosa_kunjungan TEXT NULL,
    PRIMARY KEY (id_kunjungan),
    CONSTRAINT uq_kunjungan_reg UNIQUE (no_registrasi),
    CONSTRAINT fk_kunjungan_pasien FOREIGN KEY (id_pasien) REFERENCES pasien (id_pasien),
    CONSTRAINT fk_kunjungan_dokter FOREIGN KEY (id_dokter) REFERENCES dokter (id_dokter)
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------
-- 6. TABEL TRANSAKSI DETAIL: tindakan_detail
-- ----------------------------------------------------------------------------
CREATE TABLE tindakan_detail (
    id_kunjungan INT NOT NULL,
    id_tindakan INT NOT NULL,
    qty_tindakan_detail SMALLINT NOT NULL DEFAULT 1,
    tarif_satuan_tindakan_detail DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id_kunjungan, id_tindakan),
    CONSTRAINT fk_tdetail_kunjungan FOREIGN KEY (id_kunjungan) REFERENCES kunjungan (id_kunjungan) ON DELETE CASCADE,
    CONSTRAINT fk_tdetail_tindakan FOREIGN KEY (id_tindakan) REFERENCES tindakan (id_tindakan),
    CONSTRAINT ck_tdetail_qty CHECK (qty_tindakan_detail > 0)
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------
-- 7. TABEL TRANSAKSI KEPALA: resep
-- ----------------------------------------------------------------------------
CREATE TABLE resep (
    id_resep INT NOT NULL AUTO_INCREMENT,
    no_resep CHAR(12) NOT NULL,
    id_kunjungan INT NOT NULL,
    tgl_resep DATETIME NOT NULL,
    PRIMARY KEY (id_resep),
    CONSTRAINT uq_resep_no UNIQUE (no_resep),
    CONSTRAINT fk_resep_kunjungan FOREIGN KEY (id_kunjungan) REFERENCES kunjungan (id_kunjungan) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------
-- 8. TABEL TRANSAKSI DETAIL: resep_detail
-- ----------------------------------------------------------------------------
CREATE TABLE resep_detail (
    id_resep INT NOT NULL,
    id_obat INT NOT NULL,
    qty_resep_detail SMALLINT NOT NULL,
    harga_satuan_resep_detail DECIMAL(12,2) NOT NULL,
    aturan_pakai VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_resep, id_obat),
    CONSTRAINT fk_rdetail_resep FOREIGN KEY (id_resep) REFERENCES resep (id_resep) ON DELETE CASCADE,
    CONSTRAINT fk_rdetail_obat FOREIGN KEY (id_obat) REFERENCES obat (id_obat),
    CONSTRAINT ck_rdetail_qty CHECK (qty_resep_detail > 0)
) ENGINE=InnoDB;