# E-Ticketing Helpdesk

Aplikasi mobile helpdesk untuk pelaporan, monitoring, dan penyelesaian tiket layanan IT berbasis Flutter dan Supabase.

## 📱 APK Siap Download
Untuk menguji aplikasi langsung di perangkat Android Anda, Anda dapat mengunduh berkas APK rilis yang sudah siap pakai di root repositori ini:
* **[app-release.apk](app-release.apk)**

> [!NOTE]
> Saat menginstal APK ini di perangkat Anda, jika muncul peringatan dari Google Play Protect, silakan ketuk **"Tetap instal"** (*Install anyway*). Pastikan Anda menghapus versi lama terlebih dahulu sebelum menginstal versi baru.

## 🗄️ Database Schema
Skema tabel Supabase yang digunakan dalam proyek ini dapat diakses pada berkas SQL di root repositori ini:
* **[database.sql](database.sql)**

---

## Fitur Utama

- **Multi-role**: Mendukung peran *User*, *Helpdesk*, dan *Admin*.
- **Autentikasi & Registrasi**: Terintegrasi langsung dengan Supabase Auth (dilengkapi fitur reset password).
- **Dashboard Statistik**: Tampilan ringkasan status tiket dan daftar tiket terbaru sesuai dengan hak akses role masing-masing.
- **Manajemen Tiket**: Pembuatan tiket baru (dilengkapi kategori, prioritas, dan lampiran), pencarian, penyaringan (*filter*), detail tiket, linimasa (*timeline*), dan sistem komentar.
- **Notifikasi**: Riwayat update status tiket.
- **Profil Pengguna**: Informasi pengguna disertai opsi pilihan tema gelap/terang (*Dark/Light Mode*).

---

## Arsitektur Proyek

Proyek ini menerapkan pola arsitektur **Feature-First** dikombinasikan dengan **Provider** untuk manajemen state dan **Repository Pattern**:

* **`lib/core/`**: Berisi aset bersama seperti tema, konstanta teks/rute (`app_strings.dart`), layanan, dan widget yang dapat digunakan kembali (*reusable widgets*).
* **`lib/features/`**: Folder modular berbasis fitur (*auth, dashboard, ticket, notification, profile*). Setiap fitur dibagi menjadi:
  * **`data/`**: Model data dan antarmuka (*interface*) repositori beserta implementasinya (Supabase/Dummy).
  * **`presentation/`**: Tampilan halaman (*pages*), widget spesifik fitur, dan state management (*providers*).

Penerapan *Repository Pattern* ini memudahkan peralihan sumber data (misalnya dari data *Dummy/In-Memory* ke *Supabase*) secara instan pada berkas `lib/main.dart` tanpa perlu mengubah kode pada lapisan antarmuka (*presentation layer*).

---

## Cara Menjalankan Proyek

1. **Unduh Dependensi:**
   ```bash
   flutter pub get
   ```

2. **Jalankan Aplikasi:**
   ```bash
   flutter run
   ```

3. **Jalankan Analisis Kode:**
   ```bash
   flutter analyze
   ```

4. **Jalankan Pengujian Unit:**
   ```bash
   flutter test
   ```

5. **Build APK Rilis Secara Mandiri:**
   Pastikan Android SDK sudah terkonfigurasi dengan benar di environment Anda, lalu jalankan:
   ```bash
   flutter build apk --release
   ```
