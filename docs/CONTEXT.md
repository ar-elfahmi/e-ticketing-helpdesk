## 2026-06-19: Reset Password (FR-004)

**Files touched:**
- `lib/features/auth/data/repositories/auth_repository.dart` — added `resetPassword(String emailOrUsername) -> Future<bool>` to abstract
- `lib/features/auth/data/repositories/dummy_auth_repository.dart` — implemented `resetPassword`, validates against email/username in memory
- `lib/features/auth/presentation/providers/auth_provider.dart` — added `resetPassword()` method, delegates to repo
- `lib/features/auth/presentation/pages/forgot_password_page.dart` — **new page**: form with email/username input, gradient header matching login style, success snackbar + pop back
- `lib/features/auth/presentation/pages/login_page.dart` — "Lupa Password?" now navigates to `/forgot-password` instead of placeholder snackbar
- `lib/core/constants/app_strings.dart` — added `forgotPassword` route, removed `forgotPasswordPlaceholder`, added i18n strings
- `lib/app.dart` — registered `ForgotPasswordPage` at `AppRoutes.forgotPassword`

**Decisions:**
- Simple email/username validation flow (dummy). No actual email sending — validates existence, shows success, pops back to login.

**GitHub remote:**
- Remote updated from `ar-elfahmi/-E-Ticketing-Helpdesk` to `ar-elfahmi/e-ticketing-helpdesk`
- Pushed `main` to `https://github.com/ar-elfahmi/e-ticketing-helpdesk.git`

## 2026-06-19: Fase 0 & 1 Supabase Setup + Auth Migration

**Files touched:**
- `pubspec.yaml` — tambah `supabase_flutter: ^2.8.4`
- `lib/core/network/supabase_config.dart` — **baru**: init Supabase client
- `lib/features/auth/data/repositories/supabase_auth_repository.dart` — **baru**: auth via Supabase Auth (login by email/username, signup, logout, resetPassword, getCurrentUser)
- `lib/main.dart` — init Supabase sebelum runApp, AuthProvider pakai `SupabaseAuthRepository`, dummyAuthRepository dipertahankan untuk profile

**Decisions:**
- Supabase project: `https://wtwpbecqrniszlggtxqg.supabase.co`
- Login: jika input mengandung '@' → langsung sbg email; jika tidak → RPC `get_email_by_username` lookup
- Profile dibuat otomatis via DB trigger `handle_new_user()` dari `raw_user_meta_data`
- RLS: user lihat/edit profile sendiri, admin lihat semua

**Gaps remaining:**
- Fase 2: Ticket CRUD ke Supabase DB
- Fase 3: Storage upload
- Upload file ke backend
- Push notification (FCM)

## 2026-07-06: Ticket Status Flow — Assign & Role-Based Transitions

**Files touched:**
- `lib/features\ticket\presentation\pages\ticket_detail_page.dart` — replaced status transition logic:
  - **Admin**: dropdown menampilkan SEMUA `TicketStatus` (`_adminUpdateStatus`), plus "Terima Tiket" button (`_adminAccept`) ubah `open → assign`
  - **Helpdesk**: "Terima & Kerjakan" button (`_helpdeskAccept`) self-assign + ubah `assign → inProgress`; "Selesaikan Tiket" button (`_helpdeskFinish`) ubah `inProgress → closed`
  - Removed old `_updateStatus`, `_getValidStatusOptions`, `_assignTicket` (bottom sheet picker)
- `lib/features\ticket\presentation\pages\ticket_list_page.dart` — added "Assign" filter chip

**Decisions:**
- Admin punya kendali penuh atas status via dropdown berisi semua nilai enum
- Helpdesk hanya punya tombol kontekstual sesuai status saat itu (assign/inProgress)
- Self-assign: helpdesk accept set assigneeId = current user id
- Tidak perlu perubahan di `supabase_ticket_repository.dart` — `assignTicket` dan `updateStatus` sudah generic
