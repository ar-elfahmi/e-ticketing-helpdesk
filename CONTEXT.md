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

**Gaps remaining:**
- Integrasi API backend (ApiClient stub)
- Upload file ke backend
- Push notification (FCM)
