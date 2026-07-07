# E-Ticketing Helpdesk - Dokumentasi Kontrak Data dan Repository

## Ringkasan

E-Ticketing Helpdesk adalah aplikasi mobile Flutter untuk pelaporan, monitoring, dan penyelesaian tiket layanan IT dengan tiga peran pengguna: `user`, `helpdesk`, dan `admin`.

Implementasi aktif aplikasi saat ini sudah memakai Supabase sebagai backend utama untuk sebagian besar fitur. Alur dependency injection di `lib/main.dart` adalah:

- `AuthRepository` -> `SupabaseAuthRepository`
- `TicketRepository` -> `SupabaseTicketRepository`
- `NotificationRepository` -> `SupabaseNotificationRepository`
- `ProfileRepository` -> `SupabaseProfileRepository`
- `DashboardRepository` -> `DummyDashboardRepository` yang menghitung statistik dari `TicketRepository`

File `lib/core/network/api_client.dart` masih stub, tetapi tidak dipakai oleh alur utama aplikasi saat ini.

## Teknologi dan Konfigurasi

| Komponen | Detail |
| --- | --- |
| Framework | Flutter |
| Bahasa | Dart |
| State management | `provider: ^6.1.2` |
| Backend | `supabase_flutter: ^2.8.4` |
| Tipografi | `google_fonts: ^6.2.1` |
| Format tanggal | `intl: ^0.19.0` |
| Pemilih file / gambar | `image_picker: ^1.1.2`, `file_picker: ^8.0.0` |
| Caching gambar | `cached_network_image: ^3.4.1` |
| Skeleton loading | `shimmer: ^3.0.0` |
| Linter | `flutter_lints: ^6.0.0` |

`SupabaseConfig.initialize()` dipanggil saat startup dan konfigurasi Supabase masih hardcoded di `lib/core/network/supabase_config.dart`. Tidak ditemukan file `.env` atau base URL REST lain.

## Arsitektur

- Pola utama: Feature-First + Provider + Repository Pattern.
- Direktori penting:
  - `lib/core/` untuk konfigurasi, tema, dan utilitas.
  - `lib/features/<fitur>/data/` untuk model dan repository.
  - `lib/features/<fitur>/presentation/` untuk provider, halaman, dan widget.
- Fitur aktif: `auth`, `dashboard`, `ticket`, `notification`, `profile`.

## Skema Data

Semua timestamp diserialisasikan ke ISO 8601.

### `UserModel`

Field:

- `id`
- `name`
- `email`
- `username`
- `role`
- `avatarUrl`
- `deletedAt`
- `deletedBy`

Serialisasi `toMap()`:

```json
{
  "id": "u1",
  "name": "Ari Pratama",
  "email": "ari.user@example.com",
  "username": "user",
  "role": "user",
  "avatarUrl": null,
  "deleted_at": null,
  "deleted_by": null
}
```

Catatan: `fromMap()` menerima `avatar_url` atau `avatarUrl`.

### `TicketModel`

Field:

- `id`
- `ticketNumber`
- `title`
- `description`
- `category`
- `priority`
- `status`
- `createdAt`
- `updatedAt`
- `reporterId`
- `assigneeId`
- `attachments`
- `history`
- `deletedAt`

`history` berisi daftar `StatusHistory` dengan field:

- `status`
- `changedBy`
- `changedAt`
- `note`

### `CommentModel`

Field:

- `id`
- `ticketId`
- `userId`
- `userName`
- `content`
- `createdAt`

### `NotificationModel`

Field:

- `id`
- `title`
- `body`
- `type`
- `isRead`
- `createdAt`
- `ticketId`
- `userId`

### `DashboardStatsModel`

Field:

- `totalTickets`
- `openCount`
- `inProgressCount`
- `closedCount`

## Enum

| Enum | Nilai string canonical |
| --- | --- |
| `UserRole` | `user`, `helpdesk`, `admin` |
| `TicketStatus` | `open`, `assign`, `inProgress`, `closed` |
| `TicketPriority` | `low`, `medium`, `high`, `critical` |
| `NotificationType` | `ticket`, `comment`, `general` |

`TicketStatusX.fromString()` juga menerima variasi `in_progress`, `inprogress`, dan `in progress`.

## Authentication dan Manajemen User

Repository aktif: `SupabaseAuthRepository`.

### `getUsers()`

Mengambil semua profil aktif dari tabel `profiles` dan mengurutkannya berdasarkan `name`.

### `getDeletedUsers()`

Mengambil profil yang sudah soft delete dari `profiles` dengan filter `deleted_at != null`.

### `deleteUser(userId, deletedBy)`

Melakukan soft delete pada `profiles` dengan mengisi `deleted_at` dan `deleted_by`.

### `restoreUser(userId)`

Menghapus tanda soft delete dengan mengosongkan `deleted_at` dan `deleted_by`.

### `login(username, password)`

- Input dapat berupa username atau email.
- Jika input bukan email, repository memanggil RPC `get_email_by_username` untuk mencari email terkait.
- Login menggunakan Supabase Auth.
- Setelah login sukses, profil diambil dari tabel `profiles`.
- Profil yang memiliki `deleted_at` tidak bisa dipakai login.

### `logout()`

Melakukan `signOut()` Supabase Auth.

### `register(name, email, username, password, role = 'user')`

Mendaftarkan user baru melalui Supabase Auth dan metadata profil.

### `getCurrentUser()`

Mengambil sesi aktif dari Supabase Auth, lalu memuat profil dari `profiles`.

### `resetPassword(emailOrUsername)`

- Jika input bukan email, repository memanggil RPC `get_email_by_username`.
- Setelah email ditemukan, Supabase Auth mengirim email reset password.

### Perilaku UI terkait user

- Admin user management ada di flow profil admin.
- Aplikasi mencegah admin menghapus akun yang sedang login.
- User yang dihapus ditampilkan terpisah agar bisa dipulihkan.

## Ticket Repository

Repository aktif: `SupabaseTicketRepository`.

### `getTickets(status, query, page, limit, reporterId)`

- Mengambil data dari tabel `tickets`.
- Mengabaikan baris dengan `deleted_at` terisi.
- Filter yang didukung:
  - `status`
  - `reporterId`
  - pencarian `query`
- Pencarian menggunakan `ilike` pada `ticket_number`, `title`, dan `category`.
- Hasil diurutkan berdasarkan `created_at` descending.
- Pagination memakai `range((page - 1) * limit, page * limit - 1)`.

### `getTicketById(ticketId)`

Mengambil satu tiket dari `tickets` dengan filter `deleted_at == null`.

### `createTicket(title, description, category, priority, reporterId, attachments)`

- Membuat tiket baru dengan status awal `open`.
- `attachments` disimpan sebagai daftar URL string.
- `history` awal diisi satu entri pembuatan tiket.

### `updateStatus(ticketId, status, updatedBy, note)`

- Mengubah `status` tiket.
- Menambahkan entri baru ke `history`.
- Jika tiket tidak ditemukan, hasilnya `null`.

### `assignTicket(ticketId, assigneeId, updatedBy)`

- Mengisi `assignee_id`.
- Menambahkan entri `history` baru dengan catatan assignment.

### `addComment(ticketId, userId, userName, content)`

- Menyimpan komentar ke tabel `comments`.
- Field yang dikirim: `ticket_id`, `user_id`, `user_name`, `content`.

### `getComments(ticketId)`

- Mengambil komentar berdasarkan `ticket_id`.
- Diurutkan dari yang paling lama (`created_at` ascending).

### `uploadAttachment(bytes, fileName)`

- Upload binary ke Supabase Storage bucket `ticket-attachments`.
- Path dibentuk sebagai `tickets/<timestamp>_<fileName>`.
- Method mengembalikan public URL file yang sudah diupload.

### `deleteTicket(ticketId)`

- Di Supabase, tiket di-soft delete dengan mengisi `deleted_at`.
- Di dummy repository, tiket dihapus dari list in-memory.

## Notification Repository

Repository aktif: `SupabaseNotificationRepository`.

### `getNotifications(userId)`

- Mengambil data dari tabel `notifications`.
- Jika `userId` diisi, data difilter berdasarkan `user_id`.
- Hasil diurutkan berdasarkan `created_at` descending.

### `markAsRead(notificationId)`

Mengubah `is_read` menjadi `true`.

### `createNotification(notification)`

Menambahkan baris baru ke tabel `notifications` menggunakan `toInsertMap()`.

### `subscribeToRealtime(userId, onNotification)`

- Mendengarkan event insert pada tabel `notifications` untuk user tertentu.
- Dipakai untuk notifikasi real-time di halaman notifikasi.

### `cancelRealtime()`

Menutup channel realtime aktif.

### `getAdminUserIds()` dan `getHelpdeskUserIds()`

Mengambil daftar `id` user berdasarkan role dari tabel `profiles`.

### Alur notifikasi di provider

- Tiket baru: notifikasi dikirim ke admin.
- Status tiket berubah: notifikasi dikirim ke reporter dan admin.
- Assignment tiket: notifikasi dikirim ke assignee.
- Notifikasi bisa disubscribe ulang saat user berubah.

## Profile Repository

Repository aktif: `SupabaseProfileRepository`.

### `getUserProfile(userId)`

Mengambil satu profil dari `profiles` berdasarkan `id`.

### `updateProfile(user)`

Mengupdate field `name`, `email`, `username`, `role`, dan `avatar_url` pada tabel `profiles`.

## Dashboard Repository

Repository aktif di app saat ini: `DummyDashboardRepository`.

### `getStats(reporterId)`

Menghitung statistik dari hasil `TicketRepository.getTickets()`:

- total tiket
- jumlah `open`
- jumlah `inProgress`
- jumlah `closed`

### `getRecentTickets(reporterId, limit)`

Mengambil tiket terbaru berdasarkan `updatedAt` descending.

## Base URL dan Endpoint

Dokumentasi ini tidak memakai endpoint REST publik karena app berbicara langsung ke Supabase melalui repository. Yang relevan adalah tabel, RPC, dan storage bucket berikut:

- `profiles`
- `tickets`
- `comments`
- `notifications`
- Storage bucket `ticket-attachments`
- RPC `get_email_by_username`

## Catatan Error Handling

- Repository Supabase umumnya mengembalikan objek model atau `null`/`false` jika data tidak ditemukan atau operasi gagal.
- Provider di presentation layer menangani error user-facing, misalnya login gagal, registrasi gagal, logout gagal, hapus user gagal, dan restore user gagal.

## Catatan Tambahan

- `ApiClient` masih stub dan belum dipakai alur aktif.
- Middleware, interceptor jaringan, rate limiting, dan versioning API tidak ditemukan di source code.
- Semua data demo awal berada di repository dummy, tetapi mode aktif aplikasi saat ini sudah bergantung pada Supabase.
- Dokumentasi ini perlu disesuaikan lagi jika skema tabel Supabase atau implementasi repository berubah.
