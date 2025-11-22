# Panduan Membersihkan Cache dan Build Ulang Proyek Flutter

Berikut adalah langkah-langkah yang dapat Anda lakukan untuk memastikan proyek Flutter Anda menggunakan kode terbaru tanpa cache lama yang keliru, sehingga masalah typo baseUrl dan endpoint penghapusan dapat teratasi:

## 1. Membersihkan Cache Flutter
Buka terminal dan jalankan perintah berikut untuk membersihkan cache build Flutter:

```
flutter clean
```

Perintah ini akan menghapus direktori build dan cache proyek.

## 2. Mengunduh ulang dependencies
Setelah membersihkan cache, jalankan:

```
flutter pub get
```

Perintah ini akan mengunduh ulang semua dependencies yang dibutuhkan proyek Anda.

## 3. Build ulang aplikasi
Setelah dependencies selesai diunduh, build ulang aplikasi Anda dengan menjalankan:

```
flutter build apk
```
atau jika Anda menggunakan iOS:

```
flutter build ios
```

Atau jika Anda hanya ingin menjalankan aplikasi di emulator/debug mode, gunakan:

```
flutter run
```

## 4. Menjalankan kembali pengujian
Setelah build ulang berhasil, jalankan pengujian kembali untuk memastikan:

- BaseUrl sudah benar (tidak ada typo).
- Endpoint deleteProduct sudah benar.
- Token otentikasi valid digunakan pada pengujian.
- Produk berhasil dibuat dan dihapus dengan baik.

Jalankan perintah pengujian:

```
flutter test test/produk_service_test.dart
```

## 5. Verifikasi
Pastikan output pengujian menunjukkan semua tes berhasil tanpa error, termasuk penghapusan produk.

---

Jika Anda ingin, saya bisa bantu membuat skrip otomatis menjalankan langkah-langkah di atas, atau bantu analisa hasil pengujian berikutnya.

Mohon konfirmasi apakah Anda ingin skrip otomatis atau bantuan lain.
