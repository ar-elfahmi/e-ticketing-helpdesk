# Task List — E-Ticketing Helpdesk

> Berdasarkan [implementation_plan.md](file:///C:/Users/lenov/.gemini/antigravity/brain/0f75f98f-9d34-4619-adc4-3640542ec4e8/implementation_plan.md)

---

## Phase 1 — Project Scaffolding & Core Layer

### 1.1 Folder Structure
- [ ] Buat folder `lib/core/constants/`
- [ ] Buat folder `lib/core/network/`
- [ ] Buat folder `lib/core/services/`
- [ ] Buat folder `lib/core/theme/`
- [ ] Buat folder `lib/core/widgets/`
- [ ] Buat folder `lib/features/auth/data/models/`
- [ ] Buat folder `lib/features/auth/data/repositories/`
- [ ] Buat folder `lib/features/auth/presentation/pages/`
- [ ] Buat folder `lib/features/auth/presentation/providers/`
- [ ] Buat folder `lib/features/auth/presentation/widgets/`
- [ ] Buat folder `lib/features/dashboard/data/models/`
- [ ] Buat folder `lib/features/dashboard/data/repositories/`
- [ ] Buat folder `lib/features/dashboard/presentation/pages/`
- [ ] Buat folder `lib/features/dashboard/presentation/providers/`
- [ ] Buat folder `lib/features/dashboard/presentation/widgets/`
- [ ] Buat folder `lib/features/ticket/data/models/`
- [ ] Buat folder `lib/features/ticket/data/repositories/`
- [ ] Buat folder `lib/features/ticket/presentation/pages/`
- [ ] Buat folder `lib/features/ticket/presentation/providers/`
- [ ] Buat folder `lib/features/ticket/presentation/widgets/`
- [ ] Buat folder `lib/features/notification/data/models/`
- [ ] Buat folder `lib/features/notification/data/repositories/`
- [ ] Buat folder `lib/features/notification/presentation/pages/`
- [ ] Buat folder `lib/features/notification/presentation/providers/`
- [ ] Buat folder `lib/features/notification/presentation/widgets/`
- [ ] Buat folder `lib/features/profile/data/repositories/`
- [ ] Buat folder `lib/features/profile/presentation/pages/`
- [ ] Buat folder `lib/features/profile/presentation/providers/`
- [ ] Buat folder `lib/features/profile/presentation/widgets/`

### 1.2 Dependencies
- [ ] Tambah `provider` ke `pubspec.yaml`
- [ ] Tambah `google_fonts` ke `pubspec.yaml`
- [ ] Tambah `intl` ke `pubspec.yaml`
- [ ] Tambah `image_picker` ke `pubspec.yaml`
- [ ] Tambah `cached_network_image` ke `pubspec.yaml`
- [ ] Tambah `shimmer` ke `pubspec.yaml`
- [ ] Jalankan `flutter pub get`

### 1.3 Constants
- [ ] Buat `lib/core/constants/app_colors.dart` — palet warna light & dark
- [ ] Buat `lib/core/constants/app_sizes.dart` — spacing, radius, padding
- [ ] Buat `lib/core/constants/app_strings.dart` — string statis, label, route names

### 1.4 Theme
- [ ] Buat `lib/core/theme/app_theme.dart` — ThemeData light & dark
- [ ] Buat `lib/core/theme/theme_provider.dart` — ChangeNotifier toggle dark/light

### 1.5 Core Widgets
- [ ] Buat `lib/core/widgets/custom_button.dart`
- [ ] Buat `lib/core/widgets/custom_text_field.dart`
- [ ] Buat `lib/core/widgets/status_badge.dart`
- [ ] Buat `lib/core/widgets/empty_state_widget.dart`
- [ ] Buat `lib/core/widgets/loading_widget.dart`

### 1.6 App Entry Point & Routing
- [ ] Buat `lib/app.dart` — MaterialApp, ThemeData, named routes
- [ ] Refactor `lib/main.dart` — MultiProvider wrapper → `App()`
- [ ] Definisikan semua named routes di `app.dart`
- [ ] Buat `lib/core/services/navigation_service.dart`

---

## Phase 2 — Data Layer (Interface & Dummy Data)

### 2.1 Models
- [ ] Buat `lib/features/auth/data/models/user_model.dart`
- [ ] Buat `lib/features/ticket/data/models/ticket_model.dart`
- [ ] Buat `lib/features/ticket/data/models/comment_model.dart`
- [ ] Buat `lib/features/dashboard/data/models/dashboard_stats_model.dart`
- [ ] Buat `lib/features/notification/data/models/notification_model.dart`

### 2.2 Repository Interfaces (Abstract Classes)
- [ ] Buat `lib/features/auth/data/repositories/auth_repository.dart`
- [ ] Buat `lib/features/ticket/data/repositories/ticket_repository.dart`
- [ ] Buat `lib/features/dashboard/data/repositories/dashboard_repository.dart`
- [ ] Buat `lib/features/notification/data/repositories/notification_repository.dart`
- [ ] Buat `lib/features/profile/data/repositories/profile_repository.dart`

### 2.3 Dummy Implementations
- [ ] Buat `lib/features/auth/data/repositories/dummy_auth_repository.dart`
  - [ ] Implementasi `login()` dengan 3 user dummy (user, helpdesk, admin)
  - [ ] Implementasi `logout()`
  - [ ] Implementasi `register()`
  - [ ] Implementasi `getCurrentUser()`
- [ ] Buat `lib/features/ticket/data/repositories/dummy_ticket_repository.dart`
  - [ ] Data dummy 10-15 tiket dengan variasi status, kategori, prioritas
  - [ ] Implementasi `getTickets()` dengan filter & search
  - [ ] Implementasi `getTicketById()`
  - [ ] Implementasi `createTicket()`
  - [ ] Implementasi `updateStatus()`
  - [ ] Implementasi `addComment()` & `getComments()`
- [ ] Buat `lib/features/dashboard/data/repositories/dummy_dashboard_repository.dart`
  - [ ] Implementasi `getStats()` — hitung dari data tiket dummy
  - [ ] Implementasi `getRecentTickets()`
- [ ] Buat `lib/features/notification/data/repositories/dummy_notification_repository.dart`
  - [ ] Data dummy 5-10 notifikasi
  - [ ] Implementasi `getNotifications()`
  - [ ] Implementasi `markAsRead()`
- [ ] Buat `lib/features/profile/data/repositories/dummy_profile_repository.dart`
  - [ ] Implementasi `getUserProfile()`
  - [ ] Implementasi `updateProfile()`

---

## Phase 3 — UI Integration & Refactoring (Post-Figma)

### 3.1 Auth Screens
- [ ] Buat/Refactor `lib/features/auth/presentation/pages/splash_page.dart`
  - [ ] Logo + animasi fade-in
  - [ ] Auto-redirect setelah 2 detik (cek auth)
- [ ] Buat/Refactor `lib/features/auth/presentation/pages/login_page.dart`
  - [ ] Form username & password
  - [ ] Validasi inline
  - [ ] Tombol login dengan loading state
  - [ ] Link ke Register & Lupa Password
- [ ] Buat/Refactor `lib/features/auth/presentation/pages/register_page.dart`
  - [ ] Form: nama, email, username, password, konfirmasi password
  - [ ] Validasi semua field
  - [ ] Tombol daftar dengan loading state
- [ ] Buat `lib/features/auth/presentation/widgets/auth_form_widget.dart`

### 3.2 Dashboard Screen
- [ ] Buat/Refactor `lib/features/dashboard/presentation/pages/dashboard_page.dart`
  - [ ] AppBar: judul, icon notifikasi (badge), avatar
  - [ ] Greeting card dengan nama & role
  - [ ] Stats cards grid 2×2
  - [ ] Daftar tiket terbaru
  - [ ] FAB (khusus User)
  - [ ] Pull-to-refresh
- [ ] Buat `lib/features/dashboard/presentation/widgets/stats_card_widget.dart`
- [ ] Buat `lib/features/dashboard/presentation/widgets/recent_ticket_widget.dart`

### 3.3 Ticket Screens
- [ ] Buat/Refactor `lib/features/ticket/presentation/pages/ticket_list_page.dart`
  - [ ] Search bar
  - [ ] Filter chips (Semua, Open, In Progress, Closed)
  - [ ] ListView dengan lazy loading
  - [ ] Empty state
  - [ ] FAB (khusus User)
- [ ] Buat/Refactor `lib/features/ticket/presentation/pages/ticket_detail_page.dart`
  - [ ] Section info tiket (judul, status, kategori, prioritas, tanggal, pelapor, deskripsi, lampiran)
  - [ ] Section timeline/tracking status
  - [ ] Section komentar/reply
  - [ ] Input komentar sticky bottom
  - [ ] Tombol aksi Helpdesk/Admin (ubah status, assign)
- [ ] Buat/Refactor `lib/features/ticket/presentation/pages/create_ticket_page.dart`
  - [ ] Form: judul, kategori (dropdown), prioritas (dropdown), deskripsi
  - [ ] Upload area (kamera + file)
  - [ ] Validasi field required
  - [ ] Tombol kirim sticky bottom
  - [ ] Dialog konfirmasi keluar
- [ ] Buat `lib/features/ticket/presentation/widgets/ticket_card_widget.dart`
- [ ] Buat `lib/features/ticket/presentation/widgets/ticket_status_timeline.dart`
- [ ] Buat `lib/features/ticket/presentation/widgets/comment_bubble_widget.dart`

### 3.4 Notification Screen
- [ ] Buat/Refactor `lib/features/notification/presentation/pages/notification_page.dart`
  - [ ] ListView notifikasi
  - [ ] Indicator unread
  - [ ] Empty state
- [ ] Buat `lib/features/notification/presentation/widgets/notification_tile_widget.dart`

### 3.5 Profile Screen
- [ ] Buat/Refactor `lib/features/profile/presentation/pages/profile_page.dart`
  - [ ] Header card (avatar, nama, email, role badge)
  - [ ] Menu items (edit profil, ubah password, dark/light toggle, tentang, logout)
  - [ ] Dialog konfirmasi logout
- [ ] Buat `lib/features/profile/presentation/widgets/profile_menu_item.dart`

### 3.6 Bottom Navigation
- [ ] Implementasi `BottomNavigationBar` (Dashboard, Tiket, Profile)
- [ ] Buat shell/wrapper page untuk navigasi antar tab

---

## Phase 4 — State Management Integration

### 4.1 Providers
- [ ] Buat `lib/features/auth/presentation/providers/auth_provider.dart`
  - [ ] State: `currentUser`, `isLoading`, `errorMessage`
  - [ ] Methods: `login()`, `logout()`, `register()`
- [ ] Buat `lib/features/ticket/presentation/providers/ticket_provider.dart`
  - [ ] State: `tickets[]`, `selectedTicket`, `comments[]`, `isLoading`, `filterStatus`, `searchQuery`
  - [ ] Methods: `fetchTickets()`, `fetchDetail()`, `createTicket()`, `updateStatus()`, `addComment()`
  - [ ] Implementasi search/filter logic
  - [ ] Implementasi lazy loading / pagination
- [ ] Buat `lib/features/dashboard/presentation/providers/dashboard_provider.dart`
  - [ ] State: `stats`, `recentTickets[]`, `isLoading`
  - [ ] Methods: `fetchDashboard()`
- [ ] Buat `lib/features/notification/presentation/providers/notification_provider.dart`
  - [ ] State: `notifications[]`, `unreadCount`
  - [ ] Methods: `fetchNotifications()`, `markAsRead()`
- [ ] Buat `lib/features/profile/presentation/providers/profile_provider.dart`
  - [ ] State: `userProfile`
  - [ ] Methods: `fetchProfile()`, `updateProfile()`

### 4.2 Integrasi Provider ↔ UI
- [ ] Register semua Provider di `MultiProvider` (`main.dart`)
- [ ] Inject `DummyRepository` ke setiap Provider via constructor
- [ ] Hubungkan `splash_page` → AuthProvider (cek auth)
- [ ] Hubungkan `login_page` → AuthProvider
- [ ] Hubungkan `register_page` → AuthProvider
- [ ] Hubungkan `dashboard_page` → DashboardProvider + AuthProvider
- [ ] Hubungkan `ticket_list_page` → TicketProvider
- [ ] Hubungkan `ticket_detail_page` → TicketProvider
- [ ] Hubungkan `create_ticket_page` → TicketProvider
- [ ] Hubungkan `notification_page` → NotificationProvider
- [ ] Hubungkan `profile_page` → ProfileProvider + ThemeProvider + AuthProvider

### 4.3 Verifikasi Flow End-to-End
- [ ] Flow: Splash → Login → Dashboard (role User)
- [ ] Flow: Dashboard → Buat Tiket → List Tiket (muncul tiket baru)
- [ ] Flow: List Tiket → Detail Tiket → Tambah Komentar
- [ ] Flow: Helpdesk Login → Lihat Semua Tiket → Update Status
- [ ] Flow: Profile → Toggle Dark Mode → Logout → Login
- [ ] Flow: Dashboard → Icon Notifikasi → Notifikasi → Tap → Detail Tiket

---

## Phase 5 — Rencana Migrasi Supabase (Future)

> _Fase ini ditunda hingga backend Supabase siap._

- [ ] Tambah `supabase_flutter` ke `pubspec.yaml`
- [ ] Buat `lib/core/network/supabase_client.dart`
- [ ] Buat `supabase_auth_repository.dart` (implements `AuthRepository`)
- [ ] Buat `supabase_ticket_repository.dart` (implements `TicketRepository`)
- [ ] Buat `supabase_dashboard_repository.dart` (implements `DashboardRepository`)
- [ ] Buat `supabase_notification_repository.dart` (implements `NotificationRepository`)
- [ ] Buat `supabase_profile_repository.dart` (implements `ProfileRepository`)
- [ ] Swap dummy → supabase di `MultiProvider` (`main.dart`)
- [ ] Testing end-to-end dengan backend real

---

## Phase 6 — Finalisasi & Testing

### 6.1 Unit Tests
- [ ] Test `UserModel` serialization
- [ ] Test `TicketModel` serialization
- [ ] Test `CommentModel` serialization
- [ ] Test `DummyAuthRepository` — login, logout, register
- [ ] Test `DummyTicketRepository` — CRUD, filter, search
- [ ] Test `DummyDashboardRepository` — stats calculation
- [ ] Test `DummyNotificationRepository` — fetch, markAsRead

### 6.2 Widget Tests
- [ ] Test `login_page` — validasi form, loading state
- [ ] Test `register_page` — validasi form
- [ ] Test `dashboard_page` — render stats cards
- [ ] Test `ticket_list_page` — render list, filter, empty state
- [ ] Test `create_ticket_page` — validasi form
- [ ] Test `ticket_card_widget` — render data
- [ ] Test `status_badge` — warna sesuai status

### 6.3 Integration Tests
- [ ] Flow lengkap: Login → Dashboard → Create Tiket → Detail → Logout

### 6.4 Dokumentasi
- [ ] Buat `AGENT.md` — arsitektur, konvensi, cara run, cara tambah fitur
- [ ] Update `README.md` — deskripsi project, screenshot, instruksi setup
