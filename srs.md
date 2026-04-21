# Software Requirement Specification

# Aplikasi Mobile Apps (Frontend)

# E-Ticketing Helpdesk

## Versi : 1.0.

## Tanggal : 8 April 2026


**1. Pendahuluan**
    **1.1. Tujuan Dokumen**
       Dokumen ini menjelaskan kebutuhan fungsional dan non fungsional untuk
       pengembangan aplikasi mobile (frontend) E-Ticketing Helpdesk berbasis Flutter yang
       akan digunakan untuk pelaporan, monitoring dan penyelesaian masalah IT atau layanan
       lainnya.
       Fokus dokumen ini adalah :
          - Antarmuka pengguna (UI/UX)
          - Interaksi dengan API (backend)
          - Pengelolaan state dan data disisi client

```
1.2. Ruang Lingkup
Sistem ini mencakup:
1.2.1. Pengguna
```
- Membuat tiket keluhan
- Melihat status tiket
- Berkomunikasi dengan helpdesk
- Mendapat notifikasi update tiket

```
1.2.2. Admin/Helpdesk
```
- Mengelola Tiket
- Memberikan respon
- Mengubah status tiket


**2. Deskripsi Umum Sistem**
    **2.1. Perspektif Produk**
    Sistem ini merupakan client mobile yang terhubung dengan backend API (RESTful).
    Aritektur :
    - Mobile : Flutter
    - Backend : Golang / Node.js / Laravel (opsional)
    - Database : PostgreeSQL / MySQL
    - BaaS (Backend-as-a-Service) : Supabase / Firebase


2.2. Karakteristik  Pengguna

| Tipe User | Deskripsi |
| :--- | :--- |
| **Admin** | Pengelola sistem |
| **Helpdesk** | Petugas support |
| **User** | Pelapor tiket |
---


**3. Functional Requirement**
    **3.1. Authentikasi & User Management**
       **FR-001: Login**
       Deskripsi : Pengguna dapat login menggunakan username dan password
       Actor : Semua tipe user

```
FR-002: Logout
Deskripsi : Pengguna dapat logout dari aplikasi
Actor : Semua tipe user
```
```
FR-003: Register
Deskripsi : Pengguna dapat melakukan pendaftaran aplikasi
Actor : user
```
```
FR-004: Reset Password
Deskripsi : Pengguna dapat logout dari aplikasi
Actor : Semua tipe user
```
```
3.2. Management Tiket
FR-005 : User
Deskripsi : User dapat melakukan permintaan layanan
Actor : user
Flow :
```
1. Membuat tiket
2. Upload laporan (gambar/file input bisa upload atau dari kamera)
3. Melihat daftar tiket
4. Melihat detail tiket
5. Memberikan komentar / reply


```
FR-006 : Helpdesk/Admin
Deskripsi : Admin/Helpadesk dapat melakukan manajemen tiket
Actor : Helpdesk dan Admin
Flow :
```
1. Melihat semua tiket
2. Fitur tiket
3. Update status
4. Assign tiket

**3.3. Notifikasi
FR-007 : Notification**
Deskripsi : Admin/Helpadesk dapat melakukan manajemen tiket
Actor : Semua tipe user
Flow :

1. Menampilkan pemberitahuan status tiket
2. Navigasi ke halaman terkait

**3.4. Dashboard
FR-008 : Statistik Tiket**
Deskripsi : Menampilkan data ringkasan tiket

- Total tiket
- Status tiket
Actor : Semua tipe user

**3.5. Riwayat & Tracking
FR-010 : Riwayat Tiket**
Deskripsi : Menampilkan riwayat penanganan tiket yang masuk dan di
minta dari aktivitas semua tipe user
Actor : Semua tipe user


```
FR-011 : Tracking Tiket
Deskripsi : Menampilkan status penanganan tiket yang masuk dan di
minta dari aktivitas semua tipe user
```
- User melihat status tracking dari tiket yang sedang aktif
- Helpdesk/admin melihat statu dari masing-masing tiket
    yang sedang ditangani
Actor : Semua tipe user
**4. Non-Functional Requirement
4.1. Performance**
- Lazy loading list
**4.2. Usability**
- UI responsive
- Konsisten antar halaman
- Mudah digunakan
**4.3. Compatibility**
- Android & iOS
- Berbagai ukuran layar
**4.4. Maintainability**
- Menggunakan clean architecture
**5. UI/UX Screen**
- Splash Screen
- Login Screen
- Dashboard
- List Tiket
- Detail Tiket


- Create Tiket
- Profile
- Dark & light mode


