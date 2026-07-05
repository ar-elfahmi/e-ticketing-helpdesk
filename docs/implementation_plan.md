# Implementation Plan — E-Ticketing Helpdesk

> **Versi:** 1.0 | **Tanggal:** 19 April 2026 | **Stack:** Flutter + Provider + Dummy Data (→ Supabase)

---

# 1. Project Overview & Architecture

## 1.1 Ringkasan Aplikasi

Aplikasi **E-Ticketing Helpdesk** adalah platform mobile untuk pelaporan, monitoring, dan penyelesaian masalah IT/layanan. Terdapat 3 role: **User** (pelapor), **Helpdesk** (petugas support), dan **Admin** (pengelola sistem).

## 1.2 Arsitektur Feature-First

```
lib/
├── main.dart
├── app.dart                          # MaterialApp, ThemeData, Router
├── core/
│   ├── constants/
│   │   ├── app_colors.dart           # Palet warna light & dark
│   │   ├── app_strings.dart          # String statis / label
│   │   └── app_sizes.dart            # Spacing, radius, dsb.
│   ├── network/
│   │   └── api_client.dart           # Placeholder HTTP client (future)
│   ├── services/
│   │   └── navigation_service.dart   # Global navigator key
│   ├── theme/
│   │   ├── app_theme.dart            # ThemeData light & dark
│   │   └── theme_provider.dart       # Dark/Light mode toggle
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       ├── status_badge.dart
│       ├── empty_state_widget.dart
│       └── loading_widget.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       ├── auth_repository.dart          # Abstract class (interface)
│   │   │       └── dummy_auth_repository.dart    # Implementasi dummy
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── splash_page.dart
│   │       │   ├── login_page.dart
│   │       │   └── register_page.dart
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       └── widgets/
│   │           └── auth_form_widget.dart
│   ├── dashboard/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── dashboard_stats_model.dart
│   │   │   └── repositories/
│   │   │       ├── dashboard_repository.dart
│   │   │       └── dummy_dashboard_repository.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── dashboard_page.dart
│   │       ├── providers/
│   │       │   └── dashboard_provider.dart
│   │       └── widgets/
│   │           ├── stats_card_widget.dart
│   │           └── recent_ticket_widget.dart
│   ├── ticket/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── ticket_model.dart
│   │   │   │   └── comment_model.dart
│   │   │   └── repositories/
│   │   │       ├── ticket_repository.dart
│   │   │       └── dummy_ticket_repository.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── ticket_list_page.dart
│   │       │   ├── ticket_detail_page.dart
│   │       │   └── create_ticket_page.dart
│   │       ├── providers/
│   │       │   └── ticket_provider.dart
│   │       └── widgets/
│   │           ├── ticket_card_widget.dart
│   │           ├── ticket_status_timeline.dart
│   │           └── comment_bubble_widget.dart
│   ├── notification/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── notification_model.dart
│   │   │   └── repositories/
│   │   │       ├── notification_repository.dart
│   │   │       └── dummy_notification_repository.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── notification_page.dart
│   │       ├── providers/
│   │       │   └── notification_provider.dart
│   │       └── widgets/
│   │           └── notification_tile_widget.dart
│   └── profile/
│       ├── data/
│       │   └── repositories/
│       │       ├── profile_repository.dart
│       │       └── dummy_profile_repository.dart
│       └── presentation/
│           ├── pages/
│           │   └── profile_page.dart
│           ├── providers/
│           │   └── profile_provider.dart
│           └── widgets/
│               └── profile_menu_item.dart
```

## 1.3 State Management — Provider

| Layer | Penjelasan |
|---|---|
| **Provider** | `ChangeNotifier` per fitur, di-inject via `MultiProvider` di `app.dart` |
| **Repository Interface** | Abstract class → Provider hanya bergantung pada interface |
| **Dummy Impl** | Class `dummy_*_repository.dart` mengimplementasi interface dengan data statis |

## 1.4 Routing

Menggunakan **named routes** di `MaterialApp` (`routes: {}`) — sederhana dan cocok untuk skala aplikasi ini. Route constants didefinisikan di `core/constants/app_strings.dart`.

## 1.5 Strategi Repository Interface (Dummy → Supabase)

```dart
// auth_repository.dart (Interface)
abstract class AuthRepository {
  Future<UserModel?> login(String username, String password);
  Future<void> logout();
  Future<UserModel?> register({...});
}

// dummy_auth_repository.dart
class DummyAuthRepository implements AuthRepository {
  @override
  Future<UserModel?> login(String username, String password) async {
    await Future.delayed(Duration(seconds: 1)); // simulasi network
    // return dummy user
  }
}

// [FUTURE] supabase_auth_repository.dart
class SupabaseAuthRepository implements AuthRepository { ... }
```

**Swap** dilakukan di `MultiProvider` → cukup ganti `DummyAuthRepository()` menjadi `SupabaseAuthRepository()`.

---

# 2. Spesifikasi UI/UX per Layar (Brief untuk Figma)

---

## 2.1 Splash Screen

| Aspek | Detail |
|---|---|
| **Target Audiens** | Semua role |
| **Tujuan** | Branding + cek status autentikasi (auto-redirect) |
| **Layout** | Centered — logo di tengah layar, latar gradien warna brand |
| **Komponen UI** | Logo aplikasi (image/SVG), teks nama app, `CircularProgressIndicator` subtle |
| **Data Dinamis** | Tidak ada |
| **State/Interaksi** | Setelah 2 detik → cek auth → navigate ke Login atau Dashboard |
| **Catatan Desain** | Animasi fade-in logo. Gunakan warna gradien primer brand. Tidak ada tombol/input. |

---

## 2.2 Login Screen

| Aspek | Detail |
|---|---|
| **Target Audiens** | Semua role |
| **Tujuan** | Autentikasi pengguna ke dalam sistem |
| **Layout** | Single-scroll column: ilustrasi/logo atas, form tengah, tombol bawah |
| **Komponen UI** | ① Logo/ilustrasi ② `TextField` username (icon `person`) ③ `TextField` password (icon `lock`, toggle visibility) ④ Tombol "Lupa Password?" (text button) ⑤ Tombol **Login** (primary, full-width) ⑥ Link "Belum punya akun? **Daftar**" |
| **Data Dinamis** | Tidak ada |
| **State/Interaksi** | Validasi: field kosong → error inline. Login gagal → `SnackBar` error. Loading state pada tombol (spinner). |
| **Catatan Desain** | Mendukung dark/light mode. Tombol login prominent dengan warna primer. |

---

## 2.3 Register Screen

| Aspek | Detail |
|---|---|
| **Target Audiens** | User (role baru) |
| **Tujuan** | Mendaftarkan akun baru |
| **Layout** | Scrollable form column: judul, fields, tombol |
| **Komponen UI** | ① `TextField` Nama Lengkap ② `TextField` Email ③ `TextField` Username ④ `TextField` Password (toggle visibility) ⑤ `TextField` Konfirmasi Password ⑥ Tombol **Daftar** (primary, full-width) ⑦ Link "Sudah punya akun? **Masuk**" |
| **Data Dinamis** | Tidak ada |
| **State/Interaksi** | Validasi: email format, password match, field kosong → error inline. Sukses → navigate ke Login + `SnackBar` sukses. |

---

## 2.4 Dashboard Screen

| Aspek | Detail |
|---|---|
| **Target Audiens** | Semua role (konten adaptif sesuai role) |
| **Tujuan** | Ringkasan statistik tiket & akses cepat ke fitur utama |
| **Layout** | `Scaffold` dengan `AppBar` (judul + icon notifikasi + avatar), `body` scrollable, `BottomNavigationBar` (Dashboard, Tiket, Profile) |
| **Komponen UI** | ① **AppBar**: Teks "Dashboard", icon lonceng (badge count), avatar user ② **Greeting Card**: "Halo, [Nama]" + role badge ③ **Stats Cards** (Grid 2×2): Total Tiket, Open, In Progress, Closed — masing-masing dengan icon, angka besar, label ④ **Daftar Tiket Terbaru** (3-5 item): `Card` ringkas: ID tiket, judul, status badge, tanggal ⑤ **FAB** (khusus role User): "Buat Tiket Baru" |
| **Data Dinamis** | `totalTickets`, `openCount`, `inProgressCount`, `closedCount`, `recentTickets[]` |
| **State/Interaksi** | Loading: shimmer/skeleton. Empty: ilustrasi + teks "Belum ada tiket". Pull-to-refresh. Tap tiket terbaru → Detail Tiket. |
| **Perbedaan Role** | **User**: melihat tiket milik sendiri, ada FAB. **Helpdesk/Admin**: melihat semua tiket, tidak ada FAB, stats lebih lengkap. |

---

## 2.5 List Tiket Screen

| Aspek | Detail |
|---|---|
| **Target Audiens** | Semua role |
| **Tujuan** | Menampilkan daftar tiket dengan filter dan pencarian |
| **Layout** | `AppBar` dengan search bar, tab/chip filter status di bawah AppBar, `ListView` scrollable, FAB (User only) |
| **Komponen UI** | ① **Search Bar** (icon search di AppBar) ② **Filter Chips**: Semua, Open, In Progress, Closed ③ **Ticket Card** per item: — Nomor tiket (`#TK-001`) — Judul tiket (max 2 baris) — Status Badge (warna: Open=biru, In Progress=kuning, Closed=hijau) — Kategori/tag — Tanggal dibuat — Prioritas icon (opsional) ④ **FAB** "+" (User only) |
| **Data Dinamis** | `List<TicketModel>`: id, title, status, category, createdAt, priority |
| **State/Interaksi** | Loading: shimmer cards. Empty: ilustrasi "Tidak ada tiket ditemukan". Filter → re-render list. Search → debounce 300ms. Lazy loading / pagination. Tap card → Detail Tiket. |
| **Perbedaan Role** | **User**: hanya tiket milik sendiri. **Helpdesk/Admin**: semua tiket + opsi assign. |

---

## 2.6 Detail Tiket Screen

| Aspek | Detail |
|---|---|
| **Target Audiens** | Semua role |
| **Tujuan** | Melihat informasi lengkap tiket, tracking status, dan komunikasi |
| **Layout** | `AppBar` (judul tiket / ID), scrollable body terbagi dalam section, input komentar sticky di bawah |
| **Komponen UI** | **Section 1 — Info Tiket:** — Judul tiket — Status Badge besar — Kategori, Prioritas — Tanggal dibuat, Tanggal diupdate — Pelapor (nama + avatar) — Deskripsi lengkap — Lampiran (gambar/file, tappable preview) |
| | **Section 2 — Timeline/Tracking:** — Vertikal stepper/timeline: setiap perubahan status dengan timestamp dan user |
| | **Section 3 — Komentar/Reply:** — List `CommentBubble`: avatar, nama, waktu, isi pesan — Bubble style berbeda untuk user vs helpdesk |
| | **Section 4 — Input Komentar (Sticky Bottom):** — `TextField` multi-line — Icon attach file — Tombol kirim |
| | **Tombol Aksi (Helpdesk/Admin):** — Dropdown "Ubah Status" — Tombol "Assign ke..." |
| **Data Dinamis** | `TicketModel` lengkap + `List<CommentModel>` + `List<StatusHistory>` |
| **State/Interaksi** | Loading: skeleton per section. Kirim komentar → append ke list real-time. Ubah status → confirmation dialog → update badge. Tap lampiran → full-screen preview. |

---

## 2.7 Create Tiket Screen

| Aspek | Detail |
|---|---|
| **Target Audiens** | User |
| **Tujuan** | Membuat tiket keluhan/permintaan layanan baru |
| **Layout** | `AppBar` ("Buat Tiket Baru"), scrollable form, tombol submit sticky di bawah |
| **Komponen UI** | ① `TextField` **Judul Tiket** (required) ② `DropdownButton` **Kategori** (Hardware, Software, Network, Lainnya) ③ `DropdownButton` **Prioritas** (Low, Medium, High, Critical) ④ `TextField` **Deskripsi** (multi-line, min 3 baris) ⑤ **Upload Area**: card dengan icon kamera + icon file, preview thumbnail setelah upload (bisa multiple), tombol hapus per item ⑥ Tombol **Kirim Tiket** (primary, full-width, sticky bottom) |
| **Data Dinamis** | Tidak ada (form input saja) |
| **State/Interaksi** | Validasi: judul & deskripsi required, minimal 10 karakter. Upload: progress indicator per file. Submit: loading state pada tombol → sukses → navigate ke List Tiket + `SnackBar` konfirmasi. Konfirmasi keluar jika form sudah diisi (dialog "Yakin ingin keluar?"). |

---

## 2.8 Profile Screen

| Aspek | Detail |
|---|---|
| **Target Audiens** | Semua role |
| **Tujuan** | Melihat info profil, pengaturan, dan logout |
| **Layout** | Header (avatar + nama + role), list menu settings |
| **Komponen UI** | ① **Header Card**: Avatar besar (circular), Nama lengkap, Email, Role badge ② **Menu Items** (ListTile style): — Edit Profil (→ future) — Ubah Password (→ future) — Dark/Light Mode toggle (Switch) — Tentang Aplikasi — Keluar (merah, dengan icon logout) |
| **Data Dinamis** | `UserModel`: name, email, role, avatarUrl |
| **State/Interaksi** | Toggle dark mode → instant theme change. Logout → confirmation dialog → clear session → navigate ke Login. |

---

## 2.9 Notification Screen

| Aspek | Detail |
|---|---|
| **Target Audiens** | Semua role |
| **Tujuan** | Menampilkan notifikasi update tiket |
| **Layout** | `AppBar` ("Notifikasi"), `ListView` notifikasi |
| **Komponen UI** | ① **Notification Tile**: icon tipe, judul, deskripsi singkat, waktu relatif ("2 jam lalu"), indicator unread (dot) ② **Empty State**: ilustrasi + "Tidak ada notifikasi" |
| **Data Dinamis** | `List<NotificationModel>`: title, body, type, isRead, createdAt, ticketId |
| **State/Interaksi** | Tap → navigate ke Detail Tiket terkait. Mark as read on tap. |

---

# 3. Strategi Implementasi Bertahap

---

## Phase 1 — Project Scaffolding & Core Layer

**Tujuan:** Fondasi proyek siap digunakan.

| # | Task | File/Output |
|---|---|---|
| 1 | Buat seluruh folder structure sesuai §1.2 | `lib/core/*`, `lib/features/*` |
| 2 | Tambah dependencies di `pubspec.yaml` | `provider`, `intl`, `image_picker`, `google_fonts` |
| 3 | Setup `app_colors.dart`, `app_sizes.dart`, `app_strings.dart` | `core/constants/` |
| 4 | Buat `app_theme.dart` (light & dark ThemeData) | `core/theme/` |
| 5 | Buat `theme_provider.dart` (toggle dark/light) | `core/theme/` |
| 6 | Buat reusable widgets: `custom_button`, `custom_text_field`, `status_badge`, `empty_state_widget`, `loading_widget` | `core/widgets/` |
| 7 | Setup `main.dart` → `MultiProvider` → `app.dart` | `lib/main.dart`, `lib/app.dart` |
| 8 | Definisikan named routes di `app.dart` | `lib/app.dart` |

---

## Phase 2 — Data Layer (Interface & Dummy Data)

**Tujuan:** Semua model dan repository siap dipakai oleh presentation layer.

### 2.1 Models

| Model | Fields Utama |
|---|---|
| `UserModel` | `id`, `name`, `email`, `username`, `role` (enum: user/helpdesk/admin), `avatarUrl` |
| `TicketModel` | `id`, `ticketNumber`, `title`, `description`, `category`, `priority`, `status` (enum: open/inProgress/closed), `createdAt`, `updatedAt`, `reporterId`, `assigneeId`, `attachments[]` |
| `CommentModel` | `id`, `ticketId`, `userId`, `userName`, `content`, `createdAt` |
| `DashboardStatsModel` | `totalTickets`, `openCount`, `inProgressCount`, `closedCount` |
| `NotificationModel` | `id`, `title`, `body`, `type`, `isRead`, `createdAt`, `ticketId` |

### 2.2 Repository Interfaces & Dummy Implementations

| Interface | Method Signatures | Dummy File |
|---|---|---|
| `AuthRepository` | `login()`, `logout()`, `register()`, `getCurrentUser()` | `dummy_auth_repository.dart` |
| `TicketRepository` | `getTickets()`, `getTicketById()`, `createTicket()`, `updateStatus()`, `addComment()`, `getComments()` | `dummy_ticket_repository.dart` |
| `DashboardRepository` | `getStats()`, `getRecentTickets()` | `dummy_dashboard_repository.dart` |
| `NotificationRepository` | `getNotifications()`, `markAsRead()` | `dummy_notification_repository.dart` |
| `ProfileRepository` | `getUserProfile()`, `updateProfile()` | `dummy_profile_repository.dart` |

**Aturan Penamaan:** Semua file dummy **WAJIB** mengandung kata `dummy` di nama file.

Setiap `dummy_*_repository.dart` berisi data statis `List<Model>` dan `Future.delayed` untuk simulasi latency jaringan.

---

## Phase 3 — UI Integration & Refactoring (Post-Figma)

**Tujuan:** Kode UI dari Figma terintegrasi ke arsitektur Feature-First.

### Alur Kerja:

1. **Terima aset dari Figma** → export sebagai Flutter code / screenshot.
2. **Refactor** kode Figma:
   - Pisahkan widget reusable ke `core/widgets/`.
   - Pindahkan style ke `app_theme.dart` / `app_colors.dart`.
   - Buat widget spesifik fitur di `features/[feature]/presentation/widgets/`.
3. **Susun halaman** di `features/[feature]/presentation/pages/`.
4. **Pastikan** setiap halaman menggunakan `Scaffold`, menerima data melalui constructor/provider, dan tidak hardcode data.

### Checklist Refactoring per Screen:

- [ ] Splash Screen → `auth/presentation/pages/splash_page.dart`
- [ ] Login Screen → `auth/presentation/pages/login_page.dart`
- [ ] Register Screen → `auth/presentation/pages/register_page.dart`
- [ ] Dashboard → `dashboard/presentation/pages/dashboard_page.dart`
- [ ] List Tiket → `ticket/presentation/pages/ticket_list_page.dart`
- [ ] Detail Tiket → `ticket/presentation/pages/ticket_detail_page.dart`
- [ ] Create Tiket → `ticket/presentation/pages/create_ticket_page.dart`
- [ ] Profile → `profile/presentation/pages/profile_page.dart`
- [ ] Notifikasi → `notification/presentation/pages/notification_page.dart`

---

## Phase 4 — State Management Integration

**Tujuan:** Semua layar terhubung dengan Provider dan data dummy berjalan penuh.

### 4.1 Providers

| Provider | State & Logic |
|---|---|
| `AuthProvider` | `currentUser`, `isLoading`, `errorMessage`, `login()`, `logout()`, `register()` |
| `TicketProvider` | `tickets[]`, `selectedTicket`, `comments[]`, `isLoading`, `filterStatus`, `searchQuery`, `fetchTickets()`, `fetchDetail()`, `createTicket()`, `updateStatus()`, `addComment()` |
| `DashboardProvider` | `stats`, `recentTickets[]`, `isLoading`, `fetchDashboard()` |
| `NotificationProvider` | `notifications[]`, `unreadCount`, `fetchNotifications()`, `markAsRead()` |
| `ProfileProvider` | `userProfile`, `fetchProfile()`, `updateProfile()` |
| `ThemeProvider` | `isDarkMode`, `toggleTheme()` |

### 4.2 Integrasi

1. Register semua Provider di `MultiProvider` (`main.dart`).
2. Inject `DummyRepository` ke setiap Provider via constructor.
3. Halaman menggunakan `Consumer` / `context.watch` untuk reactive UI.
4. Implementasi pull-to-refresh, lazy loading, dan search/filter di `TicketProvider`.

---

## Phase 5 — Rencana Migrasi Supabase (Future)

Ketika backend Supabase sudah siap:

| # | Langkah | Detail |
|---|---|---|
| 1 | Tambah `supabase_flutter` ke `pubspec.yaml` | — |
| 2 | Buat `core/network/supabase_client.dart` | Init & config Supabase |
| 3 | Buat `supabase_auth_repository.dart` | `implements AuthRepository` → gunakan `supabase.auth` |
| 4 | Buat `supabase_ticket_repository.dart` | `implements TicketRepository` → gunakan `supabase.from('tickets')` |
| 5 | Buat sisa `supabase_*_repository.dart` | Untuk dashboard, notifikasi, profil |
| 6 | **Swap di `main.dart`** | Ganti `DummyTicketRepository()` → `SupabaseTicketRepository()` |
| 7 | Hapus / arsipkan file `dummy_*` | Opsional, untuk kebersihan kode |

> **Prinsip:** Tidak ada perubahan di layer `presentation` (pages, providers, widgets). Cukup swap implementasi repository.

---

## Phase 6 — Finalisasi & Testing

### 6.1 Testing

| Tipe | Scope | Tool |
|---|---|---|
| **Unit Test** | Model serialization, repository methods | `flutter_test` |
| **Widget Test** | Form validation, button states, widget rendering | `flutter_test` |
| **Integration Test** | Flow: Login → Dashboard → Create Tiket → Detail | `integration_test` |

### 6.2 Dokumentasi

- Buat `AGENT.md` berisi: arsitektur, cara menjalankan, konvensi penamaan, dan cara menambah fitur baru.
- Update `README.md` dengan screenshot dan instruksi setup.

---

# 4. Definition of Done (Fase Dummy Data)

Fase dummy data dianggap **selesai** jika semua kriteria berikut terpenuhi:

### Fungsional (berdasarkan SRS FR)

- [ ] **FR-001** Login: User bisa login dengan username & password dummy → masuk Dashboard
- [ ] **FR-002** Logout: User bisa logout → kembali ke Login
- [ ] **FR-003** Register: User baru bisa mendaftar (tersimpan di memori)
- [ ] **FR-004** Reset Password: Tersedia tombol/link (tampilkan pesan placeholder)
- [ ] **FR-005** User Tiket: User bisa membuat tiket, upload lampiran (dummy), melihat daftar & detail, memberikan komentar
- [ ] **FR-006** Admin/Helpdesk Tiket: Bisa melihat semua tiket, update status, assign tiket
- [ ] **FR-007** Notifikasi: List notifikasi tampil, tap navigasi ke tiket terkait
- [ ] **FR-008** Dashboard: Statistik tiket tampil dengan data dummy yang benar
- [ ] **FR-010** Riwayat: Riwayat penanganan tiket bisa dilihat
- [ ] **FR-011** Tracking: Timeline status tiket tampil di Detail Tiket

### Non-Fungsional (berdasarkan SRS NFR)

- [ ] **NFR-4.1 Performance:** Lazy loading pada list tiket berfungsi
- [ ] **NFR-4.2 Usability:** UI responsive, konsisten antar halaman, mudah digunakan
- [ ] **NFR-4.3 Compatibility:** Berjalan baik di Android & iOS, berbagai ukuran layar
- [ ] **NFR-4.4 Maintainability:** Arsitektur Feature-First diterapkan, semua repository menggunakan interface

### Teknis

- [ ] Dark & Light mode berfungsi dengan toggle di Profile
- [ ] Semua file dummy mengandung kata `dummy` di nama file
- [ ] Tidak ada hardcoded data di layer presentation
- [ ] Provider hanya berinteraksi dengan Repository Interface (abstract class)
- [ ] Semua named routes terdefinisi dan berfungsi
- [ ] Minimal 1 unit test per repository dan 1 widget test per halaman utama
- [ ] `AGENT.md` tersedia dengan dokumentasi arsitektur

---

## Dependency yang Dibutuhkan

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  google_fonts: ^6.2.1
  intl: ^0.19.0
  image_picker: ^1.1.2
  cached_network_image: ^3.4.1
  shimmer: ^3.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  integration_test:
    sdk: flutter
```
