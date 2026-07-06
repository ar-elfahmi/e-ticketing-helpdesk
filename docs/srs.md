## Page 1

# Software Requirement Specification

## Aplikasi Mobile Apps
## E-Ticketing Helpdesk

Versi : 2.0.0
Tanggal : 18 Juni 2026

---


## Page 2

1. Pendahuluan
1.1. Tujuan Dokumen
Dokumen ini menjelaskan kebutuhan fungsional dan non fungsional untuk pengembangan aplikasi mobile E-Ticketing Helpdeskyang akan digunakan untuk pelaporan, monitoring dan penyelesaian masalah IT atau layanan lainnya.
Fokus dokumen ini adalah :
* Antarmuka pengguna (UI/UX).
* Pengelolaan state pada aplikasi mobile.
* Interaksi dengan API (backend).
* Manajemen data dan penyimpanan file.
* Notifikasi dan komunikasi antar pengguna.
* Keamanan system.
* Skalabilitas dan mintenability sistem.

1.2. Ruang Lingkup
Sistem ini mencakup:
1.2.1. Pengguna
* Membuat tiket keluhan.
* Melihat status tiket.
* Melihat Riwayat perjalanan tiket.
* Berkomunikasi dengan helpdesk.
* Mendapat notifikasi perubahan tiket.
* Statistik tiket.

1.2.2. Helpdesk
* Membuat tiket.
* Menangani tiket yang ditugaskan.
* Memberikan respon.
* Mengubah status tiket.
* Melihat riwayat perjalanan tiket.
* Statistik tiket yang ditugaskan.

&lt;page_number&gt;2&lt;/page_number&gt;
Aplikasi Mobile (Praktikum) – DIV Teknik Informatika Universitas Airlangga

---


## Page 3

1.2.3. Admin
* Membuat tiket.
* Mengelola seluruh tiket.
* Mengelola pengguna.
* Melihat statistik sistem.

2. Deskripsi Umum Sistem
2.1. Perspektif Produk
Sistem ini merupakan client mobile yang terhubung dengan backend API (RESTful).
Aritektur :
2.1.1. Frontend.
* Flutter.
* Riverpod / BloC.
2.1.2. Backend (salah satu).
* Laravel.
* Golang.
* Supabase.
* Node.js.
* Firebase.
2.1.3. Database (salah satu).
* MySQL.
* PostgreSQL.

2.2. Karakteristik Pengguna
<table>
  <thead>
    <tr>
      <th>Tipe User</th>
      <th>Deskripsi</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Admin</td>
      <td>Pengelola sistem</td>
    </tr>
    <tr>
      <td>Helpdesk</td>
      <td>Petugas support</td>
    </tr>
    <tr>
      <td>User</td>
      <td>Pelapor tiket</td>
    </tr>
  </tbody>
</table>

<footer>Aplikasi Mobile (Praktikum) – DIV Teknik Informatika Universitas Airlangga</footer>
&lt;page_number&gt;3&lt;/page_number&gt;

---


## Page 4

3. Functional Requirement
    3.1. Authentikasi & User Management
        FR-001: Login
        Deskripsi : Pengguna dapat login menggunakan username/email dan password.
        Aktor : Semua tipe pengguna.

        FR-002: Logout
        Deskripsi : Pengguna dapat logout dari aplikasi.
        Aktor : Semua tipe pengguna.

        FR-003: Register
        Deskripsi : Pengguna dapat melakukan pendaftaran aplikasi.
        Aktor : Pengguna.

        FR-004: Reset Password
        Deskripsi : Pengguna dapat logout dari aplikasi.
        Aktor : Semua tipe pengguna.

        BR-001 : Authentication Service
        Fungsi : Login, Register, Logout, Reset password & Session management.

    3.2. Management Tiket
        FR-005 : Pengguna
        Deskripsi : Pengguna dapat melakukan permintaan layanan.
        Aktor : Pengguna.
        Flow :
            1. Membuat tiket.
            2. Upload laporan (gambar/file input bisa upload atau dari kamera).

&lt;page_number&gt;4&lt;/page_number&gt;
Aplikasi Mobile (Praktikum) – DIV Teknik Informatika Universitas Airlangga

---


## Page 5

3. Melihat daftar tiket.
4. Melihat detail tiket.
5. Melihat histori perjalanan tiket.
6. Mendapatkan notifikasi perubahan tiket.
7. Memberikan komentar / reply.
8. Melihat statistik tiket.

**FR-006 : Helpdesk**
Deskripsi : Helpdesk dapat melakukan pengelolaan tiket.
Aktor : Helpdesk.
Flow :
1. Membuat tiket.
2. Melihat semua tiket yang ditugaskan.
3. Menangani semua tiket yang ditugaskan.
4. Update status pengerjaan tiket yang ditugaskan.
5. Memberikan tanggapan terhadap tiket yang ditugaskan.
6. Menutup tiket yang ditugaskan.
7. Melihat statistik tiket yang ditugaskan.

**FR-007 : Admin**
1. Membuat tiket.
2. Melihat semua tiket yang masuk.
3. Melihat semua tiket berdasarkan helpdesk yang ditugaskan.
4. Menugaskan helpdesk untuk mengerjakan tiket masuk.
5. Mengubah status tiket.
6. Memberikan respon.
7. Mengelola daftar pengguna.

<footer>Aplikasi Mobile (Praktikum) – DIV Teknik Informatika Universitas Airlangga</footer>
&lt;page_number&gt;5&lt;/page_number&gt;

---


## Page 6

**BR-002 : Tiket Service**
Fungsi :
1. Create tiket.
2. Upload file/image.
3. Get list tiket.
4. Get detail tiket.
5. Tracking tiket.
6. Update status tiket.
7. Assign tiket.
8. Delete tiket.
9. Non aktif pengguna.
10. Menambah komentar.
11. Menampilkan komentar.

**3.3. Notifikasi**
**FR-008 : Notification**
Deskripsi : Admin/Helpdesk/pengguna menerima pemberitahuan terkait aktivitas tiket.
Actor : Semua tipe pengguna
Flow :
1. Menampilkan pemberitahuan status tiket.
2. Navigasi ke halaman terkait.

**BR-003 : Notification Service**
Menggunakan : Supabase Realtime / Firebase Cloud Messaging (FCM) / Local Notification.

<footer>Aplikasi Mobile (Praktikum) – DIV Teknik Informatika Universitas Airlangga</footer>
&lt;page_number&gt;6&lt;/page_number&gt;

---


## Page 7

3.4. Dashboard
**FR-009 : Statistik Tiket**
Deskripsi : Menampilkan data ringkasan tiket. Informasi yang ditampilkan :
* Total tiket.
* Open tiket.
* Assign tiket.
* In progress tiket.
* Closed tiket.
Aktor : Semua tipe Pengguna.

**BR-004 : Dashboard Service**
Menghasilkan data :
* Jumlah tiket.
* Jumlah tiket berdasarkan status tiket.

3.5. Riwayat & Tracking
**FR-010 : Riwayat Tiket**
Deskripsi : Menampilkan riwayat penanganan tiket yang masuk dan di minta dari aktivitas semua tipe pengguna.
Aktor : Semua tipe pengguna.

**FR-011 : Tracking Tiket**
Deskripsi : Menampilkan status penanganan tiket yang masuk dan di minta dari aktivitas semua tipe user.
* User melihat status dan tracking dari tiket yang sedang aktif
* Helpdesk melihat status dan tracking dari masing-masing tiket yang sedang ditangani.

<footer>Aplikasi Mobile (Praktikum) – DIV Teknik Informatika Universitas Airlangga</footer>
&lt;page_number&gt;7&lt;/page_number&gt;

---


## Page 8

*   Admin melihat status dan tracking masing-masing tiket yang belum ter-close
Aktor : Semua tipe pengguna.

**BR-005 : History Service**
Fungsi :
*   Menyimpan perubahan status tiket.
*   Menyimpan aktifitas pengguna.
*   Menyediakan tracking tiket.

**4. Non-Functional Requirement**
**4.1. Performance**
*   Lazy loading list
**4.2. Usability**
*   UI responsive
*   Konsisten antar halaman
*   Mudah digunakan
**4.3. Compatibility**
*   Android & iOS
*   Berbagai ukuran layar
**4.4. Maintainability**
*   Menggunakan clean architecture
**4.5. Security**
*   Authentication
    *   Supabase Auth.
    *   JWT Token.
*   Authorization
    *   Role pengguna : pengguna, helpdesk, admin.

&lt;page_number&gt;8&lt;/page_number&gt;
Aplikasi Mobile (Praktikum) – DIV Teknik Informatika Universitas Airlangga

---


## Page 9

5. UI/UX Screen
5.1 Splash Screen.
5.2 Login Screen.
5.3 Register Screen.
5.4 Forgot Password Screen.
5.5 Dashboard Screen.
5.6 List Tiket Screen.
5.7 Detail Tiket Screen.
5.8 Tracking Tiket Screen.
5.9 Create Tiket Screen.
5.10 Notification Screen.
5.11 Profile Screen.
5.12 Setting Screen.
5.13 Dark & light mode.

## lainya:
logic bisnis status:
1. user simpan, otomatis tersimpan dengan status open
2. ⁠ketika admin menerima ubah menjadi assign
3. ⁠ketika tiket dengan status assign di pilih helpdesk, maka status otomatis berubah menjadi on progress (helpdesk hanya bisa menerima yang status=assign)
4. ⁠kelika selesai mengerjakan, helpdesk klik selesai atau finish update statusnya berubah menjadi close

##Q&A
Register helpdesk: Apakah siapa saja boleh register sebagai helpdesk? Atau hanya admin yang bisa membuat akun helpdesk?
Hanya admin yang bisa buat

Forgot password: Apakah cukup gunakan fitur bawaan Supabase Auth yang kirim link reset via email? Atau mau custom kode OTP (6 digit) yang dikirim email?
Gunakan Supabase Auth

Notifikasi: Apakah notifikasi cukup in-app saja (di halaman notifikasi), atau juga dikirim via email?
In-app saja dengan detail notifikasi:
admin: tiket baru
user: status tiket berubah
helpdesk: tiket baru status assign

Upload file: Apakah perlu batasan ukuran file? Berapa maksimal?
Maks 5 MB

Delete ticket: Hard delete (hapus permanen) atau soft delete (ubah status jadi 'deleted' atau arsipkan)?
Soft delete

&lt;page_number&gt;9&lt;/page_number&gt;
Aplikasi Mobile (Praktikum) – DIV Teknik Informatika Universitas Airlangga