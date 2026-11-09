import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:poliwangi_mobile_starter/modul_11/data/sumber_tugas_contoh.dart';
import 'package:poliwangi_mobile_starter/modul_11/domain/filter_tugas.dart';
import 'package:poliwangi_mobile_starter/modul_11/domain/tugas_performa.dart';
import 'package:poliwangi_mobile_starter/modul_11/screens/daftar_tugas_performa_screen.dart';
import 'package:poliwangi_mobile_starter/modul_11/widgets/kartu_tugas_performa.dart';

void main() {
  group('Logika Filter Tugas', () {
    test('Data sumber berisi 1000 tugas', () {
      expect(sumberTugasContoh.length, 1000);
    });

    test('Filter "basis data" menghasilkan 125 tugas', () {
      final hasil = filterTugas(sumberTugasContoh, 'basis data', null);
      expect(hasil.length, 125);
    });

    test('Filter status Selesai menghasilkan 250 tugas', () {
      final hasil = filterTugas(sumberTugasContoh, '', StatusTugas.selesai);
      expect(hasil.length, 250);
    });
  });

  group('Widget: Skenario Daftar Tugas', () {
    Future<void> pumpApp(WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: DaftarTugasPerformaScreen()),
      );
      await tester.pumpAndSettle();
    }

    Future<void> ketik(WidgetTester tester, String q) async {
      await tester.enterText(find.byKey(const ValueKey('task-search')), q);
      await tester.pumpAndSettle();
    }

    Future<void> pilihFilter(WidgetTester tester, String label) async {
      await tester.tap(find.text(label).first);
      await tester.pumpAndSettle();
    }

    testWidgets('Awal dibuka menampilkan 1000 tugas', (tester) async {
      await pumpApp(tester);
      expect(find.text('Menampilkan 1000 dari 1000 tugas'), findsOneWidget);
    });

    testWidgets('Cari "0002" + Selesai = 0 dan pesan kosong', (tester) async {
      await pumpApp(tester);
      await ketik(tester, 'tugas praktikum 0002');
      await pilihFilter(tester, 'Selesai');
      expect(find.text('Menampilkan 0 dari 1000 tugas'), findsOneWidget);
      expect(find.text('Tidak ada tugas yang cocok.'), findsOneWidget);
    });
  });

  group('Widget: Lazy Build', () {
    testWidgets('Hanya merender widget yang terlihat di layar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: DaftarTugasPerformaScreen()),
      );
      await tester.pumpAndSettle();

      final builtCards = find.byType(KartuTugasPerforma).evaluate().length;
      expect(builtCards, greaterThan(0));
      expect(builtCards, lessThan(50), 
          reason: 'ListView.builder harusnya lazy, bukan membuat 1000 widget sekaligus');
    });
  });
}