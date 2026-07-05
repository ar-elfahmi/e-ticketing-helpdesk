# Laporan Proyek Praktikum: Aplikasi E-Ticketing Helpdesk Mobile

## Daftar Isi

1. [Pendahuluan](#1-pendahuluan)
2. [Analisis Warna](#2-analisis-warna)
3. [Analisis Font](#3-analisis-font)
4. [Wireframe dan Struktur UI](#4-wireframe-dan-struktur-ui)
5. [Prototipe Fitur](#5-prototipe-fitur)
6. [Kesimpulan](#6-kesimpulan)

---

## 1. Pendahuluan

### 1.1 Latar Belakang

Aplikasi **E-Ticketing Helpdesk** adalah sistem pengelolaan tiket bantuan berbasis mobile yang dirancang untuk memfasilitasi komunikasi antara pengguna (user) dengan tim helpdesk atau administrator dalam menangani berbagai masalah teknis. Aplikasi ini dibangun menggunakan framework **Flutter** dengan bahasa pemrograman **Dart**, yang memungkinkan pengembangan aplikasi lintas platform (Android dan iOS) dari satu codebase tunggal.

Proyek ini bertujuan untuk memberikan solusi praktis dalam pengelolaan ticket helpdesk dengan fitur-fitur penting seperti pembuatan ticket, pelacakan status, komentar, dan manajemen pengguna berdasarkan peran (role-based access).

### 1.2 Teknologi yang Digunakan

| Komponen | Teknologi |
|---------|-----------|
| Framework | Flutter 3.11+ |
| Bahasa | Dart |
| State Management | Provider |
| Arsitektur | Clean Architecture (Feature-based) |
| Desain UI | Material Design 3 |
| Font | Google Fonts (Nunito Sans) |

### 1.3 Struktur Aplikasi

Aplikasi ini mengadopsi pola arsitektur berbasis fitur (feature-based architecture) dengan pembagian modular sebagai berikut:

```
lib/
├── core/                      # Konfigurasi inti aplikasi
│   ├── constants/            # Konstanta (colors, sizes, strings)
│   ├── services/            # Layanan navigasi
│   ├── theme/              # Konfigurasi tema
│   └── widgets/           # Widget reusable
├── features/                # Fitur-fitur aplikasi
│   ├── auth/              # Autentikasi (login, register, splash)
│   ├── dashboard/         # Halaman utama/dashboard
│   ├── notification/     # Sistem notifikasi
│   ├── profile/           # Profil pengguna
│   └── ticket/           # Manajemen ticket
└── app.dart               # Konfigurasi routing utama
```

### 1.4 Peran Pengguna

Aplikasi mendefinisikan tiga peran pengguna utama:

| Peran | Deskripsi |
|-------|----------|
| **User** | Pengguna umum yang dapat membuat dan melacak ticket |
| **Helpdesk** | Tim bantuan teknis yang mengelola dan menugaskan ticket |
| **Admin** | Administrator sistem dengan akses penuh |

---

## 2. Analisis Warna

### 2.1 Palette Warna Utama

Sistem warna aplikasi didefinisikan secara terstruktur dalam file `lib/core/constants/app_colors.dart`. Palette warna dirancang untuk memberikan pengalaman visual yang profesional dan mudah dibaca dengan mendukung dua mode tema: **light** dan **dark**.

#### 2.1.1 Warna Primer dan Sekunder

| Nama Warna | Kode Hex | Deskripsi Penggunaan |
|-----------|---------|-------------------|
| **Primary** | `#0B6BCB` | Biru utama - warna dominan untuk tombol, tautan, dan elemen interaktif utama |
| **Secondary** | `#18A999` | Hijau tosca - warna aksen sekunder untuk tindakan alternatif |

Warna primary (#0B6BCB) dipilih karena memberikan kontras yang baik terhadap latar putih maupun gelap, serta mencerminkan kepercayaan dan profesionalisme yang sesuai dengan konteks helpdesk. Warna secondary (#18A999) memberikan gambaran segar dan berbeda sebagai warna pendukung.

#### 2.1.2 Warna Status dan Peringatan

| Nama Warna | Kode Hex | Makna |
|-----------|---------|-------|
| **Success** | `#2E9E44` | Hijau - operasi berhasil |
| **Warning** | `#F5A524` | Oranye - peringatan atau prioritas sedang |
| **Danger** | `#D64545` | Merah - error atau bahaya |

#### 2.1.3 Warna Status Tiket

| Status | Kode Hex | Deskripsi |
|--------|---------|-----------|
| **Open** | `#2F80ED` | Tiket baru yang terbuka |
| **In Progress** | `#F2C94C` | Sedang dalam penanganan |
| **Closed** | `#27AE60` | Sudah selesai/ditutup |

### 2.2 Palette Warna Tema

#### 2.2.1 Tema Terang (Light Theme)

| Elemen | Warna | Kode Hex |
|-------|-------|---------|
| Background | Putih keabuan | `#F6F8FB` |
| Surface | Putih murni | `#FFFFFF` |
| Teks Utama | Abu gelap | `#1D2939` |

#### 2.2.2 Tema Gelap (Dark Theme)

| Elemen | Warna | Kode Hex |
|-------|-------|---------|
| Background | Hitam kebiruan | `#111827` |
| Surface | Abu biru gelap | `#1E293B` |
| Teks Utama | Putih keabu-abuan | `#F8FAFC` |

### 2.3 Panduan Penggunaan Warna

Pemilihan warna diterapkan dengan prinsip-prinsip berikut:

1. **Kontras yang Memadai**: Semua kombinasi warna memenuhi standar WCAG AA untuk accessibility
2. **Konsistensi Semantik**: Warna memiliki makna yang konsisten di seluruh aplikasi
3. **Dukungan Dark Mode**: Palette warna didesain untuk dapat beradaptasi dengan kedua tema
4. **Visual Hierarchy**: Gradasi brightness digunakan untuk menunjukkan hierarki informasi

---

## 3. Analisis Font

### 3.1 Pilihan Tipografi

Aplikasi menggunakan **Nunito Sans** sebagai typeface utama, yang didefinisikan melalui package `google_fonts` versi 6.2.1. Pemilihan font ini didasarkan pada beberapa pertimbangan:

| Kriteria | Alasan Pemilihan |
|----------|-------------------|
| **Readability** | Nunito Sans memiliki bentuk huruf yang mudah dibaca pada berbagai ukuran |
| **Versatility** | Menawarkan berbagai weight dari light hingga extra bold |
| **Character** | Bentuknya friendly namun tetap profesional |
| **Web Font** | Mudah diimplementasikan melalui Google Fonts |

### 3.2 Implementasi Font

Font diterapkan secara global melalui konfigurasi theme di `lib/core/theme/app_theme.dart`:

```dart
textTheme: GoogleFonts.nunitoSansTextTheme(base.textTheme),
```

Dan untuk elemen-specific seperti AppBar:

```dart
titleTextStyle: GoogleFonts.nunitoSans(
  fontSize: 20,
  fontWeight: FontWeight.w700,
  color: AppColors.textLight,
),
```

### 3.3 Hierarki Tipografi

| Level | Size | Weight | Penggunaan |
|-------|------|--------|------------|
| Display | ~32sp | Bold (700) | Judul halaman utama |
| Headline | ~24sp | Bold (700) | Heading bagian |
| Title | ~20sp | SemiBold (600) | Judul kartu/komponen |
| Body | ~16sp | Regular (400) | Teks paragraf utama |
| Label | ~14sp | Medium (500) | Label form, button |
| Caption | ~12sp | Regular (400) | Teks辅助an, timestamp |

### 3.4 Spec Ukuran dan Spacing

Ukuran dan spacing komponen didefinisikan dalam `lib/core/constants/app_sizes.dart`:

| Konstanta | Nilai | Deskripsi |
|-----------|-------|-----------|
| `xs` | 4px | Spacing ekstra kecil |
| `sm` | 8px | Spacing kecil |
| `md` | 12px | Spacing sedang |
| `lg` | 16px | Spacing besar |
| `xl` | 24px | Spacing ekstra besar |
| `xxl` | 32px | Spacing section |
| `radiusSm` | 8px | Border radius kecil |
| `radiusMd` | 12px | Border radius sedang |
| `radiusLg` | 16px | Border radius besar |
| `buttonHeight` | 48px | Tinggi button standar |
| `avatarLg` | 72px | Ukuran avatar besar |

---

## 4. Wireframe dan Struktur UI

### 4.1 Navigasi dan Routing

Aplikasi menggunakan pola navigasi berbasis named routes yang didefinisikan dalam `lib/app.dart`.struktur routing aplikasi:

```
Splash Page
    │
    ├── Login Page
    │       │
    │       └── Register Page
    │
    └── App Shell (Main Navigation)
            │
            ├── Dashboard Page (Tab 1)
            │
            ├── Daftar Tiket / Ticket List Page (Tab 2)
            │       │
            │       └── Detail Tiket / Ticket Detail Page
            │
            ├── Notifikasi / Notification Page (Tab 3)
            │
            └── Profil / Profile Page (Tab 4)
                    │
                    └── Buat Tiket / Create Ticket Page
```

### 4.2 Wireframe Halaman Utama

#### 4.2.1 Splash Page

Halaman pembuka yang ditampilkan saat aplikasi pertama kali запуска..Contains:
- Logo aplikasi (icon support_agent)
- Nama aplikasi: "E-Ticketing Helpdesk"

#### 4.2.2 Login Page

Halaman autentikasi untuk masuk ke aplikasi.

**Komponen:**
1. Logo/icon besar (72px)
2. Judul: "Selamat datang"
3. Subtitle dengan informasi login demo
4. Form-field:
   - TextField username dengan icon person
   - TextField password dengan icon lock + toggle visibility
5. Link "Lupa Password?"
6. Tombol "Masuk" (CustomButton)
7. Link navigasi ke Register

**Kredensial Demo:**
- Username: user / helpdesk / admin
- Password: password123

#### 4.2.3 Register Page

Halaman pendaftaran akun baru.

**Komponen:**
1. Form-field:
   - TextField untuk nama lengkap
   - TextField untuk email
   - TextField untuk username
   - TextField untuk password
   - Konfirmasi password
2. Dropdown pilihan role
3. Tombol "Daftar"
4. Link navigasi ke Login

#### 4.2.4 Dashboard Page

Halaman utama setelah login yang menampilkan ringkasan informasi.

**Layout (ListView Scrollable):**
1. AppBar dengan:
   - Judul "Dashboard"
   - Icon notifikasi dengan badge count
   - Avatar pengguna
2. Card sapaan user dengan foto dan role
3. Grid stats (2x2):
   - Total Tiket (icon: dataset)
   - Open (icon: mark_email_unread)
   - In Progress (icon: hourglass_top)
   - Closed (icon: verified)
4. Section "Tiket Terbaru"
   - List recent tickets (RecentTicketWidget)
5. FloatingActionButton: "Buat Tiket Baru" (khusus role User)

#### 4.2.5 Ticket List Page

Halaman daftar lengkap semua ticket dengan filter dan pencarian.

**Komponen:**
1. AppBar: "Daftar Tiket"
2. TextField pencarian (full-width)
3. Horizontal chip filter:
   - Semua
   - Open
   - In Progress
   - Closed
4. ListView ticket (infinite scroll):
   - TicketCardWidget untuk setiap ticket
   - Loading indicator untuk pagination
5. FAB untuk buat ticket baru (role User)

#### 4.2.6 Ticket Detail Page

Halaman detail lengkap sebuah ticket.

**Layout:**
1. AppBar dengan nomor ticket
2. Card informasi utama:
   - Judul ticket (bold)
   - Status badge
   - Kategori & prioritas
   - Deskripsi lengkap
   - Lampiran (jika ada)
3. Card aksi helpdesk/admin:
   - Dropdown ubah status
   - Tombol assign ke...
4. Section "Timeline Status"
   - TicketStatusTimeline widget
5. Section "Komentar"
   - List comment bubbles
   - CommentBubbleWidget (dengan alignment left/right)
6. Input komentar stucky di bottom

#### 4.2.7 Create Ticket Page

Halaman membuat ticket baru.

**Komponen:**
1. AppBar: "Buat Tiket Baru"
2. Form (ListView scrollable):
   - TextField: Judul Tiket (required)
   - DropdownButton: Kategori (Hardware/Software/Network/Lainnya)
   - DropdownButton: Prioritas (Low/Medium/High)
   - TextField: Deskripsi (required, min 10 karakter)
   - Card Lampiran:
     - Tombol: Kamera
     - Tombol: Galeri
     - List lampiran yang dipilih
3. BottomNavigationBar: Tombol "Kirim Tiket"
4. Konfirmasi jika akan keluar tanpa save

#### 4.2.8 Notification Page

Halaman daftar notifikasi.

**Layout:**
1. AppBar: "Notifikasi"
2. ListView notifikasi:
   - NotificationTileWidget per item
   - Badge unread indicator
   - Timestamp

#### 4.2.9 Profile Page

Halaman profil pengguna dan pengaturan.

**Komponen:**
1. AppBar: "Profil"
2. Section info user:
   - Avatar besar
   - Nama lengkap
   - Email
   - Role display
3. Section menu:
   - Menu items (Edit Profil, Pengaturan, Tentang, Keluar)
   - ProfileMenuItem widgets

### 4.3 Komponen Reusable

Aplikasi memiliki beberapa komponen widget reusable yang dapat digunakan kembali:

| Widget | Lokasi | Deskripsi |
|--------|--------|-----------|
| `LoadingWidget` | `lib/core/widgets/loading_widget.dart` | Shimmer loading effect |
| `EmptyStateWidget` | `lib/core/widgets/empty_state_widget.dart` | Empty state display |
| `CustomButton` | `lib/core/widgets/custom_button.dart` | Custom styled button |
| `CustomTextField` | `lib/core/widgets/custom_text_field.dart` | Styled text input |
| `StatusBadge` | `lib/core/widgets/status_badge.dart` | Status label badge |
| `StatsCardWidget` | `lib/features/dashboard/presentation/widgets/stats_card_widget.dart` | Dashboard stats card |
| `RecentTicketWidget` | `lib/features/dashboard/presentation/widgets/recent_ticket_widget.dart` | Recent ticket item |
| `TicketCardWidget` | `lib/features/ticket/presentation/widgets/ticket_card_widget.dart` | Full ticket card |
| `TicketStatusTimeline` | `lib/features/ticket/presentation/widgets/ticket_status_timeline.dart` | Status history timeline |
| `CommentBubbleWidget` | `lib/features/ticket/presentation/widgets/comment_bubble_widget.dart` | Chat bubble |
| `ProfileMenuItem` | `lib/features/profile/presentation/widgets/profile_menu_item.dart` | Profile menu item |

---

## 5. Prototipe Fitur

### 5.1 Fitur Autentikasi

#### 5.1.1 Login
- Validasi form (username & password required)
- Toggle password visibility
- Loading state saat proses login
- Redirect ke main app setelah berhasil
- Error handling dengan SnackBar

#### 5.1.2 Register
- Multiple form fields dengan validasi
- Dropdown pemilihan role
- Navigasi ke login setelah daftar

#### 5.1.3 Splash
- Initial route aplikasi
- Auto redirect ke login/shell berdasarkan auth state

### 5.2 Fitur Dashboard

- Tampilan stats real-time (Total, Open, In Progress, Closed)
- Sapaan personalization berdasarkan nama user
- Recent tickets list (limit 5)
- Pull-to-refresh
- Badge notifikasi unread count
- FAB creation ticket (khusus user role)

### 5.3 Fitur Ticket Management

#### 5.3.1 Daftar Tiket
- Infinite scroll pagination
- Search/filter berdasarkan nomor, judul, kategori
- Filter status chip (Semua, Open, In Progress, Closed)
- Role-based visibility (user hanya lihat miliknya)

#### 5.3.2 Detail Tiket
- Informasi lengkap ticket
- Timeline status history
- Sistem komentar (add comment)
- Role staff dapat ubah status
- Role staff dapat assign ke helpdesk lain
- Pull-to-refresh

#### 5.3.3 Buat Tiket Baru
- Form dengan validasi (judul required, deskripsi min 10 char)
- Kategori: Hardware, Software, Network, Lainnya
- Prioritas: Low, Medium, High
- Lampiran gambar (kamera & galeri)
- Alert konfirmasi saat navigate away dengan form terisi

### 5.4 Fitur Notifikasi

- Daftar notifikasi
- Indikator unread
- Badge count di dashboard
- Timestamp relative (misal: "2 jam lalu")

### 5.5 Fitur Profil

- Tampilan info user (avatar, nama, email, role)
- Menu items navigasi
- Logout functionality

### 5.6 Fitur Theming

- Light/Dark mode toggle
- Theme persistence (simpan preference)
- Dynamic color scheme switching

---

## 6. Kesimpulan

### 6.1 Ringkasan Proyek

Proyek E-Ticketing Helpdesk Mobile ini berhasil mengimplementasikan sebuah aplikasi mobile berbasis Flutter yang komprehensif untuk pengelolaan ticket helpdesk. Aplikasi ini mencakup seluruh aspek yang diperlukan mulai dari autentikasi pengguna, manajemen ticket, notifikasi, hingga profil pengguna dengan dukungan multi-peran.

### 6.2 Keunggulan Aplikasi

1. **Clean Architecture**: Struktur kode yang modular dan mudah dikembangkan
2. **Material Design 3**: UI yang modern dan responsif
3. **Dark Mode Support**: Dukungan penuh untuk tema gelap
4. **Role-Based Access**: Kontrol akses berdasarkan peran pengguna
5. **Infinite Scroll**: Optimalisasi loading untuk daftar panjang
6. **Pull-to-Refresh**: Update data dengan gestures standar
7. **Loading States**: Feedback visual yang baik

### 6.3 Teknologi Pendukung

| Package | Versi | Fungsi |
|---------|-------|--------|
| `provider` | 6.1.2 | State management |
| `google_fonts` | 6.2.1 | Tipografi Nunito Sans |
| `intl` | 0.19.0 | Formatting tanggal/angka |
| `image_picker` | 1.1.2 | Pemilihan gambar |
| `cached_network_image` | 3.4.1 | Caching gambar |
| `shimmer` | 3.0.0 | Loading effect |

### 6.4 Saran Pengembangan

Untuk pengembangan lebih lanjut, dapat dipertimbangkan:
1. Integrasi dengan backend API real
2. Push notification (Firebase Cloud Messaging)
3. Upload lampiran ke cloud storage
4. Analitik dan reporting dashboard
5. Export laporan ticket
6. Implementasi unit test dan widget test
7. Optimasi performa untuk device low-end

---

**Laporan ini disusun sebagai dokumentasi proyek praktikum pembelajaran pengembangan aplikasi mobile menggunakan Flutter.**