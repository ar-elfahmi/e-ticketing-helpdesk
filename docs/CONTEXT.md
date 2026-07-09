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

**Follow-up:**
- Supabase recovery links now redirect to `/reset-password`, and the app opens a dedicated password update page when the recovery session is active.

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

## 2026-07-08: Fix Reset Password Flow — Recovery Detection + updatePassword Missing

**Files touched:**
- `lib/features/auth/data/repositories/auth_repository.dart` — added `updatePassword(String newPassword) -> Future<bool>` to abstract
- `lib/features/auth/data/repositories/supabase_auth_repository.dart` — implemented `updatePassword` via `_supabase.auth.updateUser(UserAttributes(password: newPassword))`
- `lib/features/auth/data/repositories/dummy_auth_repository.dart` — implemented `updatePassword` (updates in-memory password map)
- `lib/features/auth/presentation/providers/auth_provider.dart` — added `updatePassword()` method, added `isRecoveryFlow` flag with `setRecoveryFlow()`/`clearRecoveryFlow()`
- `lib/features/auth/presentation/pages/splash_page.dart` — added `onAuthStateChange` listener for `passwordRecovery`; moved recovery URI check BEFORE 2-second delay; re-checks `Uri.base` after delay AND after `bootstrap()`; checks `authProvider.isRecoveryFlow` as fallback
- `lib/features/auth/presentation/pages/reset_password_page.dart` — added `onAuthStateChange` listener for `passwordRecovery` (retries session bootstrap); retries `bootstrap()` with 1.5s delay if first attempt fails; added `_isRecoveryUri()` check for deep link params
- `lib/app.dart` — added `context.read<AuthProvider>().setRecoveryFlow()` to the `passwordRecovery` event handler

**Decisions:**
- Critical bug: `updatePassword()` was called in `ResetPasswordPage` but never implemented in repository/provider chain — now fixed
- Race condition on splash: splash was bootstrapping auth after 2s delay, finding supabase session active (from recovery deep link), navigating to `shell` instead of `resetPassword` — now splash checks URL before/during/after bootstrap AND subscribes to `onAuthStateChange.passwordRecovery`
- ResetPasswordPage now retries session bootstrap after 1.5s if supabase hasn't processed deep link yet
- `isRecoveryFlow` flag on `AuthProvider` coordinates recovery state across `app.dart`, `splash_page.dart`, and `reset_password_page.dart`

**Gotchas:**
- Supabase processes deep link tokens async; `getCurrentUser()` may return null at first attempt even when app opens via recovery link
- On web, `Uri.base.fragment` contains the recovery tokens (`access_token=xxx&type=recovery`) — all 3 detection points (`main.dart`, `splash_page.dart`, `reset_password_page.dart`) check fragment
- If Supabase dashboard "Site URL" is not set to the correct app URL (e.g., `http://localhost:port`), the recovery redirect won't reach the app with the correct parameters — check Supabase Auth → Settings → Site URL
