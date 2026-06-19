# E-Ticketing Helpdesk — Dokumentasi Kontrak API

## Deskripsi

E-Ticketing Helpdesk adalah aplikasi **mobile (Flutter)** yang digunakan untuk pelaporan, monitoring, dan penyelesaian tiket layanan IT. Aplikasi mendukung tiga peran pengguna: `user`, `helpdesk`, dan `admin`.

> **Catatan penting:**
> Proyek ini adalah aplikasi **klien (Flutter)**, **bukan** server/backend API HTTP. Tidak ditemukan endpoint REST/GraphQL nyata pada source code. File `lib/core/network/api_client.dart` masih berupa stub yang sengaja melempar `UnimplementedError` pada seluruh method (`get` dan `post`).
>
> Seluruh data saat ini disuplai oleh **repository dummy in-memory** (`DummyAuthRepository`, `DummyTicketRepository`, `DummyDashboardRepository`, `DummyNotificationRepository`, `DummyProfileRepository`) yang menyimulasikan latensi jaringan dengan `Future.delayed`.
>
> Dokumentasi di bawah ini mendokumentasikan **kontrak antarmuka repository** (abstract class) yang menjadi acuan integrasi backend di masa mendatang (sesuai catatan pada `README.md` bahwa rencananya akan dimigrasi ke Supabase). Selama belum ada backend nyata, "endpoint" yang ditulis di bawah adalah **representasi logis** dari operasi pada repository, bukan URL HTTP aktual.

## Teknologi yang Digunakan

Berdasarkan `pubspec.yaml`:

| Komponen | Versi / Detail |
| --- | --- |
| Framework | Flutter (SDK `^3.11.0`) |
| Bahasa | Dart |
| State Management | `provider: ^6.1.2` |
| Tipografi | `google_fonts: ^6.2.1` |
| Lokalisasi/Format | `intl: ^0.19.0` |
| Pemilih Gambar | `image_picker: ^1.1.2` |
| Caching Gambar | `cached_network_image: ^3.4.1` |
| Skeleton Loading | `shimmer: ^3.0.0` |
| Ikon iOS | `cupertino_icons: ^1.0.8` |
| Linter | `flutter_lints: ^6.0.0` |

### Arsitektur

- Pola **Feature-First + Provider + Repository Pattern**.
- Direktori utama:
  - `lib/core/` — konstanta, theme, service, widget reusable, `ApiClient` (stub).
  - `lib/features/<fitur>/data/` — `models/` dan `repositories/` (`abstract` + implementasi `dummy`).
  - `lib/features/<fitur>/presentation/` — `pages/`, `providers/`, `widgets/`.
- Fitur yang ada: `auth`, `dashboard`, `ticket`, `notification`, `profile`.

## Base URL

Belum dapat diidentifikasi dari source code yang tersedia.

> Tidak ada konfigurasi base URL pada source code. `ApiClient` belum diimplementasikan (`lib/core/network/api_client.dart` melempar `UnimplementedError`). Tidak ditemukan environment variable, file `.env`, maupun konstanta URL backend.

## Authentication

Mekanisme autentikasi yang teridentifikasi dari `AuthRepository` (`lib/features/auth/data/repositories/auth_repository.dart`) dan implementasinya pada `DummyAuthRepository`:

- Login menggunakan kombinasi **`username` + `password`**.
- Tidak ditemukan **token (JWT/OAuth)**, **session cookie**, maupun **header `Authorization`** pada kode. Status login disimpan in-memory pada field `_currentUser` di dalam `DummyAuthRepository`.
- Tidak terdapat **middleware HTTP** maupun **interceptor jaringan**.
- Otorisasi berbasis **role** dilakukan di sisi klien melalui enum `UserRole { user, helpdesk, admin }` pada `lib/features/auth/data/models/user_model.dart`. Tidak ada penegakan role di lapisan jaringan.

### Akun Demo (Seed Data)

| Username | Password | Role |
| --- | --- | --- |
| `user` | `password123` | user |
| `helpdesk` | `password123` | helpdesk |
| `admin` | `password123` | admin |

## Format Response

Tidak ada format response HTTP terstandarisasi karena belum ada backend. Repository mengembalikan objek model Dart secara langsung. Setiap model memiliki method `toMap()` / `fromMap()` yang merepresentasikan bentuk JSON-nya.

### Konvensi Serialisasi Model

- `UserModel` → `{ id, name, email, username, role, avatarUrl }`
- `TicketModel` → `{ id, ticketNumber, title, description, category, priority, status, createdAt, updatedAt, reporterId, assigneeId, attachments[], history[] }`
- `CommentModel` → `{ id, ticketId, userId, userName, content, createdAt }`
- `NotificationModel` → `{ id, title, body, type, isRead, createdAt, ticketId, userId }`
- `DashboardStatsModel` → `{ totalTickets, openCount, inProgressCount, closedCount }` (tidak memiliki `toMap`/`fromMap` pada source code).

Tanggal/waktu diserialisasikan dengan ISO 8601 (`DateTime.toIso8601String()`).

### Enum Value

| Enum | Nilai String |
| --- | --- |
| `UserRole` | `user`, `helpdesk`, `admin` |
| `TicketStatus` | `open`, `inProgress`, `closed` |
| `TicketPriority` | `low`, `medium`, `high`, `critical` |
| `NotificationType` | `ticket`, `comment`, `general` |

### Request Validation

Tidak ditemukan lapisan validasi terdedikasi (mis. JSON Schema, validator class) pada source code. Validasi yang ada bersifat ad-hoc di repository dummy, contoh:

- Login: mengembalikan `null` jika `username` tidak ditemukan atau password tidak cocok.
- Register: mengembalikan `null` jika `username` atau `email` sudah dipakai.

### Error Handling

Tidak ada hierarki exception khusus. Pola umum:

- Operasi yang gagal mengembalikan `null` (mis. login gagal, ticket tidak ditemukan).
- `Provider` (mis. `AuthProvider` pada `lib/features/auth/presentation/providers/auth_provider.dart`) membungkus pemanggilan dengan `try/catch` lalu menyimpan pesan kesalahan pada field `errorMessage` untuk ditampilkan di UI. Contoh pesan: `"Username atau password salah."`, `"Terjadi kesalahan saat login."`, `"Gagal logout."`.

## Daftar Endpoint

> Disclaimer: Berikut adalah representasi logis operasi repository, **bukan endpoint HTTP nyata**. Path dipilih sebagai konvensi RESTful untuk acuan implementasi backend di kemudian hari.

---

### [POST] /auth/login

#### Deskripsi

Melakukan otentikasi pengguna berdasarkan `username` dan `password`. Mengacu pada `AuthRepository.login()`.

#### Request

##### Header

Belum dapat diidentifikasi dari source code yang tersedia.

##### Parameter Path

Tidak ada.

##### Query Parameter

Tidak ada.

##### Body Request

```json
{
  "username": "user",
  "password": "password123"
}
```

#### Response (Sukses)

Mengembalikan `UserModel`:

```json
{
  "id": "u1",
  "name": "Ari Pratama",
  "email": "ari.user@example.com",
  "username": "user",
  "role": "user",
  "avatarUrl": null
}
```

#### Response (Gagal)

Repository mengembalikan `null`. Pesan kesalahan yang dirender di UI: `"Username atau password salah."`

---

### [POST] /auth/register

#### Deskripsi

Mendaftarkan akun pengguna baru dengan role default `user`. Mengacu pada `AuthRepository.register()`.

#### Request

##### Header

Belum dapat diidentifikasi dari source code yang tersedia.

##### Parameter Path

Tidak ada.

##### Query Parameter

Tidak ada.

##### Body Request

```json
{
  "name": "Nama Lengkap",
  "email": "user@example.com",
  "username": "username_baru",
  "password": "password123"
}
```

Semua field bersifat **wajib** (`required`).

#### Response (Sukses)

```json
{
  "id": "u4",
  "name": "Nama Lengkap",
  "email": "user@example.com",
  "username": "username_baru",
  "role": "user",
  "avatarUrl": null
}
```

#### Response (Gagal)

Repository mengembalikan `null` apabila `username` atau `email` sudah dipakai. Pesan UI: `"Username atau email sudah dipakai."`

---

### [POST] /auth/logout

#### Deskripsi

Mengakhiri sesi pengguna yang sedang aktif. Mengacu pada `AuthRepository.logout()`.

#### Request

##### Header

Belum dapat diidentifikasi dari source code yang tersedia.

##### Parameter Path

Tidak ada.

##### Query Parameter

Tidak ada.

##### Body Request

Tidak ada body.

#### Response

Tidak mengembalikan nilai (`Future<void>`).

---

### [GET] /auth/me

#### Deskripsi

Mengambil data pengguna yang sedang login. Mengacu pada `AuthRepository.getCurrentUser()`.

#### Request

##### Header

Belum dapat diidentifikasi dari source code yang tersedia.

##### Parameter Path

Tidak ada.

##### Query Parameter

Tidak ada.

##### Body Request

Tidak ada.

#### Response (Sukses)

Mengembalikan `UserModel` (lihat skema pada `/auth/login`) atau `null` jika belum login.

---

### [GET] /tickets

#### Deskripsi

Mengambil daftar tiket dengan dukungan filter status, pencarian, paginasi, dan filter reporter. Mengacu pada `TicketRepository.getTickets()`.

#### Request

##### Header

Belum dapat diidentifikasi dari source code yang tersedia.

##### Parameter Path

Tidak ada.

##### Query Parameter

| Nama | Tipe | Default | Keterangan |
| --- | --- | --- | --- |
| `status` | `string` (`open` \| `inProgress` \| `closed`) | `null` | Filter berdasarkan status tiket. |
| `query` | `string` | `""` | Pencarian berdasarkan `ticketNumber`, `title`, atau `category` (case-insensitive). |
| `page` | `integer` | `1` | Halaman paginasi. |
| `limit` | `integer` | `10` | Jumlah item per halaman. |
| `reporterId` | `string` | `null` | Filter tiket milik pelapor tertentu. |

##### Body Request

Tidak ada.

#### Response

Mengembalikan array `TicketModel`, diurutkan dari yang terbaru berdasarkan `createdAt`:

```json
[
  {
    "id": "t1",
    "ticketNumber": "TK-001",
    "title": "Printer lantai 2 tidak bisa cetak",
    "description": "Printer menampilkan kertas macet padahal tray kosong. Sudah restart perangkat.",
    "category": "Hardware",
    "priority": "medium",
    "status": "open",
    "createdAt": "2026-06-03T08:00:00.000Z",
    "updatedAt": "2026-06-03T14:00:00.000Z",
    "reporterId": "u1",
    "assigneeId": "h1",
    "attachments": [],
    "history": [
      {
        "status": "open",
        "changedBy": "System",
        "changedAt": "2026-06-03T08:00:00.000Z",
        "note": "Tiket dibuat"
      }
    ]
  }
]
```

---

### [GET] /tickets/{ticketId}

#### Deskripsi

Mengambil detail satu tiket berdasarkan `id`. Mengacu pada `TicketRepository.getTicketById()`.

#### Request

##### Header

Belum dapat diidentifikasi dari source code yang tersedia.

##### Parameter Path

| Nama | Tipe | Keterangan |
| --- | --- | --- |
| `ticketId` | `string` | ID tiket internal (mis. `t1`). |

##### Query Parameter

Tidak ada.

##### Body Request

Tidak ada.

#### Response (Sukses)

`TicketModel` (lihat skema pada `/tickets`).

#### Response (Gagal)

Repository mengembalikan `null` jika tiket tidak ditemukan.

---

### [POST] /tickets

#### Deskripsi

Membuat tiket baru. Status awal otomatis `open`, `ticketNumber` di-generate dengan format `TK-XXX`. Mengacu pada `TicketRepository.createTicket()`.

#### Request

##### Header

Belum dapat diidentifikasi dari source code yang tersedia.

##### Parameter Path

Tidak ada.

##### Query Parameter

Tidak ada.

##### Body Request

```json
{
  "title": "Judul singkat masalah",
  "description": "Deskripsi detail masalah",
  "category": "Hardware",
  "priority": "medium",
  "reporterId": "u1",
  "attachments": []
}
```

Field wajib: `title`, `description`, `category`, `priority`, `reporterId`. Field `attachments` opsional (default `[]`).

#### Response

`TicketModel` yang baru dibuat, dengan `status` = `open`, `assigneeId` = `null`, dan satu entri `history` awal:

```json
{
  "id": "t16",
  "ticketNumber": "TK-016",
  "title": "Judul singkat masalah",
  "description": "Deskripsi detail masalah",
  "category": "Hardware",
  "priority": "medium",
  "status": "open",
  "createdAt": "2026-06-04T10:00:00.000Z",
  "updatedAt": "2026-06-04T10:00:00.000Z",
  "reporterId": "u1",
  "assigneeId": null,
  "attachments": [],
  "history": [
    {
      "status": "open",
      "changedBy": "Pelapor",
      "changedAt": "2026-06-04T10:00:00.000Z",
      "note": "Tiket dibuat"
    }
  ]
}
```

---

### [PATCH] /tickets/{ticketId}/status

#### Deskripsi

Memperbarui status tiket dan menambahkan entri pada `history`. Mengacu pada `TicketRepository.updateStatus()`.

#### Request

##### Header

Belum dapat diidentifikasi dari source code yang tersedia.

##### Parameter Path

| Nama | Tipe | Keterangan |
| --- | --- | --- |
| `ticketId` | `string` | ID tiket. |

##### Query Parameter

Tidak ada.

##### Body Request

```json
{
  "status": "inProgress",
  "updatedBy": "Nadia Helpdesk",
  "note": "Sedang ditangani"
}
```

Field wajib: `status`, `updatedBy`. Field `note` opsional.

#### Response (Sukses)

`TicketModel` yang telah diperbarui (dengan `history` baru).

#### Response (Gagal)

Repository mengembalikan `null` jika tiket tidak ditemukan.

---

### [PATCH] /tickets/{ticketId}/assign

#### Deskripsi

Menetapkan tiket kepada seorang assignee. Mengacu pada `TicketRepository.assignTicket()`.

#### Request

##### Header

Belum dapat diidentifikasi dari source code yang tersedia.

##### Parameter Path

| Nama | Tipe | Keterangan |
| --- | --- | --- |
| `ticketId` | `string` | ID tiket. |

##### Query Parameter

Tidak ada.

##### Body Request

```json
{
  "assigneeId": "h1",
  "updatedBy": "Raka Admin"
}
```

Kedua field wajib.

#### Response (Sukses)

`TicketModel` dengan `assigneeId` terisi dan satu entri tambahan pada `history` bernote `"Tiket di-assign ke <assigneeId>"`.

#### Response (Gagal)

Repository mengembalikan `null` jika tiket tidak ditemukan.

---

### [GET] /tickets/{ticketId}/comments

#### Deskripsi

Mengambil seluruh komentar pada sebuah tiket, diurutkan dari yang paling lama (`createdAt` ascending). Mengacu pada `TicketRepository.getComments()`.

#### Request

##### Header

Belum dapat diidentifikasi dari source code yang tersedia.

##### Parameter Path

| Nama | Tipe | Keterangan |
| --- | --- | --- |
| `ticketId` | `string` | ID tiket. |

##### Query Parameter

Tidak ada.

##### Body Request

Tidak ada.

#### Response

Array `CommentModel`:

```json
[
  {
    "id": "c1",
    "ticketId": "t1",
    "userId": "u1",
    "userName": "Ari Pratama",
    "content": "Mohon dibantu follow up untuk tiket ini.",
    "createdAt": "2026-06-03T09:00:00.000Z"
  }
]
```

---

### [POST] /tickets/{ticketId}/comments

#### Deskripsi

Menambahkan komentar baru pada sebuah tiket. Mengacu pada `TicketRepository.addComment()`.

#### Request

##### Header

Belum dapat diidentifikasi dari source code yang tersedia.

##### Parameter Path

| Nama | Tipe | Keterangan |
| --- | --- | --- |
| `ticketId` | `string` | ID tiket. |

##### Query Parameter

Tidak ada.

##### Body Request

```json
{
  "userId": "u1",
  "userName": "Ari Pratama",
  "content": "Update terbaru dari pelapor."
}
```

Seluruh field wajib.

#### Response

`CommentModel` yang baru dibuat (dengan `id` dan `createdAt` di-generate server-side).

---

### [GET] /dashboard/stats

#### Deskripsi

Mengambil ringkasan statistik tiket. Mengacu pada `DashboardRepository.getStats()`.

#### Request

##### Header

Belum dapat diidentifikasi dari source code yang tersedia.

##### Parameter Path

Tidak ada.

##### Query Parameter

| Nama | Tipe | Default | Keterangan |
| --- | --- | --- | --- |
| `reporterId` | `string` | `null` | Bila diisi, statistik dibatasi pada tiket milik reporter tersebut. |

##### Body Request

Tidak ada.

#### Response

```json
{
  "totalTickets": 12,
  "openCount": 4,
  "inProgressCount": 4,
  "closedCount": 4
}
```

---

### [GET] /dashboard/recent-tickets

#### Deskripsi

Mengambil tiket terbaru yang diurutkan berdasarkan `updatedAt` (desc). Mengacu pada `DashboardRepository.getRecentTickets()`.

#### Request

##### Header

Belum dapat diidentifikasi dari source code yang tersedia.

##### Parameter Path

Tidak ada.

##### Query Parameter

| Nama | Tipe | Default | Keterangan |
| --- | --- | --- | --- |
| `reporterId` | `string` | `null` | Filter berdasarkan reporter. |
| `limit` | `integer` | `5` | Jumlah maksimum tiket yang dikembalikan. |

##### Body Request

Tidak ada.

#### Response

Array `TicketModel` (lihat skema pada `/tickets`).

---

### [GET] /notifications

#### Deskripsi

Mengambil daftar notifikasi, diurutkan dari terbaru (`createdAt` desc). Mengacu pada `NotificationRepository.getNotifications()`.

#### Request

##### Header

Belum dapat diidentifikasi dari source code yang tersedia.

##### Parameter Path

Tidak ada.

##### Query Parameter

| Nama | Tipe | Default | Keterangan |
| --- | --- | --- | --- |
| `userId` | `string` | `null` | Filter notifikasi untuk user tertentu. |

##### Body Request

Tidak ada.

#### Response

Array `NotificationModel`:

```json
[
  {
    "id": "n1",
    "title": "Status tiket diperbarui",
    "body": "Tiket TK-002 berubah menjadi In Progress.",
    "type": "ticket",
    "isRead": false,
    "createdAt": "2026-06-04T09:15:00.000Z",
    "ticketId": "t2",
    "userId": "u1"
  }
]
```

---

### [PATCH] /notifications/{notificationId}/read

#### Deskripsi

Menandai sebuah notifikasi sebagai sudah dibaca. Mengacu pada `NotificationRepository.markAsRead()`.

#### Request

##### Header

Belum dapat diidentifikasi dari source code yang tersedia.

##### Parameter Path

| Nama | Tipe | Keterangan |
| --- | --- | --- |
| `notificationId` | `string` | ID notifikasi. |

##### Query Parameter

Tidak ada.

##### Body Request

Tidak ada body.

#### Response

Tidak mengembalikan nilai (`Future<void>`). Bila ID tidak ditemukan, operasi diabaikan tanpa error.

---

### [GET] /users/{userId}

#### Deskripsi

Mengambil profil pengguna berdasarkan `userId`. Mengacu pada `ProfileRepository.getUserProfile()`.

#### Request

##### Header

Belum dapat diidentifikasi dari source code yang tersedia.

##### Parameter Path

| Nama | Tipe | Keterangan |
| --- | --- | --- |
| `userId` | `string` | ID pengguna. |

##### Query Parameter

Tidak ada.

##### Body Request

Tidak ada.

#### Response

`UserModel` atau `null` jika tidak ditemukan.

---

### [PUT] /users/{userId}

#### Deskripsi

Memperbarui profil pengguna. Mengacu pada `ProfileRepository.updateProfile()`.

#### Request

##### Header

Belum dapat diidentifikasi dari source code yang tersedia.

##### Parameter Path

| Nama | Tipe | Keterangan |
| --- | --- | --- |
| `userId` | `string` | ID pengguna. |

##### Query Parameter

Tidak ada.

##### Body Request

Menggunakan struktur lengkap `UserModel`:

```json
{
  "id": "u1",
  "name": "Ari Pratama",
  "email": "ari.user@example.com",
  "username": "user",
  "role": "user",
  "avatarUrl": null
}
```

#### Response

`UserModel` yang sudah diperbarui.

---

## Catatan Akhir

- **Middleware:** Tidak ditemukan implementasi middleware HTTP pada source code.
- **Interceptor / Logging Jaringan:** Tidak ditemukan.
- **Rate Limiting / Throttling:** Tidak ditemukan.
- **Versioning API:** Tidak ditemukan.
- **OpenAPI / Swagger spec:** Tidak ditemukan.
- **Testing:** Direktori `test/` tersedia namun belum diaudit dalam dokumentasi ini.

Dokumentasi ini akan perlu diperbarui ketika `ApiClient` (`lib/core/network/api_client.dart`) dan repository non-dummy mulai diimplementasikan, terutama setelah migrasi backend ke Supabase sesuai rencana yang disebut pada `README.md`.
