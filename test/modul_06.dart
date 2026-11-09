import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Sesuaikan path import ini dengan struktur folder proyek Anda
import '../lib/modul_06/screens/login_screen.dart';
import '../lib/modul_06/services/auth_api.dart';
import '../lib/modul_06/services/sesi_memori.dart';

void main() {
  testWidgets('Kasus Uji A4: Tekan Masuk dua kali cepat selama proses login', (WidgetTester tester) async {
    // 1. Arrange (Persiapan)
    final AuthApi authApi = const AuthApi(tunda: Duration(milliseconds: 600));
    
    // Reset penghitung menggunakan nama method yang sesuai dari AuthApi Anda
    AuthApi.resetCallCount();

    // Inisialisasi SesiMemori 
    final SesiMemori sesiMemori = SesiMemori(); 

    // Bangun widget LoginScreen di dalam MaterialApp
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(
          api: authApi,
          sesiMemori: sesiMemori,
        ),
      ),
    );

    // 2. Masukkan kredensial dummy yang sah ke form
    final finderEmail = find.byType(TextFormField).first;
    final finderSandi = find.byType(TextFormField).last;

    await tester.enterText(finderEmail, AuthApi.emailDemo);
    await tester.enterText(finderSandi, AuthApi.sandiDemo);
    await tester.pump();

    // 3. Act (Tindakan): Temukan tombol Masuk/FilledButton
    final finderTombolMasuk = find.byType(FilledButton);
    expect(finderTombolMasuk, findsOneWidget);

    // Ketuk tombol "Masuk" pertama kali untuk memulai proses async
    await tester.tap(finderTombolMasuk);
    
    // Langsung ketuk tombol "Masuk" untuk kedua kalinya dengan cepat (sebelum proses selesai)
    await tester.tap(finderTombolMasuk);

    // Berikan pump agar UI merespons perubahan state menjadi "memproses" (disabled)
    await tester.pump();

    // 4. Assert (Verifikasi)
    await tester.pumpAndSettle();

    // - Kriteria Uji A4: Pemanggilan `masuk()` harus tetap 1 (tidak boleh 2 kali meskipun ditekan cepat)
    expect(authApi.callCount, equals(1), 
      reason: 'Pengiriman ganda terdeteksi! Method masuk() terpanggil lebih dari sekali.');
  });
}