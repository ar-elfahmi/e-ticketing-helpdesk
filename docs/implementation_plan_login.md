# Rencana Implementasi UI Halaman Login

Sesuai permintaan, rencana ini bertujuan untuk mengubah tampilan `login_page.dart` agar menyerupai *layout* dan struktur dari *prototype* `login.blade.php`, namun dengan penyesuaian gaya (warna, tipografi, font) agar konsisten dengan `Laporan Mobile Teori.md`. Logika autentikasi dan fungsionalitas yang ada saat ini tidak akan diubah.

## User Review Required

Mohon periksa dan konfirmasi beberapa keputusan desain di bawah ini sebelum saya mulai mengimplementasikannya:
> [!IMPORTANT]
> - **Warna Gradient Header**: Karena *prototype* menggunakan warna `sky` yang berbeda dengan `Laporan Mobile Teori.md`, saya akan mengganti gradasi *header* menggunakan variasi dari **Warna Primer (#0B6BCB)** agar sesuai dengan laporan.
> - **Tombol Login**: Pada *prototype* berwarna oranye, saya akan mengubahnya menjadi **Warna Primer (#0B6BCB)** atau **Warna Sekunder (#18A999)** untuk menjaga konsistensi dengan panduan warna.
> - **Tombol Sosial Media (Google, Microsoft, Github)**: Saya akan menambahkan tombol-tombol tersebut secara visual sesuai *prototype*, namun karena hanya mengubah UI, tombol-tombol ini tidak akan memiliki fungsionalitas logika login untuk sementara waktu (hanya UI).

## Proposed Changes

### `lib/features/auth/presentation/pages/login_page.dart`

File ini akan dirombak pada bagian UI (`build` method), namun logika form dan fungsi `_submit()` akan dipertahankan persis seperti aslinya.

#### Perubahan Struktural:
1. **Background & Layout Utama**: Menggunakan `Scaffold` dengan warna *background* terang (`#F6F8FB`). Menggunakan `Stack` dikombinasikan dengan `SingleChildScrollView` untuk membuat *header* yang dapat di-*overlap* oleh *card* form login.
2. **Header Melengkung (Gradient Band)**: 
   - Membuat `Container` dengan tinggi tetap (~260px), ujung bawah melengkung (`borderRadius: 48`), dan gradasi linier berbasis warna Primer (`#0B6BCB`).
   - Menambahkan ornamen lingkaran transparan (efek *frosted circles*) di dalam *header* menggunakan `Positioned`.
3. **Logo Stack**:
   - Menempatkan *icon* `support_agent` atau *icon* helm *headset* dalam kotak putih bersudut lengkung (radius 24) dengan sedikit bayangan.
   - Menambahkan teks "E-Ticketing" dan "Helpdesk" di bawah kotak *icon* dengan font **Nunito Sans** ukuran *Caption* dan *Title*.
4. **Card Form Utama**:
   - Ditempatkan *overlap* (naik ke atas menutupi sebagian *header*).
   - Memiliki warna putih (`#FFFFFF`) dengan sudut melengkung besar (radius 28) dan efek bayangan (*box-shadow*).
   - Menampilkan judul "Welcome Back" / "Selamat Datang" menggunakan font **Nunito Sans**, `fontWeight` 800.
5. **Form Input (Email/Username & Password)**:
   - Tetap menggunakan `_usernameController` dan `_passwordController` serta struktur validasi yang sudah ada.
   - Mengubah *styling* TextField agar memiliki kotak putih/abu-abu dengan sudut membulat, *icon* di sebelah kiri, dan tombol pengalih visibilitas (*eye toggle*) di sebelah kanan untuk password.
6. **Tombol dan Aksi**:
   - Teks "Lupa Password?" ditempatkan di kanan atas tombol login.
   - Tombol "Login" ("Masuk") lebar penuh (berwarna Primer `#0B6BCB`) dengan *icon* *arrow* atau *login* di dalamnya. Status `isLoading` akan tetap digunakan.
7. **Elemen Tambahan dari Prototype**:
   - Membuat garis pemisah (*Divider*) dengan tulisan "or" di tengah.
   - Menambahkan baris tombol "Social Sign-in" (Google, Microsoft, GitHub) menggunakan *icon* SVG (atau *icon font* ekuivalen jika memungkinkan, atau *placeholder widget* jika SVG tidak tersedia).
   - Link pendaftaran (Register) digeser ke bawah "Social Sign-in".
   - Menambahkan *badge* keamanan ("Secured & encrypted connection") berukuran kecil di paling bawah *card*.

### Penggunaan Font & Tipografi

Menggunakan `GoogleFonts.nunitoSans` untuk semua teks, menggantikan `Montserrat` dari *prototype*:
- **Display/Headline**: `fontWeight: FontWeight.w800` (untuk judul form).
- **Body/Label**: `fontWeight: FontWeight.w600` atau `w500`.

## Verification Plan

### Manual Verification
1. Menjalankan aplikasi dengan perintah `flutter run` atau *hot reload*.
2. Mengakses halaman Login untuk memastikan:
   - Tampilan UI sesuai dengan struktur `login.blade.php` namun menggunakan warna dan *font* `Laporan Mobile Teori.md`.
   - Proses login dengan *credential* *demo* (`user` / `password123`) masih berfungsi dan mengarahkan ke halaman selanjutnya.
   - Validasi error form masih memunculkan peringatan yang sesuai.
   - Visibilitas password (tombol mata) berfungsi normal.
   - Desain responsif, tidak memunculkan `RenderFlex overflow` pada ukuran layar wajar (menggunakan `SingleChildScrollView` dan `SafeArea`).
