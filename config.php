<?php
/**
 * ============================================================
 *  KONFIGURASI APLIKASI LAUNDRY POS
 *  ------------------------------------------------------------
 *  WAJIB DIEDIT: isi 3 baris bertanda (GANTI) di bawah ini
 *  sesuai database yang Anda buat di cPanel.
 * ============================================================
 *
 *  CARA MENDAPATKAN NILAI INI (di cPanel):
 *  1. Buka menu  "MySQL® Databases"
 *  2. Buat database   -> contoh hasil: tokoku_laundry
 *  3. Buat user + password -> contoh hasil: tokoku_kasir
 *  4. Klik "Add User To Database", centang ALL PRIVILEGES
 *  5. Salin nilai-nilai tersebut ke bawah ini.
 *
 *  Catatan: di cPanel, nama database & user otomatis diberi
 *  awalan nama akun hosting Anda (contoh di atas memakai
 *  akun "tokoku").
 */

if (count(get_included_files()) === 1) {
    http_response_code(403);
    exit('Akses langsung tidak diizinkan.');
}

return [

    // Host database. Di hampir semua hosting cPanel cukup: localhost
    'db_host' => 'localhost',

    // (GANTI) Nama database yang sudah di-import laundry-pos.sql
    'db_name' => 'kpanelu_laundry',

    // (GANTI) Username database yang punya hak akses ke database di atas
    'db_user' => 'root',

    // (GANTI) Password user database tersebut
    'db_pass' => '',

    // Port MySQL standar. Biarkan 3306 kecuali hosting Anda berbeda.
    'db_port' => 3306,

    // Zona waktu aplikasi (WIB). Tidak perlu diubah.
    'timezone' => 'Asia/Jakarta',
];
