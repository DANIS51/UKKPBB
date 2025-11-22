@echo off
REM Membersihkan cache dan build ulang proyek Flutter lalu jalankan pengujian produk

echo Membersihkan cache Flutter...
flutter clean

echo Mengunduh dependencies...
flutter pub get

echo Build ulang aplikasi (release)...
flutter build apk

echo Menjalankan pengujian unit pada file produk_service_test.dart...
flutter test test/produk_service_test.dart

echo Selesai. Mohon cek hasil pengujian.
pause
