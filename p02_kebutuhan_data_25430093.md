# Dokumen Kebutuhan Data Sistem Informasi Akademik Cendekia DI

## 1. Latar Belakang dan Aktivitas Organisasi
Sistem Informasi Akademik Cendekia DI merupakan platform pengelolaan data akademik di perguruan tinggi fiktif. Sistem ini menangani proses pendaftaran mahasiswa, pengikatan kartu rencana studi (KRS), perkuliahan, dan pembuatan laporan hasil studi (KHS) mahasiswa.

## 2. Aktor dan Proses Bisnis
| Kode | Proses Bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan Mahasiswa Baru | Staf Akademik | Mahasiswa baru melengkapi pendaftaran |
| PB-02 | Mengelola Mata Kuliah & Jadwal | Staf Akademik | Awal semester baru dimula |
| PB-03 | Pengisian Rencana Studi (KRS) | Mahasiswa | Masa pengisian KRS dibuka |
| PB-04 | Input Nilai Akhir Perkuliahan | Dosen | Perkuliahan dan ujian selesai |
| PB-05 | Penerbitan Kartu Hasil Studi | Mahasiswa / Dosen | Akhir semester |

## 3. Dokumen Sumber yang Dianalisis
Dokumen sumber fiktif yang digunakan meliputi: Formulir Biodata Mahasiswa Baru, Formulir Kartu Rencana Studi (KRS), dan Transkrip/Kartu Hasil Studi (KHS).

## 4. Entitas Kandidat dan Elemen Data
* **Mahasiswa:** `id_mahasiswa`, `nim_mahasiswa`, `nama_mahasiswa`, `prodi_mahasiswa`, `no_hp_mahasiswa`, `status_mahasiswa`
* **Dosen:** `id_dosen`, `nidn_dosen`, `nama_dosen`, `email_dosen`
* **Mata Kuliah:** `id_matakuliah`, `kode_matakuliah`, `nama_matakuliah`, `sks_matakuliah`
* **Jadwal Kuliah:** `id_jadwal`, `hari_jadwal`, `jam_jadwal`, `ruangan_jadwal`
* **KRS:** `id_krs`, `semester_krs`, `tahun_akademik_krs`, `tgl_isi_krs`
* **Detail KRS / Nilai:** `id_detail_krs`, `nilai_angka_detail_krs`, `nilai_huruf_detail_krs`

## 5. Aturan Bisnis
* **AB-01:** Setiap mahasiswa memiliki NIM unik 10 digit.
* **AB-02:** Pengisian KRS hanya dapat dilakukan oleh mahasiswa dengan status AKTIF.
* **AB-03:** Satu mahasiswa dapat mengambil maksimal 6 item mata kuliah per semester (berdasarkan parameter P + 2 = 6).
* **AB-04:** Nilai akhir perkuliahan diinput oleh dosen dalam rentang 0.00 hingga 100.00.
* **AB-05:** Setiap mata kuliah memiliki SKS yang tidak boleh bernilai negatif atau nol.
* **AB-06:** Setiap kelas perkuliahan diampu oleh tepat satu dosen utama.
* **AB-07:** Nomor HP mahasiswa bersifat data pribadi dan memiliki batas akses ketat.
* **AB-08:** Mahasiswa yang terlambat mengisi KRS dikenakan denda administrasi harian sebesar Rp4.000 (berdasarkan parameter P = 4).

## 6. Kebutuhan Informasi
* **KI-01:** Laporan daftar mahasiswa aktif per program studi.
* **KI-02:** Daftar mata kuliah beserta dosen pengampunya pada semester berjalan.
* **KI-03:** Kartu Rencana Studi (KRS) mahasiswa per semester.
* **KI-04:** Transkrip Nilai / Kartu Hasil Studi (KHS) mahasiswa per semester.
* **KI-05:** Daftar mahasiswa yang belum mengisi KRS pada semester aktif.

## 7. Matriks CRUD
| Proses | Mahasiswa | Dosen | Mata Kuliah | Jadwal | KRS | Detail KRS / Nilai |
|---|---|---|---|---|---|---|
| PB-01 Mendaftarkan Mahasiswa | C | R | R | R | R | R |
| PB-02 Mengelola Jadwal | R | R | C, U | C, U | R | R |
| PB-03 Pengisian KRS | R | R | R | R | C | C |
| PB-04 Input Nilai | R | R | R | R | R | U |
| PB-05 Cetak KHS | R | R | R | R | R | R |

## 8. Kamus Data Awal
| Elemen | Arti | Contoh | Aturan | Penanggung Jawab |
|---|---|---|---|---|
| `nim_mahasiswa` | NIM Mahasiswa | 25430093 | Unik, 10 digit | Staf Akademik |
| `nama_mahasiswa` | Nama Lengkap Mahasiswa | Alwan Zaki Faros | Wajib diisi | Staf Akademik |
| `prodi_mahasiswa` | Program Studi | Ilmu Komputer | Sesuai daftar prodi | Staf Akademik |
| `no_hp_mahasiswa` | Nomor Telepon HP | 081234567890 | Data pribadi, akses terbatas | Staf Akademik |
| `kode_matakuliah` | Kode Mata Kuliah | INF201 | Unik per mata kuliah | Kepala Prodi |
| `sks_matakuliah` | Jumlah SKS | 3 | Bilangan bulat > 0 | Kepala Prodi |
| `nilai_angka_detail_krs` | Nilai Akhir Angka | 85.50 | 0.00 s.d. 100.00 | Dosen Pengampu |

## 9. Kebutuhan Non-Fungsional Data & Perhitungan Parameter P
* **Perhitungan Parameter P:**
  * Dua digit terakhir NIM = 93[cite: 56]
  * $P = (93 \pmod 9) + 1 = 3 + 1 = 4$[cite: 56]
  * Batas maksimal item perkuliahan per KRS ($P + 2$) = **6 item**[cite: 56]
  * Denda keterlambatan per hari ($P$) = **Rp4.000**[cite: 56]
  * Volume estimasi transaksi pendaftaran/KRS harian ($40 + 5 \times P$) = **60 transaksi/hari**[cite: 56]
* **Privasi Data:** Nomor HP dan data nilai mahasiswa dikategorikan sebagai data pribadi yang restricted.

## 10. Isu Kualitas Data yang Diantisipasi
Perbedaan ejaan nama mahasiswa, format nomor HP yang beragam (+62 vs 08), dan kesalahan penginputan nilai di luar rentang sah.