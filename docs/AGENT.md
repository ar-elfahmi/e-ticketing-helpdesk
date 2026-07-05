# AGENT.md

## Ringkasan Arsitektur

Project menggunakan arsitektur Feature-First dengan layering:

- `core/`: shared constants, theme, service, reusable widget.
- `features/*/data`: model + repository interface + implementasi dummy.
- `features/*/presentation`: page, widget spesifik fitur, provider.

State management menggunakan `provider` dan prinsip dependency inversion:

- Provider hanya bergantung pada repository interface.
- Implementasi aktif saat ini: `dummy_*_repository.dart`.
- Migrasi backend: swap repository implementasi di `main.dart`.

## Cara Menjalankan

1. Install dependency:
   - `flutter pub get`
2. Jalankan aplikasi:
   - `flutter run`
3. Jalankan analisis:
   - `flutter analyze`
4. Jalankan test:
   - `flutter test`

Akun demo login:

- Username: `user` / `helpdesk` / `admin`
- Password: `password123`

## Konvensi Penamaan

- File repository dummy wajib menggunakan prefix `dummy_`.
- Nama route disimpan terpusat di `core/constants/app_strings.dart` (`AppRoutes`).
- Provider menggunakan suffix `Provider` dan extends `ChangeNotifier`.
- Model menggunakan suffix `Model`.

## Cara Menambah Fitur Baru

1. Buat folder fitur baru di `lib/features/<feature_name>/`:
   - `data/models`
   - `data/repositories`
   - `presentation/pages`
   - `presentation/providers`
   - `presentation/widgets`
2. Definisikan model dan repository interface.
3. Implementasikan dummy repository untuk pengembangan awal.
4. Buat provider untuk state dan logic fitur.
5. Buat UI page/widget dan hubungkan ke provider.
6. Daftarkan route baru di `lib/app.dart`.
7. Jika provider global diperlukan, register di `lib/main.dart`.

## Catatan Migrasi Backend

Saat backend siap:

- Buat `supabase_*_repository.dart` yang `implements` interface existing.
- Ganti injeksi dummy repository di `main.dart` dengan supabase repository.
- Layer presentation tidak perlu diubah.
