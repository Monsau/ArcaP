# Platform data

**Solusi data lakehouse perusahaan**

**Bahasa**: Prancis (FR)  
**Versi**: 3.3.1  
**Terakhir diperbarui**: 19 Oktober 2025

---

## Ringkasan

Platform data profesional yang menggabungkan Dremio, dbt, dan Apache Superset untuk transformasi data tingkat perusahaan, jaminan kualitas, dan intelijen bisnis.

Platform ini memberikan solusi lengkap untuk rekayasa data modern, termasuk jalur data otomatis, pengujian kualitas, dan dasbor interaktif.

§§§KODE_0§§§

---

## Fitur Utama

- Arsitektur rumah danau data dengan Dremio
- Transformasi otomatis dengan dbt
- Intelijen bisnis dengan Apache Superset
- Pengujian kualitas data yang komprehensif
- Sinkronisasi real-time melalui Arrow Flight

---

## Panduan Memulai Cepat

### Prasyarat

- Docker 20.10 atau lebih tinggi
- Docker Tulis 2.0 atau lebih tinggi
- Python 3.11 atau lebih tinggi
- RAM minimal 8 GB

### Fasilitas

§§§KODE_1§§§

---

## Arsitektur

### Komponen sistem

| Komponen | Pelabuhan | Deskripsi |
|---------------|------|-------------|
| Dremio | 9047, 31010, 32010 | Platform rumah danau data |
| dbt | - | Alat Transformasi Data |
| Superset | 8088 | Platform Intelijen Bisnis |
| PostgreSQL | 5432 | Basis data transaksional |
| MiniO | 9000, 9001 | Penyimpanan objek (kompatibel dengan S3) |
| Pencarian elastis | 9200 | Mesin pencari dan analisis |

Lihat [dokumentasi arsitektur](arsitektur/) untuk desain sistem terperinci.

---

## Dokumentasi

### Rintisan
- [Panduan Instalasi](memulai/)
- [Konfigurasi](memulai/)
- [Memulai](memulai/)

### Panduan pengguna
- [Rekayasa data](panduan/)
- [Pembuatan dasbor](panduan/)
- [integrasi API](panduan/)

### Dokumentasi API
- [Referensi REST API](api/)
- [Otentikasi](api/)
- [Contoh kode](api/)

### Dokumentasi arsitektur
- [Desain sistem](arsitektur/)
- [Aliran data](arsitektur/)
- [Panduan penerapan](arsitektur/)
- [🎯 Panduan Visual Dremio Ports](arsitektur/dremio-ports-visual.md) ⭐ BARU

---

## Bahasa yang tersedia

| Bahasa | Kode | Dokumentasi |
|--------|------|---------------|
| Bahasa Inggris | EN | [README.md](../../../README.md) |
| Perancis | EN | [docs/i18n/fr/](../fr/README.md) |
| Spanyol | ES | [docs/i18n/es/](../es/README.md) |
| Portugis | PT | [docs/i18n/pt/](../pt/README.md) |
| العربية | AR | [docs/i18n/ar/](../ar/README.md) |
| 中文 | CN | [docs/i18n/cn/](../cn/README.md) |
| 日本語 | JP | [docs/i18n/jp/](../jp/README.md) |
| Русский | Inggris | [docs/i18n/ru/](../ru/README.md) |

---

## Mendukung

Untuk bantuan teknis:
- Dokumentasi: [README utama](../../../README.md)
- Pelacak Masalah: Masalah GitHub
- Forum komunitas: Diskusi GitHub
- Email: support@example.com

---

**[Kembali ke dokumentasi utama](../../../README.md)**